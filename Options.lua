GroundTargetMacros.defaults = {
	sessions = 0,
	playerMacros = false,
	mouseoverMacros = false
}

function GroundTargetMacros:DeleteAllMacros()
	local _, numCharacterMacros = GetNumMacros()

	-- Loop through character macros in reverse order, starting from the last one
	for i = 120 + numCharacterMacros, 121, -1 do
		local name, _, _, _ = GetMacroInfo(i)
		if name and (name:find(" %(Ground%)") or name:find(" %(Player%)") or name:find(" %(Mouseover%)")) then
			DeleteMacro(i)
		end
	end
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

	local cb_mouseover_macros = self:CreateCheckbox("mouseoverMacros", "Also create mouseover macros", self.panel_main)
	cb_mouseover_macros:SetPoint("TOPLEFT", cb_player_macros, 0, -30)

	local btn_reset = CreateFrame("Button", nil, self.panel_main, "UIPanelButtonTemplate")
	btn_reset:SetPoint("TOPLEFT", cb_mouseover_macros, 0, -40)
	btn_reset:SetText("Reset to Defaults")
	btn_reset:SetWidth(150)
	btn_reset:SetScript("OnClick", function()
		GroundTargetMacrosDB = CopyTable(GroundTargetMacros.defaults)
		self.db = GroundTargetMacrosDB
		EventRegistry:TriggerEvent("GroundTargetMacros.OnReset")
	end)

	-- Add a button to delete all macros created by the addon
	local btn_delete_macros = CreateFrame("Button", nil, self.panel_main, "UIPanelButtonTemplate")
	btn_delete_macros:SetPoint("TOPLEFT", btn_reset, 0, -40)
	btn_delete_macros:SetText("Delete Macros")
	btn_delete_macros:SetWidth(150)
	btn_delete_macros:SetScript("OnClick", function()
		self:DeleteAllMacros()
	end)

	-- Add explanation text for Delete Macros button
	local deleteMacroText = self.panel_main:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	deleteMacroText:SetPoint("LEFT", btn_delete_macros, "RIGHT", 10, 0)
	deleteMacroText:SetWidth(300)    -- Set a fixed width for wrapping
	deleteMacroText:SetJustifyH("LEFT") -- Align text to the left
	deleteMacroText:SetText("Deletes all macros created by this addon.")

	-- Add a button to delete and then rebuild the macros
	local btn_rebuild_macros = CreateFrame("Button", nil, self.panel_main, "UIPanelButtonTemplate")
	btn_rebuild_macros:SetPoint("TOPLEFT", btn_delete_macros, 0, -40)
	btn_rebuild_macros:SetText("Rebuild Macros")
	btn_rebuild_macros:SetWidth(150)
	btn_rebuild_macros:SetScript("OnClick", function()
		GroundTargetMacros:CreateGroundTargetMacros()
	end)

	-- Add explanation text for Rebuild Macros button
	local rebuildMacroText = self.panel_main:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	rebuildMacroText:SetPoint("LEFT", btn_rebuild_macros, "RIGHT", 10, 0)
	rebuildMacroText:SetWidth(300)    -- Set a fixed width for wrapping
	rebuildMacroText:SetJustifyH("LEFT") -- Align text to the left
	rebuildMacroText:SetText(
		"Creates macros using Current Settings (also happens automatically on reload, talent change, etc)")

	local category = Settings.RegisterCanvasLayoutCategory(self.panel_main, "GroundTargetMacros")
	Settings.RegisterAddOnCategory(category)
end

-- a bit more efficient to register/unregister the event when it fires a lot
function GroundTargetMacros:UpdateEvent(value, event)
	if value then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end
