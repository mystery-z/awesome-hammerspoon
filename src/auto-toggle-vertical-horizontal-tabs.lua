-- AUTOMATICALLY SWITCH BETWEEN VERTICAL AND HORIZONTAL TABS (IN BRAVE)
-- Caveat: does not work when opening tabs in the background though, since the
-- window title does not change then :/

PrevTabCount = 0
Wf_braveWindowTitle = hs.window.filter.new({ "Brave Browser" })
	:setOverrideFilter({ allowRoles = "AXStandardWindow" })
	:subscribe(hs.window.filter.windowTitleChanged, function()
		local success, tabCount =
			hs.osascript.applescript('tell application "Brave Browser" to count tab in first window')
		if not success then return end
		local threshold = 9
		if
			(tabCount > threshold and PrevTabCount <= threshold)
			or (tabCount <= threshold and PrevTabCount > threshold)
		then
			-- ctrl-alt-shift-9 bound to Vertical Tab Toggling in Brave Settings
			-- brave://settings/system/shortcuts
			hs.eventtap.keyStroke({ "ctrl", "alt", "shift" }, "9", 0, "Brave Browser")
		end
		PrevTabCount = tabCount
	end)
