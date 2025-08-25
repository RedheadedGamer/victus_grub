#!/bin/bash

# HP Victus GRUB Theme Validation Script
# Checks theme files and configuration for common issues

THEME_DIR="themes/victus"
ERROR_COUNT=0

echo "================================================"
echo "HP Victus GRUB Theme Validation"
echo "================================================"

validate_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo "✓ $description: $file"
    else
        echo "✗ Missing $description: $file"
        ((ERROR_COUNT++))
    fi
}

validate_directory() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo "✓ $description directory: $dir"
    else
        echo "✗ Missing $description directory: $dir"
        ((ERROR_COUNT++))
    fi
}

echo "Checking theme structure..."

# Check main theme files
validate_file "$THEME_DIR/theme.txt" "Theme configuration"
validate_file "$THEME_DIR/background.png" "Background image"

# Check directories
validate_directory "$THEME_DIR/fonts" "Fonts"
validate_directory "$THEME_DIR/icons" "Icons"

# Check font files
validate_file "$THEME_DIR/fonts/Roboto-Regular-22.pf2" "Menu font"
validate_file "$THEME_DIR/fonts/Roboto-Bold-24.pf2" "Title font"

# Check icon files
validate_file "$THEME_DIR/icons/linux.png" "Linux icon"
validate_file "$THEME_DIR/icons/windows.png" "Windows icon"
validate_file "$THEME_DIR/icons/recovery.png" "Recovery icon"

# Check highlight files
validate_file "$THEME_DIR/highlight_c.png" "Highlight center"
validate_file "$THEME_DIR/highlight_w.png" "Highlight west"
validate_file "$THEME_DIR/highlight_e.png" "Highlight east"

# Check theme configuration syntax
echo ""
echo "Validating theme configuration..."

if [ -f "$THEME_DIR/theme.txt" ]; then
    # Check for required sections
    if grep -q "desktop-image:" "$THEME_DIR/theme.txt"; then
        echo "✓ Desktop image configured"
    else
        echo "✗ Desktop image not configured"
        ((ERROR_COUNT++))
    fi
    
    if grep -q "+ boot_menu" "$THEME_DIR/theme.txt"; then
        echo "✓ Boot menu section found"
    else
        echo "✗ Boot menu section missing"
        ((ERROR_COUNT++))
    fi
    
    if grep -q "item_font" "$THEME_DIR/theme.txt"; then
        echo "✓ Menu font configured"
    else
        echo "✗ Menu font not configured"
        ((ERROR_COUNT++))
    fi
    
    # Check for HP Victus orange color
    if grep -q "#FF4500" "$THEME_DIR/theme.txt"; then
        echo "✓ Victus orange color (#FF4500) configured"
    else
        echo "⚠ Victus orange color not found (theme will work but may not match branding)"
    fi
fi

# Check file sizes
echo ""
echo "File size check..."

if [ -f "$THEME_DIR/background.png" ]; then
    size=$(stat -c%s "$THEME_DIR/background.png")
    if [ $size -gt 5000000 ]; then
        echo "⚠ Background image is large ($(($size/1024/1024))MB) - consider optimizing"
    else
        echo "✓ Background image size acceptable ($(($size/1024))KB)"
    fi
fi

# Check image properties if identify is available
if command -v identify &> /dev/null; then
    echo ""
    echo "Image properties check..."
    
    if [ -f "$THEME_DIR/background.png" ]; then
        dimensions=$(identify -format "%wx%h" "$THEME_DIR/background.png" 2>/dev/null)
        echo "✓ Background dimensions: $dimensions"
    fi
    
    for icon in "$THEME_DIR/icons"/*.png; do
        if [ -f "$icon" ]; then
            dimensions=$(identify -format "%wx%h" "$icon" 2>/dev/null)
            name=$(basename "$icon")
            echo "✓ Icon $name: $dimensions"
        fi
    done
fi

# Summary
echo ""
echo "================================================"
if [ $ERROR_COUNT -eq 0 ]; then
    echo "✓ Theme validation PASSED - No critical issues found"
    echo "The theme is ready for installation!"
else
    echo "✗ Theme validation FAILED - $ERROR_COUNT critical issues found"
    echo "Please fix the issues above before installing the theme."
fi
echo "================================================"

exit $ERROR_COUNT