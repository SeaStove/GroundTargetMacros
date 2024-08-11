GroundTargetMacros.defaults = {
	sessions = 0,
	playerMacros = false,
	targetMacros = false
}

local function CreateIcon(icon, width, height, parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(width, height)
	f.tex = f:CreateTexture()
	f.tex:SetAllPoints(f)
	f.tex:SetTexture(icon)
	return f
end

function GroundTargetMacros:CreateCheckbox(option, label, parent, updateFunc)
	local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	cb.Text:SetText(label)
	local function UpdateOption(value)
		self.db[option] = value
		cb:SetChecked(value)
		if updateFunc then
			updateFunc(value)
		end
	end
	UpdateOption(self.db[option])
	-- there already is an existing OnClick script that plays a sound, hook it
	cb:HookScript("OnClick", function(_, btn, down)
		UpdateOption(cb:GetChecked())
	end)
	EventRegistry:RegisterCallback("GroundTargetMacros.OnReset", function()
		UpdateOption(self.defaults[option])
	end, cb)
	return cb
end

function GroundTargetMacros:InitializeOptions()
	-- main panel
	self.panel_main = CreateFrame("Frame")
	self.panel_main.name = "GroundTargetMacros"

	local cb_player_macros = self:CreateCheckbox("playerMacros", "Also create player macros", self.panel_main)
	cb_player_macros:SetPoint("TOPLEFT", 20, -20)

	local cb_target_macros = self:CreateCheckbox("targetMacros", "Also create target macros", self.panel_main)
	cb_target_macros:SetPoint("TOPLEFT", cb_player_macros, 0, -30)

	local btn_reset = CreateFrame("Button", nil, self.panel_main, "UIPanelButtonTemplate")
	btn_reset:SetPoint("TOPLEFT", cb_target_macros, 0, -40)
	btn_reset:SetText(RESET)
	btn_reset:SetWidth(100)
	btn_reset:SetScript("OnClick", function()
		GroundTargetMacrosDB = CopyTable(GroundTargetMacros.defaults)
		self.db = GroundTargetMacrosDB
		EventRegistry:TriggerEvent("GroundTargetMacros.OnReset")
	end)

	local category = Settings.RegisterCanvasLayoutCategory(self.panel_main, "GroundTargetMacros")
	Settings.RegisterAddOnCategory(category)

	-- sub panel
	local panel_shroom = CreateFrame("Frame")
	panel_shroom.name = "Shrooms"
	panel_shroom.parent = self.panel_main.name

	for i = 1, 10 do
		local icon = CreateIcon("interface/icons/inv_mushroom_11", 32, 32, panel_shroom)
		icon:SetPoint("TOPLEFT", 20, -32 * i)
	end

	local shroomCategory = Settings.RegisterCanvasLayoutSubcategory(category, panel_shroom, "Shrooms")
end

-- a bit more efficient to register/unregister the event when it fires a lot
function GroundTargetMacros:UpdateEvent(value, event)
	if value then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end
