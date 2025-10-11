import { BaseService } from "@/core/service/base.service.js";
import type { IUser } from "@/modules/users/interfaces/user.interface.js";
import User from "@/modules/users/model/user.model.js";

class UserService extends BaseService<IUser> {
    constructor() {
        super(User);
    }
    findByEmail(email: string): Promise<IUser | null> {
        this.log(`Fetching user with email=${email}`);
        return this.model.findOne({ email });
    }
}

export default new UserService();