GroundTargetMacros = CreateFrame("Frame", "GroundTargetMacrosFrame")

local function CreateGroundTargetMacros()
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
                    local macroName = spellName .. " (Ground)"
                    local macroBody = "#showtooltip " .. spellName .. "\n/cast [@cursor] " .. spellName

                    -- Check if the macro already exists
                    local macroSlot = GetMacroIndexByName(macroName)
                    if macroSlot == 0 and numMacros < MAX_ACCOUNT_MACROS then
                        -- Create a new macro
                        CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroBody, true)
                    end
                end
            end
        end
    end
end

function GroundTargetMacros:OnEvent(event, ...)
    self[event](self, event, ...)
end

function GroundTargetMacros:PLAYER_ENTERING_WORLD(event)
    CreateGroundTargetMacros()
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
        print("You loaded this addon " .. self.db.sessions .. " times")
        local version, build, _, tocversion = GetBuildInfo()
        print(format("The current WoW build is %s (%d) and TOC is %d", version, build, tocversion))
        self:InitializeOptions()
        CreateGroundTargetMacros()
    end
end

function GroundTargetMacros:SPELLS_CHANGED(event)
    CreateGroundTargetMacros()
end

GroundTargetMacros:RegisterEvent("SPELLS_CHANGED")
GroundTargetMacros:RegisterEvent("ADDON_LOADED")
GroundTargetMacros:RegisterEvent("PLAYER_ENTERING_WORLD")

GroundTargetMacros:SetScript("OnEvent", GroundTargetMacros.OnEvent)
