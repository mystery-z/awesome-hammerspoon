-- on launch, automatically open a specific server instead of the friends tab. 
-- example URL is the discord Obsidian server (who needs friends if you have Obsidian?)
discordAppWatcher = hs.application.watcher.new(function(appName, eventType)
	if eventType == hs.application.watcher.launched and appName == "Discord" then
		openLinkInBackground("discord://discord.com/channels/686053708261228577/700466324840775831")
	end
end):start()
