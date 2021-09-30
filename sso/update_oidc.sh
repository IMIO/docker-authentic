#!/usr/bin/env bash
set -x

if [ "$ENVIRONMENT" == "staging" ]
then
    echo "staging"
    wget -O agents.json "https://api-staging.imio.be/imio/authentic/v1/services?tenant=agents"  && chmod 777 agents.json
    wget -O usagers.json "https://api-staging.imio.be/imio/authentic/v1/services?tenant=usagers"  && chmod 777 usagers.json
fi
if [ "$ENVIRONMENT" == "production" ]
then
    echo "production"
    wget -O agents.json "https://api.imio.be/imio/authentic/v1/services?tenant=agents"  && chmod 777 agents.json
    wget -O usagers.json "https://api.imio.be/imio/authentic/v1/services?tenant=usagers"  && chmod 777 usagers.json
fi

authentic2-multitenant-manage tenant_command wc-base-import -d "$AGENTS_HOSTNAME" agents.json --no-dry-run NO_DRY_RUN
authentic2-multitenant-manage tenant_command wc-base-import -d "$USAGERS_HOSTNAME" usagers.json --no-dry-run NO_DRY_RUN
