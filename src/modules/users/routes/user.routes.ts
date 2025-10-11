import { Router } from "express";
import UserController from "@/modules/users/controllers/user.controller.js";
import { validate } from "@/middlewares/validate.middleware.js";
import { UserValidator } from "../validators/user.validator.js";
import { authenticate } from "@/middlewares/auth.middleware.js";

class UserRoutes {
    public router: Router;

    constructor() {
        this.router = Router();
        this.initializeRoutes();
    }

    private initializeRoutes(): void {
        this.router.get("/", authenticate, UserController.getAllUsers);
        this.router.post("/", validate(UserValidator.create), UserController.createUser);
        this.router.get("/:id", authenticate, UserController.getUserById);
        this.router.put("/:id", validate(UserValidator.update), authenticate, UserController.updateUser);
        this.router.delete("/:id", authenticate, UserController.deleteUser);
    }
}

export default UserRoutes;