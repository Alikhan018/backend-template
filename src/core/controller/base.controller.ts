import type { Request, Response, NextFunction } from "express";
import logger from "@/configs/logger/winston.logger.js";
import AppError from "@/core/error/app.error.js";

export abstract class BaseController {
    protected log(message: string): void {
        logger.info(`[${this.constructor.name}] ${message}`);
    }

    protected handleError(err: unknown, res: Response): void {
        const error = err as AppError;
        const status = error.statusCode || 500;
        const message = error.message || "Internal Server Error";
        const stack = process.env.NODE_ENV === "development" ? error.stack : undefined;

        logger.error(`[${this.constructor.name}] ${message} (${status})`);

        res.status(status).json({
            success: false,
            message,
            stack,
        });
    }

    protected sendResponse(
        res: Response,
        data: any,
        message = "Success",
        status = 200
    ): void {
        res.status(status).json({
            success: true,
            message,
            data,
        });
    }
    protected handleAsync(fn: (req: Request, res: Response, next?: NextFunction) => Promise<any>) {
        return async (req: Request, res: Response, next: NextFunction) => {
            try {
                await fn.call(this, req, res, next);
            } catch (err) {
                this.handleError(err, res);
            }
        };
    }
}
