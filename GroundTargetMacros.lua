-- Function to determine if a spell is ground-targeted
local function IsGroundTargeted(spellID)
    local groundTargetedSpells = {
        -- Death Knight
        [43265] = true,  -- Death and Decay (Death Knight)
        [152280] = true, -- Defile (Death Knight)
        [51052] = true,  -- Anti-Magic Zone (Death Knight)
        [108201] = true, -- Desecrated Ground (Death Knight)
        -- Demon Hunter
        [189110] = true, -- Infernal Strike (Demon Hunter)
        [191427] = true, -- Metamorphosis (Havoc) (Demon Hunter)
        [202137] = true, -- Sigil of Silence (Demon Hunter)
        [202138] = true, -- Sigil of Chains (Demon Hunter)
        [204596] = true, -- Sigil of Flame (Demon Hunter)
        [207684] = true, -- Sigil of Misery (Demon Hunter)
        -- Druid
        [102793] = true, -- Ursol's Vortex (Druid)
        [191034] = true, -- Starfall (Druid)
        [205636] = true, -- Force of Nature (Druid)
        [202770] = true, -- Fury of Elune (Druid)
        -- Hunter
        [1543] = true,   -- Flare (Hunter)
        [6197] = true,   -- Eagle Eye (Hunter)
        [109248] = true, -- Binding Shot (Hunter)
        [162488] = true, -- Steel Trap (Hunter)
        [206817] = true, -- Sentinel (Hunter)
        -- Mage
        [2120] = true,   -- Flamestrike (Mage)
        [33395] = true,  -- Freeze (Mage)
        [113724] = true, -- Ring of Frost (Mage)
        [153561] = true, -- Meteor (Mage)
        [190356] = true, -- Blizzard (Mage)
        -- Monk
        [115313] = true, -- Summon Jade Serpent Statue (Monk)
        [115315] = true, -- Summon Black Ox Statue (Monk)
        [116844] = true, -- Ring of Peace (Monk)
        -- Paladin
        [114158] = true, -- Light's Hammer (Paladin)
        -- Priest
        [32375] = true,  -- Mass Dispel (Priest)
        [81782] = true,  -- Power Word: Barrier (Priest)
        [121536] = true, -- Angelic Feather (Priest)
        [205385] = true, -- Shadow Crash (Priest)
        -- Rogue
        [1725] = true,   -- Distract (Rogue)
        [185767] = true, -- Cannonball Barrage (Rogue)
        [195457] = true, -- Grappling Hook (Rogue)
        -- Shaman
        [2484] = true,   -- Earthbind Totem (Shaman)
        [6196] = true,   -- Far Sight (Shaman)
        [61882] = true,  -- Earthquake (Shaman)
        [73920] = true,  -- Healing Rain (Shaman)
        [98008] = true,  -- Spirit Link Totem (Shaman)
        [51485] = true,  -- Earthgrab Totem (Shaman)
        [192058] = true, -- Lightning Surge Totem (Shaman)
        [192222] = true, -- Liquid Magma Totem (Shaman)
        [196932] = true, -- Voodoo Totem (Shaman)
        [192077] = true, -- Wind Rush Totem (Shaman)
        [204332] = true, -- Windfury Totem (Shaman)
        [207399] = true, -- Ancestral Protection Totem (Shaman)
        [215864] = true, -- Rainfall (Shaman)
        -- Warlock
        [1122] = true,   -- Summon Infernal (Warlock)
        [5740] = true,   -- Rain of Fire (Warlock)
        [30283] = true,  -- Shadowfury (Warlock)
        [152108] = true, -- Cataclysm (Warlock)
        [278350] = true, -- Vile Taint (Warlock)
        -- Warrior
        [6544] = true,   -- Heroic Leap (Warrior)
        [152277] = true, -- Ravager (Arms) (Warrior)
        [228920] = true, -- Ravager (Protection) (Warrior)
    }
    return groundTargetedSpells[spellID] or false
end

-- Function to create or edit macros for ground-targeted spells
local function CreateGroundTargetMacros()
    local numMacros = GetNumMacros()

    -- Iterate through the player's spellbook
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j = 1, numSpells do
            local spellIndex = offset + j
            local spellName, _, spellID = GetSpellBookItemName(spellIndex, BOOKTYPE_SPELL)
            if spellName and IsGroundTargeted(spellID) then
                local macroName = spellName .. " (Ground)"
                local macroBody = "#showtooltip " .. spellName .. "\n/cast [@cursor] " .. spellName

                -- Check if the macro already exists
                local macroSlot = GetMacroIndexByName(macroName)
                if macroSlot == 0 and numMacros < MAX_ACCOUNT_MACROS then
                    -- Create a new macro
                    CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroBody, 1)
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
