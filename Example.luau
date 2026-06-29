--[[
    Kavo UI Library — Optimized Edition
    Safe usage example (PC + Mobile)

    Docs (original API): https://xheptcofficial.gitbook.io/kavo-library
]]

-- 1) Load the library. Replace the URL with your own raw link.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/Main.luau"))()

-- 2) (Optional but recommended) Executor-safe cloneref helper.
--    The library already uses cloneref internally, but if you reference
--    CoreGui / services yourself, wrap them like this so your script is
--    harder to detect and never holds a dangling reference.
local executorCloneref = cloneref
local function cloneref(obj)
    if typeof(obj) ~= "Instance" then
        return obj
    end
    if type(executorCloneref) ~= "function" then
        return obj
    end
    local success, ref = pcall(executorCloneref, obj)
    if success and ref ~= nil then
        return ref
    end
    return obj
end

-- 3) Create the window. Second arg is a theme name or a custom theme table.
local Window = Library.CreateLib("Kavo • Optimized", "DarkTheme")

-- 4) Build your UI.
local Main = Window:NewTab("Main")
local Combat = Main:NewSection("Combat")

Combat:NewButton("Kill All", "Eliminates every player", function()
    print("Button pressed (works on PC click and mobile tap)")
end)

Combat:NewToggle("God Mode", "Toggles invincibility", function(state)
    print("Toggle:", state)
end)

Combat:NewSlider("WalkSpeed", "Sets your walk speed", 200, 16, function(value)
    print("Slider:", value)
end)

Combat:NewDropdown("Weapon", "Pick a weapon", {"Sword", "Bow", "Staff"}, function(option)
    print("Dropdown:", option)
end)

Combat:NewKeybind("Toggle UI", "Show / hide the window", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

local Settings = Window:NewTab("Settings")
local Theme = Settings:NewSection("Theme")

Theme:NewColorPicker("Accent", "Changes the scheme color", Color3.fromRGB(74, 99, 135), function(color)
    -- Runtime theme change. With the optimized build this repaints ONCE,
    -- instead of every frame.
    Library:ChangeColor("SchemeColor", color)
end)

Theme:NewLabel("Made with the optimized Kavo build")
