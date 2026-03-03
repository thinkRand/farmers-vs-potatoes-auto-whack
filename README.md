# Farmers vs Potatoes Whack-a-Mole AutoHotkey Script

An AutoHotkey script that automates the whack-a-mole minigame with human-like behavior and reliability features.

## 📋 Features

- **Automated Gameplay**: Automatically detects and clicks on moles
- **Human-like Behavior**: Randomized click positions and timing to avoid detection
- **Self-Maintaining**: Automatically restarts the minigame at configurable intervals
- **Visual Debug Overlay**: Toggleable rectangle overlay showing detection zones
- **Multi-Resolution Support**: Works with common aspect ratios (16:9)
- **Configurable Settings**: Easy configuration via INI file

## 🎮 Supported Resolutions

The script is optimized for these resolutions (maintaining 16:9 aspect ratio):
- 960×540
- 1280×720
- 1600×900
- 1920×1080

Other resolutions with the same aspect ratio may work but are not guaranteed.

## ⌨️ Hotkeys

| Hotkey | Function |
|--------|----------|
| `Ctrl + F11` | Toggle script On/Off |
| `Ctrl + F12` | Show/Hide detection overlay |
| `Ctrl + F10` | Reload script |

## 📁 Installation

1. **Install AutoHotkey** (if not already installed)
   - Download from [autohotkey.com](https://www.autohotkey.com/)
   - Install with default settings

2. **Download the script**
   - Save the script as `whack-a-mole.ahk`

3. **Launch the game**
   - Start your game first (the script will check for it)
   - Run the script by double-clicking the `.ahk` file

## ⚙️ Configuration

The script automatically creates a `settings.ini` file with the following structure:

```ini
[global]
secondsToRestart=390
```

### Configuration Options

- `secondsToRestart`: Time in seconds before automatically restarting the minigame (default: 390)

## 🎯 How It Works

1. **Detection Zones**: The script calculates 15 detection zones based on your game window size
2. **Color Detection**: Uses pixel color detection to identify moles (normal: 0x4A96D1, yellowish: 0x13BDFB)
3. **Human-like Movement**: Random click positions within each hole and randomized delays
4. **Self-Restart**: Monitors runtime and restarts the minigame at configured intervals
5. **Reliability Feature**: Programmed to occasionally miss (1-3 times per run) to appear more human

## 🎨 Visual Overlay

Press `Ctrl + F12` to toggle the visual overlay, which shows:
- **Green rectangles**: Detection zones for each hole
- **Outer rectangles**: Full hole boundaries
- **Inner rectangles**: Precise detection areas

This is useful for debugging and verifying that the script correctly identifies game elements.

## 📝 Usage Instructions

1. **Start the game** and navigate to the whack-a-mole minigame
2. **Run the script** (double-click the `.ahk` file)
3. **Read the instructions** dialog and click OK
4. **Press `Ctrl + F11`** to activate the script
5. **Watch it work!** The script will automatically detect and click moles
6. **Use overlay** if needed to verify detection zones

## 🤝 Contributing

Feel free to modify the script for your needs. Key areas for customization:
- Color values for mole detection
- Timing parameters for clicks
- Randomization ranges
- Detection zone sizes
