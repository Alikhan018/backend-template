// import type { Request, Response, NextFunction } from "express";

// export const authorizeRole = (roles: string[]) => {
//     return (req: Request, res: Response, next: NextFunction) => {
//         if (!req.user || !roles.includes((req.user as any).role)) {
//             return res.status(403).json({ success: false, message: "Forbidden: You do not have access to this resource" });
//         }
//         next();
//     }
// }