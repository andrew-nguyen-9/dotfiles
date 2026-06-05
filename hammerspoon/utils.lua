-- ============================================================
-- utils.lua  —  Trash, Dark Mode, Caffeine, Clipboard transforms
-- ============================================================

local M = {}

-- ---------- 1. EMPTY TRASH ----------
function M.emptyTrash()
  local ok, result, descriptor = hs.osascript.applescript(
    'tell application "Finder" to empty trash'
  )
  if ok then
    hs.alert.show("🗑️  Trash emptied")
  else
    hs.alert.show("Trash failed: " .. hs.inspect(descriptor))
    print(hs.inspect(descriptor))  -- full error in Console
  end
end

-- ---------- 2. TOGGLE DARK / LIGHT MODE ----------
function M.toggleDarkMode()
  local script = [[
    tell application "System Events"
      tell appearance preferences
        set dark mode to not dark mode
        return dark mode
      end tell
    end tell
  ]]
  local ok, isDark = hs.osascript.applescript(script)
  if ok then
    hs.alert.show(isDark and "🌙  Dark Mode" or "☀️  Light Mode")
  else
    hs.alert.show("Couldn't toggle appearance")
  end
end

-- ---------- 3. CAFFEINE (menu-bar, with state + optional timer) ----------
local caffeine = hs.menubar.new()
local caffeineTimer = nil

local function caffeineState()
  return hs.caffeinate.get("displayIdle")
end

local function updateCaffeineIcon()
  if not caffeine then return end
  caffeine:setTitle(caffeineState() and "☕️" or "💤")
end

local function setCaffeine(on, minutes)
  -- clear any existing auto-off timer
  if caffeineTimer then caffeineTimer:stop(); caffeineTimer = nil end

  hs.caffeinate.set("displayIdle", on, true)  -- also prevent system sleep
  updateCaffeineIcon()

  if on and minutes then
    caffeineTimer = hs.timer.doAfter(minutes * 60, function()
      setCaffeine(false)
      hs.alert.show("💤  Caffeine expired")
    end)
    hs.alert.show("☕️  Awake for " .. minutes .. " min")
  else
    hs.alert.show(on and "☕️  Staying awake" or "💤  Sleep allowed")
  end
end

local function caffeineMenu()
  local on = caffeineState()
  return {
    { title = on and "● Awake (click to sleep)" or "○ Asleep (click to wake)",
      fn = function() setCaffeine(not on) end },
    { title = "-" },
    { title = "Keep awake 15 min", fn = function() setCaffeine(true, 15) end },
    { title = "Keep awake 30 min", fn = function() setCaffeine(true, 30) end },
    { title = "Keep awake 60 min", fn = function() setCaffeine(true, 60) end },
    { title = "-" },
    { title = "Turn off", fn = function() setCaffeine(false) end },
  }
end

-- Run load-time setup defensively so a failure here can't abort init.lua
if caffeine then
  local ok, err = pcall(function()
    caffeine:setMenu(caffeineMenu)
    updateCaffeineIcon()
    setCaffeine(false)
  end)
  if not ok then
    print("utils.lua caffeine setup failed: " .. tostring(err))
  end
end

-- expose a quick toggle for a hotkey too
function M.toggleCaffeine()
  setCaffeine(not caffeineState())
end

-- ---------- 4. CLIPBOARD TRANSFORMER ----------
-- Each transform is a shell pipeline: clipboard in (stdin) -> result out (stdout)
local transforms = {
  { text = "JSON pretty-print",  sub = "jq .",                          cmd = "jq ." },
  { text = "JSON minify",        sub = "jq -c .",                       cmd = "jq -c ." },
  { text = "Base64 decode",      sub = "base64 --decode",               cmd = "base64 --decode" },
  { text = "Base64 encode",      sub = "base64",                        cmd = "base64" },
  { text = "URL decode",         sub = "python3 urllib unquote",        cmd = "python3 -c 'import sys,urllib.parse as u; sys.stdout.write(u.unquote(sys.stdin.read()))'" },
  { text = "URL encode",         sub = "python3 urllib quote",          cmd = "python3 -c 'import sys,urllib.parse as u; sys.stdout.write(u.quote(sys.stdin.read()))'" },
  { text = "Lowercase",          sub = "tr A-Z a-z",                    cmd = "tr 'A-Z' 'a-z'" },
  { text = "Uppercase",          sub = "tr a-z A-Z",                    cmd = "tr 'a-z' 'A-Z'" },
  { text = "Trim whitespace",    sub = "strip leading/trailing",        cmd = "awk '{$1=$1};1'" },
}

function M.transformClipboard()
  local choices = {}
  for i, t in ipairs(transforms) do
    choices[i] = { text = t.text, subText = t.sub, cmd = t.cmd }
  end

  hs.chooser.new(function(choice)
    if not choice then return end
    local input = hs.pasteboard.getContents()
    if not input or input == "" then
      hs.alert.show("Clipboard is empty")
      return
    end

    -- pipe clipboard through the command via a heredoc-free approach:
    -- write input to a temp file, cat it into the pipeline (avoids quoting hell)
    local tmp = (os.getenv("TMPDIR") or "/private/tmp/") .. "hs_clip_in.txt"
    local f = io.open(tmp, "w")
    f:write(input)
    f:close()

    local out, ok = hs.execute("cat " .. tmp .. " | " .. choice.cmd .. " 2>&1", true)
    os.remove(tmp)

    if ok then
      hs.pasteboard.setContents(out)
      hs.alert.show("✓ " .. choice.text .. " → clipboard")
    else
      hs.alert.show("✗ Failed: " .. (out or "unknown error"))
    end
  end)
  :placeholderText("Transform clipboard…")
  :choices(choices)
  :show()
end

return M