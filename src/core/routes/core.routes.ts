import express from "express";
import logger from "@/configs/logger/winston.logger.js";
import UserRoutes from "@/modules/users/routes/user.routes.js";
import AuthRoutes from "@/modules/auth/routes/auth.routes.js";


export default class Routes {
    private app: express.Application;

    constructor(app: express.Application) {
        this.app = app;
    }

    public configure(): void {
        logger.info("Registering API routes...");

        // Register all module routes here
        this.app.use("/api/users", new UserRoutes().router);
        this.app.use("/api/auth", new AuthRoutes().router);

        // Health check or root route
        this.app.get("/", (req, res) => {
            res.json({ success: true, message: "API is running" });
        });

        logger.info("All routes configured successfully ✅");
    }
}
