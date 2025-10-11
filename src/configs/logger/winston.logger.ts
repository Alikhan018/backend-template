import winston from 'winston';
import path from 'path';

class Logger {
    public logger: winston.Logger;
    constructor() {
        this.logger = winston.createLogger({
            level: 'info',
            format: winston.format.json(),
            transports: [
                new winston.transports.Console(),
                new winston.transports.File({
                    filename: path.join(process.cwd(), 'logs', 'error.log'),
                    level: 'error'
                }),
                new winston.transports.File({
                    filename: path.join(process.cwd(), 'logs', 'combined.log')
                })
            ]
        })
    }
    info(message: string) {
        this.logger.info(message);
    }
    error(message: string) {
        this.logger.error(message);
    }
}
const logger = new Logger();
export default logger;