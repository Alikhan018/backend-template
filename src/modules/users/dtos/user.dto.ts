import type { IUser } from "../interfaces/user.interface.js";

export interface CreateUserDto {
    name: string;
    email: string;
    password: string;
}
export interface UpdateUserDto {
    name?: string;
    email?: string;
    password?: string;
}
export interface UserResponseDto {
    id: string;
    name: string;
    email: string;
    createdAt: Date;
    updatedAt: Date;
}
export function toUserResponseDto(user: IUser): UserResponseDto {
    return {
        id: user._id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
    };
}