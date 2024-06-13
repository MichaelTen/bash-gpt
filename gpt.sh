#!/bin/bash

# Your OpenAI API key
API_KEY="API_KEY"

# Join all arguments into a single string
PROMPT="$*"

# Function to wrap text at a specified width
wrap_text() {
    local text="$1"
    local width=80
    echo "$text" | fold -s -w "$width"
}

# Make the request and capture the response
RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d '{
      "model": "gpt-3.5-turbo",
      "messages": [{"role": "user", "content": "'"$PROMPT"'"}],
      "temperature": 0.7
    }')

# Check if the request was successful
if echo "$RESPONSE" | jq -e '.error' > /dev/null; then
    echo "Error: $(echo $RESPONSE | jq -r '.error.message')"
    exit 1
fi

# Extract and prepare the response text
RESPONSE_TEXT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
FORMATTED_RESPONSE=$(wrap_text "\n$RESPONSE_TEXT\n")

# Extract token usage
PROMPT_TOKENS=$(echo "$RESPONSE" | jq -r '.usage.prompt_tokens')
COMPLETION_TOKENS=$(echo "$RESPONSE" | jq -r '.usage.completion_tokens')
TOTAL_TOKENS=$(echo "$RESPONSE" | jq -r '.usage.total_tokens')

# Prepare token usage information with extra line breaks
TOKEN_USAGE=$(wrap_text "\n[prompt tokens: $PROMPT_TOKENS | completion tokens: $COMPLETION_TOKENS | total tokens: $TOTAL_TOKENS]\n")

# Combine the response and token usage for display
DISPLAY_OUTPUT="$FORMATTED_RESPONSE$TOKEN_USAGE"

# Output the formatted response and token usage
echo -e "$DISPLAY_OUTPUT"

# Log the question and response to a markdown file
LOG_FILE="$HOME/gpt_log.md"
{
    echo "## $(date)"
    echo
    echo "**Question:** $PROMPT"
    echo
    echo "**Response:**"
    wrap_text "$RESPONSE_TEXT"
    echo
    echo "**Token Usage:**"
    wrap_text "[prompt tokens: $PROMPT_TOKENS | completion tokens: $COMPLETION_TOKENS | total tokens: $TOTAL_TOKENS]"
    echo
    echo "---"
} >> "$LOG_FILE"
