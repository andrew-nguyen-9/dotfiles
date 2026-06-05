-- REQUIRED MODULES
local utils = require("utils")
local pasteOcrText = require("ocr-paste")

-- SUPER & HYPER KEYS
super = {'cmd', 'ctrl', 'alt'}
hyper = {'cmd', 'ctrl', 'alt', 'shift'}

----------------------------------
------------- SUPERS -------------
----------------------------------

-- BYPASS PASTE BLOCKING
hs.hotkey.bind(super, "v", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents()) 
end)

-- PLAIN TEXT PASTE
hs.hotkey.bind(super, "p", function()
  local plain = hs.pasteboard.getContents()
  hs.pasteboard.setContents(plain)
  hs.eventtap.keyStroke({"cmd"}, "v")
end)

----------------------------------
------------- HYPERS -------------
----------------------------------

-- TOGGLE CAFFEINE
hs.hotkey.bind(hyper, "0", utils.toggleCaffeine)

-- RELOAD HAMMERSPOON
hs.hotkey.bind(hyper, 'h', function()
  hs.application.launchOrFocus("Hammerspoon")
  hs.reload()
end)

-- RELOAD KARABINER
hs.hotkey.bind(hyper, 'k', function()
  hs.execute("launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server", true)
  hs.alert.show("Karabiner reloaded")
end)

-- TOGGLE DARK MODE
hs.hotkey.bind(hyper, "m", utils.toggleDarkMode)

-- PASTE OCR TEXT
hs.hotkey.bind(hyper, 'p', pasteOcrText)

-- CLIPBOARD TRANSFORMS
hs.hotkey.bind(hyper, "t", utils.transformClipboard)

-- EMPTY TRASH
hs.hotkey.bind(hyper, "x", utils.emptyTrash)