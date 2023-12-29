--[[
Copyright 2012-2023 João Cardoso
All Rights Reserved
--]]

local ADDON, Addon = ...
local Bar = Addon.Base:NewClass('ProgressBar', 'Frame', true)

function Bar:New(...)
	local f = self:Super(Bar):New(...)
	f.Overlay:SetFrameLevel(f:GetFrameLevel() + Addon.MaxQuality + 1)
	f.Bars = {}

	for i = 1, Addon.MaxQuality do
		local r,g,b = Addon:GetColor(i):GetRGB()
		local bar = CreateFrame('StatusBar', nil, f)
		bar:SetStatusBarTexture('Interface/TargetingFrame/UI-StatusBar')
		bar:SetFrameLevel(f:GetFrameLevel() + i)
		bar:SetStatusBarColor(r,g,b)
		bar:SetAllPoints()

		f.Bars[i] = bar
	end
	return f
end

function Bar:SetProgress(progress)
	local owned = 0
	for i = Addon.MaxQuality, 1, -1 do
		owned = owned + progress[i].total

		self.Bars[i]:SetMinMaxValues(0, progress.total)
		self.Bars[i]:SetValue(owned)
	end

	self.Overlay.Text:SetFormattedText(PLAYERS_FOUND_OUT_OF_MAX, owned, progress.total)
	self:SetShown(progress.total > 0)
end

function Bar:IsMaximized()
	local criteria = self.Bars[Addon.sets.targetQuality]
	return criteria:GetValue() == select(2, criteria:GetMinMaxValues())
end
