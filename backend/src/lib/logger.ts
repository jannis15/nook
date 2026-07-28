import pino from 'pino';
import { env } from '../env.js';

export const logger = pino({
  base: null,
  level: env.logLevel,
  timestamp: pino.stdTimeFunctions.isoTime,
});
