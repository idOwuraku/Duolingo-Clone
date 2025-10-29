# syntax=docker/dockerfile:1.6
ARG APP_VERSION="1.0.0-local"
ARG BUILD_DATE="unknown"

FROM node:22-slim AS base
WORKDIR /app

ARG APP_VERSION
ARG BUILD_DATE

LABEL org.opencontainers.image.title="duolingo-clone" \
      org.opencontainers.image.description="A clone of duolingo website" \
      org.opencontainers.image.authors="Owuraku Oduro" \
      org.opencontainers.image.source="https://github.com/idOwuraku/Duolingo-Clone.git" \
      org.opencontainers.image.licenses="Proprietary" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}"

ENV NEXT_TELEMETRY_DISABLED=1

# --------------------
# Dependencies
# --------------------
FROM base AS dependencies

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

RUN --mount=type=cache,target=/root/.npm \
    --mount=type=cache,target=/root/.yarn \
    --mount=type=cache,target=/root/.pnpm-store \
    if [ -f yarn.lock ]; then yarn install --frozen-lockfile --non-interactive; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm install --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# --------------------
# Builder
# --------------------
FROM base AS builder
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Build-time secrets
ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
ARG CLERK_SECRET_KEY
ARG DATABASE_URL
ARG NEXT_DISABLE_FONT_OPTIMIZATION=1

ENV NODE_ENV=production \
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=${NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY} \
    CLERK_SECRET_KEY=${CLERK_SECRET_KEY} \
    DATABASE_URL=${DATABASE_URL} \
    NEXT_DISABLE_FONT_OPTIMIZATION=${NEXT_DISABLE_FONT_OPTIMIZATION}

RUN echo "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY" && \
    echo "CLERK_SECRET_KEY=$CLERK_SECRET_KEY" && \
    echo "DATABASE_URL=$DATABASE_URL"

RUN --mount=type=cache,target=/root/.next-cache \
    if [ -f yarn.lock ]; then yarn run build; \
    elif [ -f package-lock.json ]; then npm run build; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
    else echo "Lockfile not found." && exit 1; \
    fi

# --------------------
# Runner
# --------------------
FROM gcr.io/distroless/nodejs22:nonroot AS runner
WORKDIR /app

ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3003 \
    HOSTNAME="0.0.0.0"

COPY --from=builder --chown=65532:65532 /app/public ./public
COPY --from=builder --chown=65532:65532 /app/.next/standalone ./
COPY --from=builder --chown=65532:65532 /app/.next/static ./.next/static
COPY --from=builder --chown=65532:65532 /app/healthcheck.js ./

USER 65532:65532
EXPOSE 3003

CMD ["node", "server.js"]

HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=3 \
    CMD ["node", "healthcheck.js"]
