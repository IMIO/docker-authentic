#!/usr/bin/env bash
set -x

wget -O agents.json "http://infra-api.imio.be/sso/agents/$ENVIRONMENT" && chmod 777 agents.json
wget -O usagers.json "http://infra-api.imio.be/sso/usagers/$ENVIRONMENT" && chmod 777 usagers.json

authentic2-multitenant-manage tenant_command wc-base-import -d "$AGENTS_HOSTNAME" agents.json --no-dry-run NO_DRY_RUN
authentic2-multitenant-manage tenant_command wc-base-import -d "$USAGERS_HOSTNAME" usagers.json --no-dry-run NO_DRY_RUN

