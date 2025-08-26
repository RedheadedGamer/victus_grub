#!/bin/bash

# Random Quote Generator for HP Victus GRUB Theme
# This script updates the theme with a randomly selected inspirational quote

# Use provided theme file path or default to relative path
THEME_FILE="${1:-themes/victus/theme.txt}"

# Check if theme file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file not found at $THEME_FILE"
    echo "Usage: $0 [theme_file_path]"
    exit 1
fi

# Array of inspirational quotes
quotes=(
    "Excellence is not a skill,|it's an attitude.|— Ralph Marston"
    "The future belongs to those|who believe in the beauty|of their dreams.|— Eleanor Roosevelt"
    "Success is not final,|failure is not fatal:|it is the courage to continue|that counts.|— Winston Churchill"
    "Innovation distinguishes|between a leader|and a follower.|— Steve Jobs"
    "The only way to do|great work is to love|what you do.|— Steve Jobs"
    "Believe you can|and you're halfway there.|— Theodore Roosevelt"
    "Your limitation—it's only|your imagination."
    "Push yourself, because|no one else is going|to do it for you."
    "Sometimes later|becomes never.|Do it now."
    "Great things never come|from comfort zones."
    "Dream it. Wish it. Do it."
    "Success doesn't just|find you. You have to|go out and get it."
    "The harder you work|for something, the greater|you'll feel when|you achieve it."
    "Dream bigger.|Do bigger."
    "Don't stop when|you're tired.|Stop when you're done."
)

# Get random quote
quote_count=${#quotes[@]}
random_index=$((RANDOM % quote_count))
selected_quote="${quotes[$random_index]}"

# Convert | to newlines for proper formatting
formatted_quote=$(echo "$selected_quote" | tr '|' '\n')

# Create temporary file with the updated theme
temp_file=$(mktemp)

# Update the existing label block with the quote
awk -v quote="$formatted_quote" '
/^\+ label \{/ {
    in_label = 1
    print
    next
}
in_label && /^    text = / {
    print "    text = \"" quote "\""
    next
}
in_label && /^\}/ {
    in_label = 0
    print
    next
}
{ print }
' "$THEME_FILE" > "$temp_file"

# Check if the replacement was successful
if [ -s "$temp_file" ]; then
    # Replace the original file
    mv "$temp_file" "$THEME_FILE"
    echo "Updated GRUB theme with quote #$((random_index + 1))"
    echo "Quote: $formatted_quote"
else
    rm -f "$temp_file"
    echo "Error: Failed to update theme file"
    exit 1
fi