import type { Request, Response, NextFunction } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";
import env from "@/environment/env.js";

export interface AuthRequest extends Request {
    user?: JwtPayload | string;
}

export const authenticate = (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({ success: false, message: "Unauthorized: No token provided" });
        }

        const token = authHeader.split(" ")[1];
        if (!token) {
            return res.status(401).json({ success: false, message: "Unauthorized: No token provided" });
        }
        const decoded = jwt.verify(token, env.JWT_KEY || "secret");

        req.user = decoded; // attach user info to request
        next();
    } catch (err: any) {
        return res.status(401).json({ success: false, message: "Unauthorized: Invalid token" });
    }
};