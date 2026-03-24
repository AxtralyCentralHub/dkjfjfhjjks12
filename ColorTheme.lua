local ColorTheme = {}
local HttpService = game:GetService("HttpService")

local themes = {
	Dark = {
		accent = Color3.fromRGB(78, 127, 252),
		main = Color3.fromRGB(8, 8, 13),
		icon = Color3.fromRGB(255, 255, 255)
	},
	Neon = {
		accent = Color3.fromRGB(0, 255, 255),
		main = Color3.fromRGB(10, 10, 20),
		icon = Color3.fromRGB(255, 255, 255)
	},
	Purple = {
		accent = Color3.fromRGB(180, 0, 255),
		main = Color3.fromRGB(15, 8, 25),
		icon = Color3.fromRGB(255, 255, 255)
	},
	Green = {
		accent = Color3.fromRGB(0, 255, 100),
		main = Color3.fromRGB(8, 20, 15),
		icon = Color3.fromRGB(255, 255, 255)
	},
	Red = {
		accent = Color3.fromRGB(255, 50, 50),
		main = Color3.fromRGB(25, 8, 8),
		icon = Color3.fromRGB(255, 255, 255)
	}
}

local currentTheme = "Dark"
local configPath = "ColorTheme_Config.json"

local currentColors = {
	accent = themes.Dark.accent,
	main = themes.Dark.main,
	icon = themes.Dark.icon
}

local function color3ToTable(color)
	return {
		r = math.floor(color.R * 255),
		g = math.floor(color.G * 255),
		b = math.floor(color.B * 255)
	}
end

local function tableToColor3(tbl)
	return Color3.fromRGB(tbl.r, tbl.g, tbl.b)
end

function ColorTheme.ApplyTheme(themeName)
	if not themes[themeName] then
		return false
	end
	
	currentTheme = themeName
	local theme = themes[themeName]
	
	currentColors.accent = theme.accent
	currentColors.main = theme.main
	currentColors.icon = theme.icon
	
	return true
end

function ColorTheme.SetAccentColor(r, g, b)
	currentColors.accent = Color3.fromRGB(r, g, b)
	currentTheme = "Custom"
end

function ColorTheme.SetMainColor(r, g, b)
	currentColors.main = Color3.fromRGB(r, g, b)
	currentTheme = "Custom"
end

function ColorTheme.SetIconColor(r, g, b)
	currentColors.icon = Color3.fromRGB(r, g, b)
	currentTheme = "Custom"
end

function ColorTheme.GetCurrentTheme()
	return currentTheme
end

function ColorTheme.GetColors()
	return {
		accent = currentColors.accent,
		main = currentColors.main,
		icon = currentColors.icon
	}
end

function ColorTheme.SaveConfig()
	local success = pcall(function()
		local config = {
			theme = currentTheme,
			colors = {
				accent = color3ToTable(currentColors.accent),
				main = color3ToTable(currentColors.main),
				icon = color3ToTable(currentColors.icon)
			}
		}
		
		local json = HttpService:JSONEncode(config)
		writefile(configPath, json)
	end)
	
	return success
end

function ColorTheme.LoadConfig()
	local success = pcall(function()
		if not isfile(configPath) then
			return false
		end
		
		local json = readfile(configPath)
		local config = HttpService:JSONDecode(json)
		
		if config.theme and themes[config.theme] then
			ColorTheme.ApplyTheme(config.theme)
		elseif config.colors then
			currentColors.accent = tableToColor3(config.colors.accent)
			currentColors.main = tableToColor3(config.colors.main)
			currentColors.icon = tableToColor3(config.colors.icon)
			currentTheme = "Custom"
		end
		
		return true
	end)
	
	return success or false
end

function ColorTheme.ResetToDefault()
	ColorTheme.ApplyTheme("Dark")
	pcall(function()
		if isfile(configPath) then
			delfile(configPath)
		end
	end)
end

function ColorTheme.GetThemeList()
	local list = {}
	for name, _ in pairs(themes) do
		table.insert(list, name)
	end
	return list
end

ColorTheme.LoadConfig()

return ColorTheme
