import mongoose, { Schema } from "mongoose";

export const UserSchema = new Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
}, {
    timestamps: true
});

const User = mongoose.model("User", UserSchema);
export default User;