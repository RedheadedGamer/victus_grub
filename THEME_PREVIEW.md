# HP Victus GRUB Theme Preview

## Theme Features Overview

### Visual Design
- **Background**: Misty forest scene with natural, calming aesthetics
- **Layout**: Menu positioned at 58% vertical height for optimal visual balance
- **Typography**: Professional Roboto font family (Regular 22px for menu, Bold 24px for titles)
- **Color Scheme**: Dark theme with HP Victus signature orange (#FF4500) highlights

### Menu Appearance
```
┌─────────────────────────────────────────────────────────┐
│                    Misty Forest Background              │
│                                                         │
│                                                         │
│                    [Title Area]                         │
│                                                         │
│           ┌─────────────────────────────────┐           │
│           │  ○ Ubuntu                       │           │ 58% height
│           │  ▶ Ubuntu (Advanced Options)    │           │
│           │  ⊞ Windows Boot Manager         │           │
│           │  ⚠ System Recovery              │           │
│           └─────────────────────────────────┘           │
│                                                         │
│           ████████████████                              │ Progress bar
│           Use ↑ and ↓ to change selection              │
└─────────────────────────────────────────────────────────┘
```

### Color Specifications

| Element | Color Code | Description |
|---------|------------|-------------|
| Normal Text | `#CCCCCC` | Light gray for regular menu items |
| Selected Text | `#FFFFFF` | Pure white for highlighted selection |
| Highlight Background | `#FF4500` | HP Victus signature orange |
| Title Text | `#FFFFFF` | White for title/header text |
| Progress Bar | `#FF4500` | Orange progress indicator |
| Background | `#000000` | Black fallback background |

### Icon System

The theme includes minimal monochrome icons for OS recognition:

- **Linux/Unix**: Terminal-style rectangular icon
- **Windows**: Four-pane window icon
- **Recovery**: Circle with cross symbol

### Typography Details

- **Font Family**: Roboto (professional, highly readable)
- **Menu Items**: Roboto Regular, 22px
- **Titles**: Roboto Bold, 24px
- **Spacing**: 4px between menu items
- **Icon Space**: 24px reserved for OS icons

### Layout Specifications

- **Menu Position**: 25% from left, 58% from top
- **Menu Dimensions**: 50% width, 25% height
- **Progress Bar**: 25% from left, 88% from top
- **Item Height**: 32px with 8px padding

### Technical Details

- **Background Resolution**: 1920x1080 (optimized for modern displays)
- **Font Format**: GRUB2 PF2 (converted from TTF)
- **Image Format**: PNG with transparency support
- **Theme Configuration**: Standard GRUB2 theme.txt format

### Accessibility Features

- **High Contrast**: Light text on dark background for readability
- **Clear Typography**: Professional font choice for clarity
- **Visual Hierarchy**: Distinct colors for different interface elements
- **Icon Support**: Visual cues for different OS types

### Installation Requirements

- GRUB 2.x bootloader
- Linux system with root access
- ~2MB available space in /boot partition
- Support for theme extensions in GRUB configuration

### Compatibility

This theme is designed to work with:
- Modern UEFI systems
- Legacy BIOS systems with GRUB2
- Various screen resolutions (optimized for 1920x1080)
- Multiple OS configurations (Linux, Windows, recovery options)

The theme provides a professional, branded experience that reflects HP Victus gaming aesthetics while maintaining excellent usability and accessibility standards.