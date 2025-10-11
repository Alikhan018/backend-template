import { Router } from "express";
import AuthController from "../controllers/auth.controller.js";
import { validate } from "@/middlewares/validate.middleware.js";
import { AuthValidator } from "../validators/auth.validator.js";

class AuthRoutes {
    public router: Router;

    constructor() {
        this.router = Router();
        this.initializeRoutes();
    }

    private initializeRoutes(): void {
        this.router.post("/login", validate(AuthValidator.login), AuthController.login);
        this.router.post("/signup", validate(AuthValidator.signup), AuthController.register);
    }
}

export default AuthRoutes;