#!/bin/sh
set -e

# Copy example env if .env doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Generate app key if not provided
if ! grep -q '^APP_KEY=' .env || [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Run Akaunting installer if requested
if [ "$AKAUNTING_SETUP" = "true" ]; then
    php artisan install \
        --db-host="$DB_HOST" \
        --db-port="$DB_PORT" \
        --db-name="$DB_NAME" \
        --db-username="$DB_USERNAME" \
        --db-password="$DB_PASSWORD" \
        --db-prefix="$DB_PREFIX" \
        --admin-email="$ADMIN_EMAIL" \
        --admin-password="$ADMIN_PASSWORD" \
        --company-name="$COMPANY_NAME" \
        --company-email="$COMPANY_EMAIL" \
        --locale="$LOCALE" \
        --yes
fi

exec "$@"
