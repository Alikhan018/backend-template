import logger from "@/configs/logger/winston.logger.js";
import AppError from "@/core/error/app.error.js";

export abstract class BaseService<T> {
    protected readonly model: any;

    constructor(model: any) {
        this.model = model;
    }

    protected log(message: string): void {
        logger.info(`[${this.constructor.name}] ${message}`);
    }

    protected throwError(message: string, statusCode = 400): never {
        throw new AppError(message, statusCode);
    }

    async findAll(): Promise<T[]> {
        this.log("Fetching all records");
        return this.model.find();
    }

    async findById(id: string): Promise<T | null> {
        this.log(`Fetching record with id=${id}`);
        return this.model.findById(id);
    }

    async create(data: Partial<T>): Promise<T> {
        this.log("Creating new record");
        return this.model.create(data);
    }

    async update(id: string, data: Partial<T>): Promise<T | null> {
        this.log(`Updating record with id=${id}`);
        return this.model.findByIdAndUpdate(id, data, { new: true });
    }

    async delete(id: string): Promise<void> {
        this.log(`Deleting record with id=${id}`);
        await this.model.findByIdAndDelete(id);
    }
}
