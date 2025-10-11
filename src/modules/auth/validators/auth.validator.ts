import { z } from "zod";

export const AuthValidator = {
    signup: z.object({
        name: z.string().min(2, "Name must be at least 2 characters long"),
        email: z.string().email("Invalid email format"),
        password: z.string().min(6, "Password must be at least 6 characters long"),
    }),

    login: z.object({
        email: z.string().email("Invalid email format"),
        password: z.string().min(6, "Password must be at least 6 characters long"),
    })
};
