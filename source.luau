local cloneref = cloneref or function(o) return o end
local clonefunction = clonefunction or function(f) return f end

local HttpService = cloneref(game:GetService("HttpService"))
local httpRequest = clonefunction((syn and syn.request) or request or http_request)

local Junkie = {}
Junkie.service = nil
Junkie.identifier = nil
Junkie.base_url = "https://api.jnkie.com/api/v1/whitelist"
Junkie.script_id = nil
Junkie.provider = nil

function Junkie.check_key(key)
	if not Junkie.service then error("service not set") end
	local resp = httpRequest({
			Method = "POST",
			Url = Junkie.base_url .. "/verifyOpen",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({
				key = tostring(key or ""),
				service = Junkie.service,
				identifier = tostring(Junkie.identifier or "unknown")
			})
		})
	
	if not resp then
		return {valid = false, error = "ERROR"}
	end
	if resp.StatusCode ~= 200 then
		return {valid = false, error = "http " .. resp.StatusCode}
	end
	
    return HttpService:JSONDecode(resp.Body)
end

function Junkie.load_script()
	if not Junkie.script_id then error("script_id not set") end
	loadstring(cloneref(game):HttpGet("https://api.jnkie.com/api/v1/luascripts/public/" .. tostring(Junkie.script_id) .. "/download"))()
	return
end

return Junkie
