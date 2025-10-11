// MongoDB initialization script
// This script runs when MongoDB container starts for the first time

// Create application database
const dbName = process.env.MONGO_INITDB_DATABASE || 'backend_template';

// Switch to the application database
db = db.getSiblingDB(dbName);

// Create a user for the application (optional - you can manage this through your app)
db.createUser({
  user: 'appuser',
  pwd: 'apppassword',
  roles: [
    {
      role: 'readWrite',
      db: dbName
    }
  ]
});

// Create initial collections (optional)
db.createCollection('users');
db.createCollection('sessions');

// Add indexes for better performance (optional)
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "createdAt": 1 });

print(`Database ${dbName} initialized successfully`);