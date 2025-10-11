import { BaseController } from "@/core/controller/base.controller.js";
import UserService from "@/modules/users/services/user.service.js";
import { toUserResponseDto } from "../dtos/user.dto.js";
import type { IUser } from "../interfaces/user.interface.js";

class UserController extends BaseController {
    getAllUsers = this.handleAsync(async (req, res) => {
        const fetchedUsers = await UserService.findAll();
        const users = fetchedUsers.map(user => toUserResponseDto(user));
        this.sendResponse(res, users, "Users fetched successfully");
    });
    createUser = this.handleAsync(async (req, res) => {
        const newUser: IUser = await UserService.create(req.body);
        const user = toUserResponseDto(newUser);
        this.sendResponse(res, user, "User created successfully", 201);
    });
    getUserById = this.handleAsync(async (req, res) => {
        const userId: string | undefined = req.params.id;
        if (!userId) return this.handleError(new Error("User ID is required"), res);
        const fetchedUser: IUser | null = await UserService.findById(userId);
        if (!fetchedUser) return this.handleError(new Error("User not found"), res);
        const user = toUserResponseDto(fetchedUser);
        this.sendResponse(res, user, "User fetched successfully");
    })
    updateUser = this.handleAsync(async (req, res) => {
        const userId: string | undefined = req.params.id;
        if (!userId) return this.handleError(new Error("User ID is required"), res);
        const fetchedUpdatedUser: IUser | null = await UserService.update(userId, req.body);
        if (!fetchedUpdatedUser) return this.handleError(new Error("User not found or not updated"), res);
        const updatedUser = toUserResponseDto(fetchedUpdatedUser);
        this.sendResponse(res, updatedUser, "User updated successfully");
    })
    deleteUser = this.handleAsync(async (req, res) => {
        const userId: string | undefined = req.params.id;
        if (!userId) return this.handleError(new Error("User ID is required"), res);
        await UserService.delete(userId);
        this.sendResponse(res, null, "User deleted successfully");
    });
}

export default new UserController();