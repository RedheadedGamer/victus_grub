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
validate_file "$THEME_DIR/icons/arch.png" "Arch Linux icon"
validate_file "$THEME_DIR/icons/endeavouros.png" "Endeavour OS icon"

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
    
    # Check for modern color scheme
    if grep -q "#2980B9" "$THEME_DIR/theme.txt"; then
        echo "✓ Modern blue color scheme (#2980B9) configured"
    elif grep -q "#FF4500" "$THEME_DIR/theme.txt"; then
        echo "⚠ Legacy orange color found - consider updating to modern colors"
    else
        echo "⚠ No recognizable color scheme found"
    fi
    
    # Check for new OS icon mappings
    if grep -q 'class = "arch"' "$THEME_DIR/theme.txt"; then
        echo "✓ Arch Linux icon mapping configured"
    else
        echo "⚠ Arch Linux icon mapping not found"
    fi
    
    if grep -q 'class = "endeavouros"' "$THEME_DIR/theme.txt"; then
        echo "✓ Endeavour OS icon mapping configured"
    else
        echo "⚠ Endeavour OS icon mapping not found"
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

# Advanced theme testing
echo ""
echo "Advanced theme functionality testing..."

# Test theme syntax parsing
if command -v grub-script-check &> /dev/null; then
    echo "Testing GRUB theme syntax..."
    if grub-script-check < "$THEME_DIR/theme.txt" 2>/dev/null; then
        echo "✓ Theme syntax is valid"
    else
        echo "✗ Theme syntax has errors"
        ((ERROR_COUNT++))
    fi
else
    echo "⚠ grub-script-check not available - cannot validate theme syntax"
fi

# Test PNG file integrity
echo "Testing PNG file integrity..."
for png_file in "$THEME_DIR"/*.png "$THEME_DIR/icons"/*.png; do
    if [ -f "$png_file" ]; then
        # Simple PNG header check
        if file "$png_file" | grep -q "PNG image data"; then
            echo "✓ $(basename "$png_file") is a valid PNG"
        else
            echo "✗ $(basename "$png_file") is not a valid PNG"
            ((ERROR_COUNT++))
        fi
    fi
done

# Test font files if grub-mkfont is available
if command -v grub-mkfont &> /dev/null; then
    echo "Testing font files..."
    for font_file in "$THEME_DIR/fonts"/*.pf2; do
        if [ -f "$font_file" ]; then
            # Check if it's a valid PF2 font
            if file "$font_file" | grep -q "data"; then
                echo "✓ $(basename "$font_file") appears to be a valid font"
            else
                echo "⚠ $(basename "$font_file") may not be a valid PF2 font"
            fi
        fi
    done
else
    echo "⚠ grub-mkfont not available - cannot validate font files"
fi

# Test theme completeness score
echo ""
echo "Theme completeness assessment..."
total_components=12
found_components=0

[ -f "$THEME_DIR/theme.txt" ] && ((found_components++))
[ -f "$THEME_DIR/background.png" ] && ((found_components++))
[ -f "$THEME_DIR/fonts/Roboto-Regular-22.pf2" ] && ((found_components++))
[ -f "$THEME_DIR/fonts/Roboto-Bold-24.pf2" ] && ((found_components++))
[ -f "$THEME_DIR/icons/linux.png" ] && ((found_components++))
[ -f "$THEME_DIR/icons/windows.png" ] && ((found_components++))
[ -f "$THEME_DIR/icons/recovery.png" ] && ((found_components++))
[ -f "$THEME_DIR/icons/arch.png" ] && ((found_components++))
[ -f "$THEME_DIR/icons/endeavouros.png" ] && ((found_components++))
[ -f "$THEME_DIR/highlight_c.png" ] && ((found_components++))
[ -f "$THEME_DIR/highlight_w.png" ] && ((found_components++))
[ -f "$THEME_DIR/highlight_e.png" ] && ((found_components++))

completeness=$((found_components * 100 / total_components))
echo "Theme completeness: $completeness% ($found_components/$total_components components)"

if [ $completeness -ge 90 ]; then
    echo "✓ Excellent theme completeness"
elif [ $completeness -ge 75 ]; then
    echo "✓ Good theme completeness"
elif [ $completeness -ge 50 ]; then
    echo "⚠ Moderate theme completeness - some features missing"
else
    echo "✗ Poor theme completeness - many features missing"
    ((ERROR_COUNT++))
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