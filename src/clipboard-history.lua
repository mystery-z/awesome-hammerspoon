hs.hotkey.bind({"ctrl"}, "C", function()
  hs.eventtap.keyStroke({"cmd"}, "c")
  copy = hs.pasteboard.getContents()
  for index = 8, 0, -1 do
    paste = hs.pasteboard.readAllData(tostring(index))
    if paste["public.utf8-plain-text"] == nil then
      hs.pasteboard.writeObjects("", tostring(index + 1))
    else
      hs.pasteboard.writeObjects(paste["public.utf8-plain-text"], tostring(index + 1))
    end
  end
  hs.pasteboard.writeObjects(copy, "0")
  hs.pasteboard.setContents(copy)
end)


local choices = {}
local function focusLastFocused()
  local wf = hs.window.filter
  local lastFocused = wf.defaultCurrentSpace:getWindows(wf.sortByFocusedLast)
  if #lastFocused > 0 then lastFocused[1]:focus() end
end
local chooser = hs.chooser.new(function(choice)
  if not choice then focusLastFocused(); return end
  hs.pasteboard.setContents(choice["text"])
  focusLastFocused()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)
function get_content(index)
paste = hs.pasteboard.readAllData(tostring(index));
return paste["public.utf8-plain-text"];
end
function update_choices()
choices = {}
for i = 1, 9, 1 do
  table.insert(choices,{["text"] = get_content(i)})
end
chooser:choices(choices)
end
hs.hotkey.bind({"ctrl"}, "E", function() update_choices() chooser:show() end)
