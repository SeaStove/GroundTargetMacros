-- Function to create or edit macros for ground-targeted spells
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

                if spellName and GTMUtils:IsGroundTargeted(spellID) then
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


local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
    self[event](self, event, ...)
end

function f:PLAYER_ENTERING_WORLD(event)
    CreateGroundTargetMacros()
end

function f:ADDON_LOADED(event, addon)
    if addon == "GroundTargetMacros" then
        CreateGroundTargetMacros()
    end
end

function f:SPELLS_CHANGED(event)
    CreateGroundTargetMacros()
end

f:RegisterEvent("SPELLS_CHANGED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", f.OnEvent)

function f:InitializeOptions()
    self.panel = CreateFrame("Frame")
    self.panel.name = "HelloWorld"

    local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, -20)
    cb.Text:SetText("Print when you jump")
    -- there already is an existing OnClick script that plays a sound, hook it
    cb:HookScript("OnClick", function(_, btn, down)
        self.db.someOption = cb:GetChecked()
    end)
    cb:SetChecked(self.db.someOption)

    local btn = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
    btn:SetPoint("TOPLEFT", cb, 0, -40)
    btn:SetText("Click me")
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        print("You clicked me!")
    end)

    InterfaceOptions_AddCategory(self.panel)
end

SLASH_HELLOWORLD1 = "/hw"
SLASH_HELLOWORLD2 = "/helloworld"

SlashCmdList.HELLOWORLD = function(msg, editBox)
    InterfaceOptionsFrame_OpenToCategory(f.panel)
end
