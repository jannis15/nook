import { GoogleAuth } from 'google-auth-library';
import { env } from '../env.js';
import { logger } from './logger.js';

export async function triggerMediaWorker(mediaId: string): Promise<void> {
  const jobName = env.cloudRunJobName;
  if (!jobName) return;

  if (!env.gcpProjectId || !env.gcpRegion) {
    throw new Error(
      'GCP_PROJECT_ID and GCP_REGION are required when MEDIA_WORKER_JOB_NAME is set',
    );
  }

  const auth = new GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/cloud-platform'],
  });
  const client = await auth.getClient();
  await client.request({
    method: 'POST',
    url: `https://run.googleapis.com/v2/projects/${env.gcpProjectId}/locations/${env.gcpRegion}/jobs/${jobName}:run`,
  });

  logger.info({ mediaId }, 'Media worker job triggered');
}
