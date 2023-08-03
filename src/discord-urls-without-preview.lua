-- when Discord is focused, enclose URL in clipboard with <>
-- when Discord unfocused, removes <> from URL in clipboard
-- This is useful, since URLs enclosed in <> do not result in the annoying preview window you
-- would have to manually remove
discordAppWatcher = hs.application.watcher.new(function(appName, eventType)
	if appName ~= "Discord" then return end

	local clipb = hs.pasteboard.getContents()
	if not clipb then return end

	if eventType == hs.application.watcher.activated then
		local hasURL = clipb:match("^https?:%S+$")
		local hasObsidianURL = clipb:match("^obsidian:%S+$")
		local isTweet = clipb:match("^https?://twitter%.com") -- for tweets, the previews are actually useful
		if (hasURL or hasObsidianURL) and not isTweet then
			hs.pasteboard.setContents("<" .. clipb .. ">")
		end
	elseif eventType == hs.application.watcher.deactivated then
		local hasEnclosedURL = clipb:match("^<https?:%S+>$")
		local hasEnclosedObsidianURL = clipb:match("^<obsidian:%S+>$")
		if hasEnclosedURL or hasEnclosedObsidianURL then
			clipb = clipb:sub(2, -2) -- remove first & last character, i.e. the <>
			hs.pasteboard.setContents(clipb)
		end
	end
end):start()
