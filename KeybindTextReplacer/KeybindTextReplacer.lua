-- KeybindTextReplacer
-- Replaces keybind text on action bars using a custom lookup table
---@diagnostic disable: undefined-global

local addonName, addon = ...

-- LOOKUP TABLE - Add your key/value pairs here
-- Key = current keybind text, Value = what you want to replace it with
local keybindReplacements = {
	["a-B"] = "AB",

	["c-A"] = "CA",
	["c-S"] = "CS",
	["c-D"] = "CD",
	["c-F"] = "CF",

	["s-,"] = "LA",
	["s-9"] = "LS",
	["["] = "LD",
	["s-["] = "LF",

	["a-0"] = "A0",
	["c-0"] = "C0",

	["s-5"] = "LT",

	["5"] = "LC",
	["6"] = "LV",
	["7"] = "LB",

	["Mouse Wheel Down"] = "WD",
	["a-Mouse Wheel Down"] = "AWD",
	["c-Mouse Wheel Down"] = "CWD",

	["Mouse Wheel Up"] = "WU",
	["a-Mouse Wheel Up"] = "AWU",
	["c-Mouse Wheel Up"] = "CWU",

	["Mouse Button 4"] = "B4",
	["a-Mouse Button 4"] = "AB4",
	["c-Mouse Button 4"] = "CB4",

	["Mouse Button 5"] = "B5",
	["a-Mouse Button 5"] = "AB5",
	["c-Mouse Button 5"] = "CB5",

	["Middle Mouse"] = "M",
	["a-Middle Mouse"] = "AM",
	["c-Middle Mouse"] = "CM",
}

-- Function to escape special pattern characters
local function EscapePattern(str)
	-- Escape all special Lua pattern characters
	return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
end

-- Function to replace text according to lookup table
local function ReplaceKeybindText(text)
	if not text or text == "" then
		return text
	end

	-- Only do exact match
	if keybindReplacements[text] then
		return keybindReplacements[text]
	end

	-- No match, return original text
	return text
end

local hotkeyHooked = {}
local hotkeyReentrancyGuard = {}

-- Hook into the default action button hotkey text update
local function UpdateActionButtonHotkey(button)
	if not button then
		return
	end

	-- Try different ways to find the hotkey element
	local hotkey = button.HotKey or button.hotkey or button:GetName() and _G[button:GetName() .. "HotKey"]

	if not hotkey then
		return
	end

	if not hotkeyHooked[hotkey] then
		hotkeyHooked[hotkey] = true
		hooksecurefunc(hotkey, "SetText", function(self, text)
			if hotkeyReentrancyGuard[self] or not text or text == "" then
				return
			end

			local newText = ReplaceKeybindText(text)
			if newText ~= text then
				hotkeyReentrancyGuard[self] = true
				self:SetText(newText)
				hotkeyReentrancyGuard[self] = nil
			end
		end)
	end

	local text = hotkey:GetText()
	if text and text ~= "" then
		local newText = ReplaceKeybindText(text)
		if newText ~= text then
			hotkeyReentrancyGuard[hotkey] = true
			hotkey:SetText(newText)
			hotkeyReentrancyGuard[hotkey] = nil
		end
	end
end

-- Hook the function that updates action button hotkeys
local function HookActionButtons()
	-- Hook the global function that updates hotkey text
	if ActionButton_UpdateHotkeys then
		hooksecurefunc("ActionButton_UpdateHotkeys", function(actionButtonType)
			-- actionButtonType can be either a string or a button object
			if type(actionButtonType) == "table" then
				-- It's a button object, update it directly
				UpdateActionButtonHotkey(actionButtonType)
			elseif type(actionButtonType) == "string" then
				-- It's a string prefix, update all buttons with that prefix
				for i = 1, 12 do
					local buttonName = actionButtonType .. i
					local button = _G[buttonName]
					if button then
						UpdateActionButtonHotkey(button)
					end
				end
			end
		end)
	end

	-- Also hook the individual button update function
	hooksecurefunc("ActionButton_Update", function(button)
		UpdateActionButtonHotkey(button)
	end)

	-- Hook for MultiActionBar buttons (if available)
	if MultiActionBar_Update then
		hooksecurefunc("MultiActionBar_Update", function()
			-- Update all visible bars
			for barIndex = 1, 6 do
				for i = 1, 12 do
					local button = _G["MultiBarBottomLeftButton" .. i]
						or _G["MultiBarBottomRightButton" .. i]
						or _G["MultiBarRightButton" .. i]
						or _G["MultiBarLeftButton" .. i]
						or _G["MultiBar5Button" .. i]
						or _G["MultiBar6Button" .. i]
						or _G["MultiBar7Button" .. i]

					if button then
						UpdateActionButtonHotkey(button)
					end
				end
			end
		end)
	end
end

-- Force update all action buttons
local function ForceUpdateAllButtons()
	local buttonTypes = {
		"ActionButton",
		"MultiBarBottomLeftButton",
		"MultiBarBottomRightButton",
		"MultiBarRightButton",
		"MultiBarLeftButton",
		"MultiBar5Button",
		"MultiBar6Button",
		"MultiBar7Button",
		"ShapeshiftButton",
		"PetActionButton",
		"StanceButton",
	}

	for _, buttonType in ipairs(buttonTypes) do
		for i = 1, 12 do
			local button = _G[buttonType .. i]
			if button then
				UpdateActionButtonHotkey(button)
			end
		end
	end
end

-- Slash command to manually trigger update
SLASH_KBTR1 = "/kbtr"
SlashCmdList["KBTR"] = function(msg)
	print("Forcing keybind text update...")
	ForceUpdateAllButtons()
	print("Update complete!")
end

-- Initialize the addon
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UPDATE_BINDINGS")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		HookActionButtons()
		print("|cff00ff00" .. addonName .. "|r loaded. Keybind text replacement active.")
		print("Type /kbtr to manually update keybinds")

		-- Force an initial update of all buttons after a short delay
		-- This sets up the hooks on all existing buttons
		C_Timer.After(0.5, function()
			ForceUpdateAllButtons()
		end)
	elseif event == "UPDATE_BINDINGS" then
		-- Keybinds changed, update all buttons once
		C_Timer.After(0.1, function()
			ForceUpdateAllButtons()
		end)
	end
end)
