# ---------- Base Stage ----------
FROM node:20-alpine AS base

# Create app user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production && \
    npm cache clean --force

# ---------- Development Stage ----------
FROM base AS development

# Install all dependencies including dev dependencies
RUN npm ci

# Copy source code
COPY --chown=nodejs:nodejs . .

# Switch to nodejs user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node --version || exit 1

# Development command
CMD ["npm", "run", "dev"]

# ---------- Build Stage ----------
FROM base AS build

# Install all dependencies for building
RUN npm ci

# Copy source code
COPY --chown=nodejs:nodejs . .

# Build the application
RUN npm run build

# ---------- Production Stage ----------
FROM node:20-alpine AS production

# Create app user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Copy built application from build stage
COPY --from=build --chown=nodejs:nodejs /app/dist ./dist

# Switch to nodejs user
USER nodejs

# Set environment
ENV NODE_ENV=production

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Production command
CMD ["node", "dist/server/index.js"]
