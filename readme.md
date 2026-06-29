# Kavo UI Library — Optimized Edition

A fast, lightweight, and **mobile-friendly** rewrite of the classic [Kavo UI Library](https://xheptcofficial.gitbook.io/kavo-library) for Roblox.

This fork keeps the **exact same public API** as the original Kavo, so existing scripts work without changes — but it removes the per-frame loops that made the original freeze games, adds executor-safety, and smooths out every animation.

---

## ✨ Why this fork exists

The original Kavo spawns **one `while wait() do … end` loop per element** just to re-apply theme colors *every single frame*. A menu with 30 elements runs 30+ infinite loops forever, even when nothing changes. On lower-end devices and mobile this tanks the frame rate and **freezes the game the moment the UI is added to `CoreGui`**.

This edition replaces all of that with a single **event-driven theme system**: colors are painted **once** on creation and re-painted **only when you actually change the theme**.

---

## 🚀 What changed

| Area | Original | Optimized Edition |
| --- | --- | --- |
| **Theme updates** | 1 `while wait()` loop **per element** (dozens–hundreds running every frame) | Paint once, repaint only on `ChangeColor` — **zero idle cost** |
| **CoreGui freeze** | UI froze the game when parented to CoreGui | Fixed — no per-frame work, safe parenting |
| **Executor safety** | Raw `game.CoreGui` access | `cloneref` + `gethui()` + `protect_gui` with safe fallbacks |
| **Mobile** | Mouse-only (drag & sliders broke on touch) | Full **touch support** for dragging, sliders, color pickers |
| **Animations** | Engine-default / linear easing | Smooth **Quint easing** on buttons, toggles, dropdowns, etc. |
| **Scheduler** | Legacy `wait` / `spawn` | Uses `task.wait` / `task.spawn` when available |
| **Dead code** | Broken `for`+`while` listener loop | Removed |

> Net result: the library does **no work at all** while idle. CPU goes back to your actual script.

---

## 📦 Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/Main.luau"))()
```

Replace `USER/REPO` with your own repository path.

---

## ⚡ Quick start

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/Main.luau"))()

local Window = Library.CreateLib("My Hub", "DarkTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Features")

Section:NewButton("Click Me", "A simple button", function()
    print("clicked!")
end)

Section:NewToggle("Auto Farm", "Toggle auto farm", function(state)
    print("toggle:", state)
end)

Section:NewSlider("Speed", "WalkSpeed", 200, 16, function(value)
    print("slider:", value)
end)
```

A full, copy-paste example lives in [`Example.luau`](Example.luau).

---

## 🛡️ Executor-safe by default

The library automatically picks the safest place to put your GUI:

1. `gethui()` (hidden container) if your executor supports it,
2. otherwise a `cloneref`'d, `protect_gui`-protected `CoreGui`,
3. and falls back to `PlayerGui` on vanilla clients.

You don't have to do anything — but if your **own** script touches `CoreGui` or services, wrap them with the standard `cloneref` helper (see `Example.luau`) to stay undetected and avoid dangling references.

---

## 📱 Mobile support

- The window can be dragged with a **finger**, not just a mouse.
- **Sliders** and **color pickers** respond to touch input and release correctly.
- Buttons, toggles, dropdowns and keybinds already work via tap.

No separate mobile build — the same script runs on PC and mobile.

---

## 📚 API reference

### Window

```lua
local Window = Library.CreateLib(title, theme)
```
- `title` *(string)* — window title.
- `theme` *(string | table)* — a built-in theme name or a custom theme table.

| Method | Description |
| --- | --- |
| `Library:ToggleUI()` | Show / hide the window. |
| `Library:ChangeColor(property, color)` | Live-change a theme color. `property` is one of `Background`, `SchemeColor`, `Header`, `TextColor`, `ElementColor`. |
| `Library:DraggingEnabled(frame, parent)` | Make a custom frame draggable (PC + touch). |

### Tabs & Sections

```lua
local Tab     = Window:NewTab("Tab Name")
local Section = Tab:NewSection("Section Name")
```

### Elements

| Element | Signature |
| --- | --- |
| Button | `Section:NewButton(name, tip, callback)` |
| Toggle | `Section:NewToggle(name, tip, callback)` → `callback(state)` |
| Slider | `Section:NewSlider(name, tip, max, min, callback)` → `callback(value)` |
| Dropdown | `Section:NewDropdown(name, tip, {options}, callback)` → `callback(option)` |
| Keybind | `Section:NewKeybind(name, tip, Enum.KeyCode.X, callback)` |
| Color Picker | `Section:NewColorPicker(name, tip, defaultColor, callback)` → `callback(color)` |
| TextBox | `Section:NewTextBox(name, tip, callback)` → `callback(text)` |
| Label | `Section:NewLabel(text)` → `:UpdateLabel(newText)` |

Most elements return a handle with an `Update…` method (e.g. a button returns `:UpdateButton(newTitle)`).

---

## 🎨 Built-in themes

`DarkTheme` · `LightTheme` · `BloodTheme` · `GrapeTheme` · `Ocean` · `Midnight` · `Sentinel` · `Synapse` · `Serpent`

Or pass your own:

```lua
local Window = Library.CreateLib("My Hub", {
    SchemeColor  = Color3.fromRGB(74, 99, 135),
    Background   = Color3.fromRGB(36, 37, 43),
    Header       = Color3.fromRGB(28, 29, 34),
    TextColor    = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(32, 32, 38),
})
```

---

## ⚙️ Performance notes

- **No idle cost.** When you're not interacting, the library runs nothing.
- `ChangeColor` triggers exactly **one** repaint pass across all elements.
- Updaters for destroyed elements are pruned automatically (no leaked work).

---

## 🙏 Credits

- Original library by the **Kavo / Xhept** team — [docs](https://xheptcofficial.gitbook.io/kavo-library).
- Optimization, mobile support, and safety layer in this edition.

> This is an unofficial performance-focused fork. All original element designs and the public API are credited to the original authors.

## 📄 License

Provided as-is for educational and authorized use. Respect the terms of any game you use it in.
