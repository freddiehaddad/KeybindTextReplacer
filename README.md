# Keybind Text Replacer

Tired of seeing "a-Mouse Button 4" or "s-[" on your action bars? This addon lets you replace those messy keybind labels with whatever you want -- like "MB4" or "MWU".

Perfect for anyone who wants cleaner action bars or uses a custom keyboard layout.

## What Does It Do?

This addon watches your action bars and swaps out keybind text based on a simple list you create. If you bind a spell to `Ctrl + Mouse Button 4`, WoW shows `c-mouse button 4` or `c-mouse...` -- but with this addon, you can make it show `CB4` (or anything else) instead.

## Getting Started

### 1. Install the Addon

- Download this addon
- Put the `KeybindTextReplacer` folder inside:

  ```text
  World of Warcraft\_retail_\Interface\AddOns\
  ```

- Type `/reload` in-game (or restart WoW)

### 2. Customize Your Labels

Open `KeybindTextReplacer.lua` and find the section that looks like this:

```lua
local keybindReplacements = {
    ["a-B"] = "AB",
    ["Mouse Wheel Down"] = "WD",
    ["c-A"] = "CA",
}
```

Add your own entries! The left side is what WoW shows, the right side is what you want instead.

**Examples:**

```lua
["Mouse Button 4"] = "M4",          -- Show "M4" instead of "Mouse Button 4"
["a-Mouse Button 5"] = "AM5",       -- Alt + Mouse 5
["s-,"] = "Comma",                  -- Shift + comma
["["] = "BracketLeft",              -- Left bracket key
["5"] = "Five",                     -- Number 5
```

### 3. Save and Reload

After editing the file, type `/reload` in WoW to see your changes.

## Tips

### Finding the Original Text

Just look at your action bars! WoW shows the current keybind on each button. If you can't see the full text (it's cut off), try typing `/kbtr` in-game to refresh everything.

### Common Modifiers

- `s-` = Shift
- `c-` = Control  
- `a-` = Alt

So `s-5` means "Shift + 5", and `c-Mouse Button 4` means "Control + Mouse Button 4".

### Exact Matches Only

The text on the left must match *exactly* what WoW displays—including capital letters and spaces. If it doesn't match, the addon won't replace it.

## Commands

- `/kbtr` - Force the addon to update all your action bars right now

## Why Use This?

- **Custom Keyboards**: If you use something like an Ergodox or split keyboard with your own layout, WoW's default labels might not make sense. Now you can show labels that match your actual keys.
- **Cleaner Bars**: Replace long text like "Mouse Wheel Up" with "WU" to save space.
- **Personal Preference**: Just want your bars to look the way *you* want? Go for it.

## Need Help?

### Nothing's changing on my bars

- Double-check that the left side of your entry matches the text WoW shows *exactly*
- Try typing `/kbtr` to force an update
- Make sure you saved the file and typed `/reload`

### Addon won't load

- Make sure the folder is named `KeybindTextReplacer` (no extra spaces or characters)
- Check that `KeybindTextReplacer.toc` is inside the folder

## That's It

No complicated setup, no extra settings window—just edit a simple list and your bars will look however you want. Enjoy your cleaner UI!
