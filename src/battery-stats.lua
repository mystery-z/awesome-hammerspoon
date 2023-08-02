-- press control+b to show battery stats
hs.hotkey.bind({'ctrl'}, 'B', function()
	local battery_report = "Percentage: "..hs.battery.percentage().."\n Cycles: "..hs.battery.cycles().."\n Status: "..	hs.battery.capacity().."mAh/"..hs.battery.designCapacity().."mAh"
	hs.dialog.alert(100, 100, testCallbackFn, "Custom Battery Alert", battery_report, "Close", None, "NSCriticalAlertStyle")
end)