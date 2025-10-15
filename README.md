# Keybind Text Replacer

A lightweight World of Warcraft addon that replaces keybind text on action bars using a customizable lookup table.

## Features

- **Custom Keybind Labels**: Replace any keybind text with your preferred abbreviations
- **Exact Matching**: Only replaces exact matches from your lookup table
- **Efficient Performance**: Uses event-driven hooks instead of continuous polling
- **Simple Configuration**: Easy-to-edit lookup table in Lua

## Installation

1. Download or clone this repository
2. Copy the addon folder to your WoW AddOns directory:

   ```text
   World of Warcraft\_retail_\Interface\AddOns\
   ```

3. Restart WoW or type `/reload` in-game

## Configuration

Edit the `keybindReplacements` table in `KeybindTextReplacer.lua` (lines 8-28) to add your custom mappings:

```lua
local keybindReplacements = {
    ["s-,"] = "LA",           -- Replace "s-," with "LA"
    ["Mouse Wheel Down"] = "WD",  -- Replace "Mouse Wheel Down" with "WD"
    ["["] = "LD",             -- Replace "[" with "LD"
    -- Add your own mappings below:
    ["OLD_TEXT"] = "NEW",
}
```

### How to Find Keybind Text

1. Look at your action bars in-game to see the current keybind text
2. If the text is truncated (e.g., "mouseb..."), you may need to:
   - Temporarily enable debug mode (see below)
   - Or check WoW's keybinding interface for the full name

### Common Keybind Examples

```lua
-- Modifier keys
["SHIFT"] = "S",
["CTRL"] = "C",
["ALT"] = "A",

-- Mouse buttons
["Mouse Button 3"] = "M3",
["Mouse Button 4"] = "M4",
["Mouse Button 5"] = "M5",
["Mouse Wheel Up"] = "MWU",
["Mouse Wheel Down"] = "MWD",

-- Special characters
["["] = "LB",
["]"] = "RB",

-- Compound keybinds (with modifiers)
["s-,"] = "LA",      -- Shift + comma
["c-A"] = "CA",      -- Ctrl + A
["a-B"] = "AB",      -- Alt + B
```

## Usage

Once installed, the addon works automatically:

1. **On Login**: The addon loads and intercepts keybind text updates
2. **Automatic Updates**: Keybinds are replaced whenever WoW updates them
3. **Manual Trigger**: Type `/kbtr` to manually force an update

## Commands

- `/kbtr` - Manually force a keybind text update on all action bars

## How It Works

The addon uses a lightweight interception technique:

1. Hooks into WoW's `SetText()` function for action bar hotkey elements
2. When WoW tries to set keybind text, the addon intercepts it
3. Checks if the text matches any entry in your lookup table
4. Replaces the text before it's displayed (or leaves it unchanged)

This approach is efficient because:

- **No polling**: Only runs when WoW actually updates keybind text
- **No continuous processing**: Events trigger updates, not timers
- **Minimal overhead**: Simple table lookup and string comparison

## Troubleshooting

### Keybinds aren't changing

- Make sure the text in your lookup table exactly matches what WoW displays
- Text matching is case-sensitive and must be exact
- Try typing `/kbtr` to manually force an update

### Addon not loading

- Check that the folder name doesn't have any special characters
- Verify the `.toc` file is present and properly formatted
- Look for error messages in-game (install BugSack/BugGrabber to see errors)

### Performance concerns

- The addon uses minimal resources and should not impact game performance
- All replacements are done via efficient table lookups
- No continuous frame updates or polling occurs

## For Custom Keyboard Users

This addon is particularly useful if you use a custom keyboard (like Corne, Ergodox, etc.) with custom key mappings. Since WoW displays the actual keys sent to the game, you can use this addon to show more meaningful labels that match your physical key layout.

## Technical Details

- **Interface Version**: 30300 (WoW Classic - Wrath of the Lich King)
- **Dependencies**: None
- **Language**: Lua
- **Performance**: Event-driven, no continuous polling

## License

Free to use and modify for personal use.

## Credits

Created for custom keyboard enthusiasts who want cleaner keybind displays on their action bars.
