import mongoose from "mongoose";
import env from '@/environment/env.js'
import logger from "@/configs/logger/winston.logger.js";

class Database {
    constructor() {
        this.connect();
    }
    private async connect() {
        try {
            await mongoose.connect(env.MONGO_URI);
            logger.info('Database connected');
        } catch (error) {
            logger.error('Database connection error: ' + (error as Error).message);
            console.error('Database connection error:', error);
            process.exit(1);
        }
    }
}

export default new Database();