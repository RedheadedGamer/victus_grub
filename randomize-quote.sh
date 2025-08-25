#!/bin/bash

# Random Quote Generator for HP Victus GRUB Theme
# This script updates the theme with a randomly selected inspirational quote

THEME_FILE="themes/victus/theme.txt"

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
awk -v quote="$formatted_quote" '
/^# Inspirational quote on the right side/ {
    print
    getline
    print
    getline
    print
    getline
    print
    getline
    print
    getline
    print "    text = \"" quote "\""
    # Skip the old text line
    while (getline && $0 !~ /^ *font = /) {
        # Skip until we find the font line
    }
    print
    next
}
{ print }
' "$THEME_FILE" > "$temp_file"

# Replace the original file
mv "$temp_file" "$THEME_FILE"

echo "Updated GRUB theme with quote #$((random_index + 1))"
echo "Quote: $formatted_quote"