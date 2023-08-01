-- INFO This is essentially an implementation of the inspired by the macOS app
-- [quitter](https://marco.org/apps), this module quits any app if long enough idle
--------------------------------------------------------------------------------

-- CONFIG
---times after which apps should quit, in minutes
Thresholds = {
	Slack = 15,
	Obsidian = 60,
	Mimestream = 10,
	BusyCal = 3,
	Finder = 20, -- requires `defaults write com.apple.Finder QuitMenuItem 1`
}

--------------------------------------------------------------------------------

IdleApps = {} ---table containing all apps with their last activation time

--Initialize on load: fills `IdleApps` with all running apps and the current time
for app, _ in pairs(Thresholds) do
	local now = os.time()
	IdleApps[app] = now
end

---log times when an app has been deactivated
local aw = hs.application.watcher
DeactivationWatcher = aw.new(function(app, event)
	if not app or app == "" then return end -- safeguard for special apps

	if event == aw.deactivated then
		local now = os.time()
		IdleApps[app] = now
	elseif event == aw.activated or event == aw.terminated then
		IdleApps[app] = nil -- removes active or closed app from table
	end
end):start()

---@param app string name of the app
local function quitter(app)
	print("AutoQuitter: Quitting " .. app)
	IdleApps[app] = nil
	hs.application(app):kill()
end

---check apps regularly and quit if idle for longer than their thresholds
local checkIntervallSecs = 20
AutoQuitterTimer = hs.timer
	.doEvery(checkIntervallSecs, function()
		local now = os.time()

		for app, lastActivation in pairs(IdleApps) do
			-- can't do this with guard clause, since lua has no `continue`
			local appHasThreshhold = Thresholds[app] ~= nil
			local appIsRunning = hs.application.get(app)

			if appHasThreshhold and appIsRunning then 
				local idleTimeSecs = now - lastActivation
				local thresholdSecs = Thresholds[app] * 60
				if idleTimeSecs > thresholdSecs then quitter(app) end
			end
		end
	end)
	:start()
