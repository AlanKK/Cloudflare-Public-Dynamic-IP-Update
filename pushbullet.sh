#!/bin/bash

CONFIG_FILE=~/.config/pushbullet

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE does not exist."
    exit 1
fi

API_KEY=$(grep '^API_KEY=' "$CONFIG_FILE" | cut -d '=' -f 2)

if [ -z "$API_KEY" ]; then
    echo "Error: API_KEY not found in $CONFIG_FILE."
    exit 1
fi

send_pushbullet_note() {
  local title="$1"
  local body="$2"

  curl --header "Access-Token: $API_KEY" \
       --header "Content-Type: application/json" \
       --data-binary "{\"type\": \"note\", \"title\": \"$title\", \"body\": \"$body\"}" \
       --request POST \
       https://api.pushbullet.com/v2/pushes
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <title> <body>"
  exit 1
fi

# Call the function with command-line arguments
send_pushbullet_note "$1" "$2"

