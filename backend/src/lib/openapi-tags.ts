export const openApiTags = {
  health: 'Health',
  media: 'Media',
  profiles: 'Profiles',
} as const;

export type OpenApiTag = (typeof openApiTags)[keyof typeof openApiTags];
