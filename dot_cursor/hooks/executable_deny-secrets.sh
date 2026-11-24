#!/bin/sh
# Cursor preToolUse hook: deny agent access to dotenv files and environment dumps.
# File tools are judged by the paths they touch and shell calls by their command, so
# a file that merely mentions dotenv files (an env.ts, say) can still be read and edited.
# Anything else, or input that isn't parseable JSON, is judged by its whole raw input.
# Patterns are assembled from pieces so this file doesn't trip its own check.
input=$(cat)

dot='\.'
pe='print''env'
env_file="(^|[^A-Za-z0-9_.-])${dot}env(${dot}(local|development|production|staging|test)|${dot}[A-Za-z0-9_-]+${dot}local)?([^A-Za-z0-9_.-]|\$)"
env_dump="(^|[^A-Za-z0-9_-])${pe}([^A-Za-z0-9_-]|\$)|(^|[;&|]|--)[[:space:]]*env[[:space:]]*(\$|[;&|])|\"command\" *: *\"env\"|(^|[^A-Za-z0-9_-])op +(environment +)?read([^A-Za-z0-9_-]|\$)"
# Commands that print secret values or a resolved environment. Agents use `hts env run -- <cmd>`.
b='([^A-Za-z0-9_-]|$)'
secret_cmd="(^|[^A-Za-z0-9_.-])(fnox[^;&|]*[[:space:]](get|export|env|edit|tui|-V|--values)$b|op[[:space:]]+(read|inject|item[[:space:]]+get|environment[[:space:]]+(read|secret))$b|op[[:space:]]+run[^;&|]*--no-masking|mise[[:space:]]+env$b|security[[:space:]]+(find-generic-password|find-internet-password|dump-keychain)|export[[:space:]]+-p$b|docker([[:space:]]+-[^[:space:]]+)*[[:space:]]+(compose[[:space:]]+config|inspect)$b|docker-compose[[:space:]]+config)"

command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
paths=$(printf '%s' "$input" | jq -r '.tool_input // {} | [.path, .file_path, .target_notebook, .glob, .glob_pattern, .target_directory] | map(select(type == "string")) | .[]' 2>/dev/null)

if [ -n "$command" ]; then
  # `op run --env-file <f> -- cmd` resolves the file inside 1Password and masks secrets in
  # output, so its --env-file arguments are exempt. The rest of the command is still checked.
  subject=$command
  if ! printf '%s' "$command" | grep -Eq -- '--no-masking'; then
    # shellcheck disable=SC2016 # a literal regex, not an expansion
    tok='[^- ;&|$`()<>][^ ;&|$`()<>]*'
    subject=$(printf '%s' "$command" | sed -E ":a
s/(op +run( +--?[A-Za-z][A-Za-z-]*(=$tok)?)*) +--env-file(=| +)$tok/\1/
ta")
  fi
elif [ -n "$paths" ]; then
  subject=$paths
elif printf '%s' "$input" | jq -e '[.tool_name, .tool_input.toolName] | map(select(type == "string")) | any(test("(^|[^A-Za-z0-9_])(delegate_task|t3_thread_launch|t3_thread_send|schedule_task)$"))' >/dev/null 2>&1; then
  # T3 briefs and messages are prose for another agent; they may name dotenv files without touching one.
  printf '%s\n' '{}'
  exit 0
else
  subject=$input
fi

if [ -n "$command" ] && printf '%s' "$command" | grep -Eq "$secret_cmd"; then
  # shellcheck disable=SC2016 # backticks are Markdown in the message
  printf '%s\n' '{"permission":"deny","user_message":"Blocked: commands that print secrets are off-limits to agents.","agent_message":"Commands that print secret values are denied by policy. Run the command that needs secrets as `hts env run -- <cmd>`; if it reports a cold cache, ask the user to run `hts env unlock`."}'
elif printf '%s' "$subject" | grep -Eq "$env_file|$env_dump"; then
  printf '%s\n' '{"permission":"deny","user_message":"Blocked: dotenv files and environment dumps are off-limits to agents.","agent_message":"Access to dotenv files and environment dumps is denied by policy. Ask the user for any secret you need; do not try another route."}'
else
  printf '%s\n' '{}'
fi
