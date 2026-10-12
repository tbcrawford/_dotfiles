#!/bin/sh
# Cursor preToolUse hook: deny agent access to .env files and environment dumps.
# Matches the raw hook JSON, so it covers file tools and shell commands alike.
input=$(cat)

env_file='(^|[^A-Za-z0-9_.-])\.env(\.(local|development|production|staging|test)|\.[A-Za-z0-9_-]+\.local)?([^A-Za-z0-9_.-]|$)'
env_dump='(^|[^A-Za-z0-9_-])printenv([^A-Za-z0-9_-]|$)|"command" *: *"env"|(^|[^A-Za-z0-9_-])op +(environment +)?read([^A-Za-z0-9_-]|$)'

if printf '%s' "$input" | grep -Eq "$env_file|$env_dump"; then
  printf '%s\n' '{"permission":"deny","user_message":"Blocked: .env files and environment dumps are off-limits to agents.","agent_message":"Access to .env files and environment dumps is denied by policy. Ask the user for any secret you need; do not try another route."}'
else
  printf '%s\n' '{}'
fi
