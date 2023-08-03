-- CONFIG
local appsToAutoTile = {"Finder"}

--------------------------------------------------------------------------------

---autotile all windows that belong to the window filter
---@param windowSource hs.window.filter
local function autoTile(windowSource)
	local wins = windowSource:getWindows()

	if #wins == 1 then
		wins[1]:moveToUnit(hs.layout.maximized)
	elseif #wins == 2 then
		wins[1]:moveToUnit(hs.layout.left50)
		wins[2]:moveToUnit(hs.layout.right50)
	elseif #wins == 3 then
		wins[1]:moveToUnit({ h = 1, w = 0.33, x = 0, y = 0 })
		wins[2]:moveToUnit({ h = 1, w = 0.34, x = 0.33, y = 0 })
		wins[3]:moveToUnit({ h = 1, w = 0.33, x = 0.67, y = 0 })
	elseif #wins == 4 then
		wins[1]:moveToUnit({ h = 0.5, w = 0.5, x = 0, y = 0 })
		wins[2]:moveToUnit({ h = 0.5, w = 0.5, x = 0, y = 0.5 })
		wins[3]:moveToUnit({ h = 0.5, w = 0.5, x = 0.5, y = 0 })
		wins[4]:moveToUnit({ h = 0.5, w = 0.5, x = 0.5, y = 0.5 })
	end

	-- bring all windows to the front
	if #wins > 1 then
		local app = hs.application.frontmostApplication()
		app:selectMenuItem { "Window", "Bring All to Front" }
	end
end

---triggers auto-tiling for all finder windows when a Finder window is
---created or closed
Wf_finder = hs.window.filter.new(appsToAutoTile)
	:setOverrideFilter({
		-- exclude various special windows for Finder.app
		rejectTitles = { "^Quick Look$", "^Move$", "^Copy$", "^Finder Settings$", " Info$", "^$" }, -- "^$" excludes the Desktop, which has no window title
		allowRoles = "AXStandardWindow",
		hasTitlebar = true,
	})
	:subscribe(hs.window.filter.windowCreated, function() autoTile(Wf_finder) end)
	:subscribe(hs.window.filter.windowDestroyed, function() autoTile(Wf_finder) end)
