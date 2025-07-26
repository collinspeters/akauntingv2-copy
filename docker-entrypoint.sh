#!/bin/bash
set -e

# If .env doesn't exist, copy .env.example
[ ! -f .env ] && cp .env.example .env

# Generate an APP_KEY if missing
if ! grep -q '^APP_KEY=' .env; then
    php artisan key:generate --show | xargs -I{} sed -i "s|^APP_KEY=.*|APP_KEY={}|g" .env
fi

# Run installer only on first run
if [ "${AKAUNTING_SETUP}" = "true" ]; then
    php artisan install \
        --db-host="${DB_HOST}" \
        --db-port="${DB_PORT}" \
        --db-name="${DB_NAME}" \
        --db-username="${DB_USERNAME}" \
        --db-password="${DB_PASSWORD}" \
        --db-prefix="${DB_PREFIX}" \
        --company-name="${COMPANY_NAME}" \
        --company-email="${COMPANY_EMAIL}" \
        --admin-email="${ADMIN_EMAIL}" \
        --admin-password="${ADMIN_PASSWORD}" \
        --locale="${LOCALE}"
    # Remove setup flag so it doesn't run again
    sed -i 's/AKAUNTING_SETUP=true/AKAUNTING_SETUP=false/' .env
fi

exec "$@"
