import { OpenAPIHono } from '@hono/zod-openapi';
import type { Context } from 'hono';
import { HTTPException } from 'hono/http-exception';
import type { AuthVariables } from '../middleware/auth.js';
import type { RequestVariables } from '../middleware/request-id.js';
import { apiError, validationError, validationHook } from './errors.js';

type CreateOpenAPIAppOptions = {
  onUnhandledError?: (error: Error, c: Context) => void;
};

export function createOpenAPIApp(options: CreateOpenAPIAppOptions = {}) {
  const app = new OpenAPIHono<{
    Variables: AuthVariables & RequestVariables;
  }>({
    defaultHook: validationHook,
  });

  app.onError((error, c) => {
    if (isJsonParseError(error)) {
      return c.json(validationError(error), 400);
    }

    options.onUnhandledError?.(error, c);
    return c.json(
      apiError('internal_server_error', 'Internal server error'),
      500,
    );
  });

  return app;
}

function isJsonParseError(error: Error) {
  return isOpenAPIJsonParseError(error) || isJsonSyntaxError(error);
}

function isOpenAPIJsonParseError(error: Error) {
  return (
    error instanceof HTTPException &&
    error.status === 400 &&
    error.message === 'Malformed JSON in request body'
  );
}

function isJsonSyntaxError(error: Error) {
  return (
    (error instanceof SyntaxError || error.name === 'SyntaxError') &&
    (error.message === 'Unexpected end of JSON input' ||
      /\bin JSON at position \d+\b/.test(error.message))
  );
}
