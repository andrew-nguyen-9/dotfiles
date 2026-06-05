-- ============================================================
-- ocr-paste.lua  — Transforms copied images into text via Tesseract OCR
-- ============================================================

local function pasteOcrText()
  local image = hs.pasteboard.readImage()
  if not image then
    hs.alert.show("OCR: no image on clipboard")
    return
  end

  local tmpDir    = os.getenv("TMPDIR") or "/private/tmp/"
  local imagePath = tmpDir .. "ocr_image.png"
  local outputBase = tmpDir .. "ocr_output"
  local outputTxt  = outputBase .. ".txt"

  image:saveToFile(imagePath, "png")

  if not hs.fs.attributes(imagePath) then
    hs.alert.show("OCR: image failed to save")
    return
  end

  local tesseract = "/opt/homebrew/bin/tesseract"  -- set to your `which tesseract`
  local output, success = hs.execute(
    tesseract .. " -l eng " .. imagePath .. " " .. outputBase .. " 2>&1", true
  )

  if success then
    local file = io.open(outputTxt, "r")
    if file then
      local content = file:read("*all")
      file:close()
      hs.eventtap.keyStrokes(content)
    else
      hs.alert.show("OCR: could not read output")
    end
  else
    hs.alert.show("OCR failed: " .. (output or "unknown"))
  end

  -- cleanup runs regardless, and only references vars that now exist
  os.remove(imagePath)
  os.remove(outputTxt)
end

return pasteOcrText