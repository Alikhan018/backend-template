import express from 'express';
import env from '../environment/env.js';
import '@/configs/database/database.js';
import Routes from '@/core/routes/core.routes.js';
import logger from '@/configs/logger/winston.logger.js';

class Server {
    public app: express.Application;
    public routes: Routes;
    constructor() {
        this.app = express();
        this.config();
        this.routes = new Routes(this.app);
        this.routes.configure();
        this.start(env.PORT);
    }
    private config(): void {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));

    }
    public start(port: number): void {
        this.app.listen(port, () => {
            logger.info(`Server is running on port ${port}`);
        });
    }
}

export default Server;