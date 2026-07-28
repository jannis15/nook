import { z } from '@hono/zod-openapi';
import type { Context } from 'hono';

export const apiErrorCodes = [
  'validation_error',
  'missing_bearer_token',
  'invalid_bearer_token',
  'not_found',
  'profile_not_found',
  'conflict',
  'internal_server_error',
] as const;

export type ApiErrorCode = (typeof apiErrorCodes)[number];

export const errorResponseSchema = z.object({
  error: z.object({
    code: z.enum(apiErrorCodes),
    message: z.string(),
    details: z
      .array(
        z.object({
          path: z.string(),
          message: z.string(),
        }),
      )
      .optional(),
  }),
});

export type ApiError<Code extends ApiErrorCode = ApiErrorCode> = {
  error: {
    code: Code;
    message: string;
    details?: Array<{
      path: string;
      message: string;
    }>;
  };
};

type ValidationIssue = {
  path: Array<PropertyKey>;
  message: string;
};

export function apiError<const Code extends ApiErrorCode>(
  code: Code,
  message: string,
  details?: ApiError<Code>['error']['details'],
): ApiError<Code> {
  return {
    error: {
      code,
      message,
      ...(details ? { details } : {}),
    },
  };
}

export function validationError(error: unknown): ApiError<'validation_error'> {
  const issues = getValidationIssues(error);

  return apiError(
    'validation_error',
    'Invalid request',
    issues.map((issue) => ({
      path: issue.path.join('.'),
      message: issue.message,
    })),
  );
}

export function validationHook(
  result: { success: boolean; error?: unknown },
  c: Context,
) {
  if (!result.success) {
    return c.json(validationError(result.error), 400);
  }
}

function getValidationIssues(error: unknown): ValidationIssue[] {
  if (
    error &&
    typeof error === 'object' &&
    'issues' in error &&
    Array.isArray(error.issues)
  ) {
    return error.issues.filter(isValidationIssue);
  }

  return [];
}

function isValidationIssue(issue: unknown): issue is ValidationIssue {
  return (
    !!issue &&
    typeof issue === 'object' &&
    'path' in issue &&
    Array.isArray(issue.path) &&
    'message' in issue &&
    typeof issue.message === 'string'
  );
}
