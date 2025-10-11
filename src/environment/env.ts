import dotenv from "dotenv";
dotenv.config();

const env = {
    PORT: process.env.PORT as unknown as number || 3000,
    MONGO_URI: process.env.MONGO_URI as string,
    JWT_KEY: process.env.JWT_SECRET as string,
}

export default env;