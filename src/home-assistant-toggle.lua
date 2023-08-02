local env = {
    ["HASS_URL"] = "http://localip:8123",
    ["HASS_TOKEN"] = "token"
  }

-- device name
function toggleDevice()
  local url = env.HASS_URL .. "/api/services/light/toggle"
  local headers = {
    ["Authorization"] = "Bearer " .. env.HASS_TOKEN,
    ["Content-Type"] = "application/json"
  }
  local body = '{"entity_id": "light.device_name"}'
  hs.http.post(url, body, headers)
end

-- keybinding(s)
hs.hotkey.bind({"cmd", "ctrl"}, "1", toggleDevice)