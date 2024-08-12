GroundTargetMacros = CreateFrame("Frame", "GroundTargetMacrosFrame")

local function CreateOrUpdateMacro(macroName, macroBody, numMacros)
    local macroSlot = GetMacroIndexByName(macroName)
    if macroSlot == 0 and numMacros < MAX_ACCOUNT_MACROS then
        -- Create a new macro
        CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroBody, true)
    elseif macroSlot > 0 then
        -- Update existing macro
        EditMacro(macroSlot, macroName, "INV_MISC_QUESTIONMARK", macroBody)
    end
end

function GroundTargetMacros:CheckForUpdate()
    local currentVersion = C_AddOns.GetAddOnMetadata("GroundTargetMacros", "Version")
    local savedVersion = self.db.version

    if savedVersion ~= currentVersion then
        -- Print update message to the user
        print("|cff33ff99Ground Target Macros:|r Your addon has been updated to version " .. currentVersion .. ".")
        print(
            "|cff33ff99Ground Target Macros:|r New features include the ability to create [@player] and [@mouseover] macros! Check the options panel > AddOns tab to enable them."
        )

        -- Update the saved version to the current version
        self.db.version = currentVersion
    end
end

function GroundTargetMacros:CreateGroundTargetMacros()
    local numMacros = GetNumMacros()

    -- Iterate through the player's spellbook
    for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
        local offset = skillLineInfo.itemIndexOffset
        local numSpells = skillLineInfo.numSpellBookItems

        if offset and numSpells then
            for j = offset + 1, offset + numSpells do
                local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(j, Enum.SpellBookSpellBank.Player)
                local spellID = spellBookItemInfo.spellID
                local spellName = spellBookItemInfo.name

                if spellName and Utils:IsGroundTargeted(spellID) then
                    local macroBody = "#showtooltip " .. spellName .. "\n"

                    -- Create macros based on selected options
                    if GroundTargetMacros.db.playerMacros then
                        local playerMacroName = spellName .. " (Player)"
                        local playerMacroBody = macroBody .. "/cast [@player] " .. spellName
                        CreateOrUpdateMacro(playerMacroName, playerMacroBody, numMacros)
                    end

                    if GroundTargetMacros.db.mouseoverMacros then
                        local mouseoverMacroName = spellName .. " (Mouseover)"
                        mouseoverMacroBody = macroBody .. "/cast [@mouseover] " .. spellName
                        CreateOrUpdateMacro(mouseoverMacroName, mouseoverMacroBody, numMacros)
                    end

                    -- Default ground-targeted macro
                    local macroName = spellName .. " (Ground)"
                    macroBody = "#showtooltip " .. spellName .. "\n/cast [@cursor] " .. spellName
                    CreateOrUpdateMacro(macroName, macroBody, numMacros)
                end
            end
        end
    end
end

function GroundTargetMacros:OnEvent(event, ...)
    self[event](self, event, ...)
end

function GroundTargetMacros:PLAYER_ENTERING_WORLD(event)
    GroundTargetMacros:CreateGroundTargetMacros()
end

function GroundTargetMacros:ADDON_LOADED(event, addon)
    if addon == "GroundTargetMacros" then
        GroundTargetMacrosDB = GroundTargetMacrosDB or {}
        self.db = GroundTargetMacrosDB
        for k, v in pairs(self.defaults) do
            if self.db[k] == nil then
                self.db[k] = v
            end
        end
        self.db.sessions = self.db.sessions + 1
        -- print("You loaded this addon " .. self.db.sessions .. " times")
        -- local version, build, _, tocversion = GetBuildInfo()
        -- print(format("The current WoW build is %s (%d) and TOC is %d", version, build, tocversion))

        -- Check for updates and notify the user
        self:CheckForUpdate()

        self:InitializeOptions()
        GroundTargetMacros:CreateGroundTargetMacros()
    end
end

function GroundTargetMacros:SPELLS_CHANGED(event)
    GroundTargetMacros:CreateGroundTargetMacros()
end

GroundTargetMacros:RegisterEvent("SPELLS_CHANGED")
GroundTargetMacros:RegisterEvent("ADDON_LOADED")
GroundTargetMacros:RegisterEvent("PLAYER_ENTERING_WORLD")

GroundTargetMacros:SetScript("OnEvent", GroundTargetMacros.OnEvent)
