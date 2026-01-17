# Stage 1: Build
FROM debian:stable-slim AS builder

# Install build dependencies (wget, unzip, zip)
RUN apt-get update && apt-get install -y wget unzip zip && apt-get clean

# Download and prepare uasm
RUN wget https://github.com/Terraspace/UASM/releases/download/v2.57r/uasm257_linux64.zip -O /tmp/uasm.zip && \
  unzip -j /tmp/uasm.zip uasm -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/uasm && \
  rm /tmp/uasm.zip

# Copy the source code
COPY . /app
WORKDIR /app

# Compile the game
RUN uasm -mz src/main.asm && \
  mv main.EXE mquest.exe

# Create a simple zip archive for the game
RUN zip mquest.jsdos mquest.exe .jsdos/dosbox.conf .jsdos/.json

# Stage 2: Production
FROM caddy:2-alpine

WORKDIR /app

COPY Caddyfile /etc/caddy/Caddyfile

# Copy only the necessary assets from the build stage
COPY --from=builder /app/mquest.jsdos /srv/mquest.jsdos
COPY --from=builder /app/index.html /srv/index.html

# Create a non-root user and group
RUN addgroup -S caddy && adduser -S caddy -G caddy

# Change ownership of the static files and Caddy's data/config directories
RUN chown -R caddy:caddy /srv /data /config

# Switch to the non-root user
USER caddy
EXPOSE 8080
