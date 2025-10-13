#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate Customer
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Generates customer user for testing
# Get the current date and time

current_date_time=$(date +"%Y%m%d-%H%M")

# Generate the email
email="tcrawford+c-${current_date_time}@figuretech.co"

# Copy the email to the clipboard
echo -n "$email" | pbcopy

# Output the email (optional, for Raycast to show the result)
echo "Generated email: $email"
