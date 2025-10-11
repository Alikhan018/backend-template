import { BaseController } from "@/core/controller/base.controller.js";
import bcrypt from "bcrypt";
import express from "express";
import UserService from "@/modules/users/services/user.service.js";
import jwt from "jsonwebtoken";
import type { IUser } from "@/modules/users/interfaces/user.interface.js";
import env from "@/environment/env.js";
import type { LoginDto, RegisterDto, AuthResponseDto } from "@/modules/auth/dtos/auth.dto.js";

class AuthController extends BaseController {
    login = this.handleAsync(async (req: express.Request<{}, {}, LoginDto>, res: express.Response) => {
        const { email, password } = req.body;

        const user: IUser | null = await UserService.findByEmail(email);
        if (!user) return this.handleError(new Error("Invalid email or password"), res);

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) return this.handleError(new Error("Invalid email or password"), res);

        const token = jwt.sign(
            { id: user._id, email: user.email },
            env.JWT_KEY || "secret",
            { expiresIn: "1h" }
        );

        const response: AuthResponseDto = { token, expiresIn: 3600 };
        this.sendResponse(res, response, "Login successful");
    });

    register = this.handleAsync(async (req: express.Request<{}, {}, RegisterDto>, res: express.Response) => {
        const { name, email, password } = req.body;

        const existingUser: IUser | null = await UserService.findByEmail(email);
        if (existingUser) return this.handleError(new Error("User already exists"), res);

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await UserService.create({ name, email, password: hashedPassword });

        this.sendResponse(
            res,
            { id: newUser._id, name: newUser.name, email: newUser.email },
            "Registration successful",
            201
        );
    });
}

export default new AuthController();
