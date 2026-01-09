import fs from 'fs';
import path from 'path';

const logDir = path.join(__dirname, '../../logs');
const logFilePath = path.join(logDir, 'app.log');

if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

const formatLog = (level: string, message: string, meta?: any) => {
  const time = new Date().toISOString();
  const metaString = meta ? ` | ${JSON.stringify(meta)}` : '';
  return `[${time}] [${level.toUpperCase()}] ${message}${metaString}\n`;
};

export class Logger {
  static info(message: string, meta?: any) {
    console.log(formatLog('info', message, meta));
    fs.appendFileSync(logFilePath, formatLog('info', message, meta));
  }

  static warn(message: string, meta?: any) {
    console.warn(formatLog('warn', message, meta));
    fs.appendFileSync(logFilePath, formatLog('warn', message, meta));
  }

  static error(message: string, meta?: any) {
    console.error(formatLog('error', message, meta));
    fs.appendFileSync(logFilePath, formatLog('error', message, meta));
  }
}
