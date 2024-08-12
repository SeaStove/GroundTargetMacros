Utils = {}

-- Function to determine if a spell is ground-targeted
function Utils:IsGroundTargeted(spellID)
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
        [205636] = true, -- Force of Nature (Druid)
        [145205] = true, -- Efflorescence (Druid)
        [390378] = true, -- Orbital Strike (Druid, if talented)
        -- Hunter
        [1543] = true,   -- Flare (Hunter)
        [6197] = true,   -- Eagle Eye (Hunter)
        [109248] = true, -- Binding Shot (Hunter)
        [162488] = true, -- Steel Trap (Hunter)
        [206817] = true, -- Sentinel (Hunter)
        [260243] = true, -- Volley (Hunter)
        [462031] = true, -- Implosive Trap (Hunter)
        [187650] = true, -- Freezing Trap (Hunter)
        [187698] = true, -- Tar Trap (Hunter)
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
        [325153] = true, -- Exploding Keg (Monk)
        -- Paladin
        [114158] = true, -- Light's Hammer (Paladin)
        [343721] = true, -- Final Reckoning (Paladin)
        -- Priest
        [32375] = true,  -- Mass Dispel (Priest)
        [81782] = true,  -- Power Word: Barrier (Priest)
        [121536] = true, -- Angelic Feather (Priest)
        [205385] = true, -- Shadow Crash (Priest)
        [34861] = true,  -- Holy Word: Sanctify (Priest)
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
        [108287] = true, -- Totemic Projection (Shaman)
        -- Warlock
        [1122] = true,   -- Summon Infernal (Warlock)
        [5740] = true,   -- Rain of Fire (Warlock)
        [30283] = true,  -- Shadowfury (Warlock)
        [152108] = true, -- Cataclysm (Warlock)
        [278350] = true, -- Vile Taint (Warlock)
        [111771] = true, -- Demonic Gateway (Warlock)
        [386833] = true, -- Guillotine (Warlock)
        -- Warrior
        [6544] = true,   -- Heroic Leap (Warrior)
        [152277] = true, -- Ravager (Arms) (Warrior)
        [228920] = true, -- Ravager (Protection) (Warrior)
        -- Evoker
        [357210] = true, -- Deep Breath (Evoker)
        [370665] = true, -- Rescue (Evoker)
        [358385] = true, -- Landslide (Evoker)
        [368847] = true, -- Firestorm (Evoker)
    }

    return groundTargetedSpells[spellID] or false
end
