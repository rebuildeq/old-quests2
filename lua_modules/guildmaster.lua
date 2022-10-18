local guildmaster = {}

-- Continents for teleporting dialogues
continents = {}
continents["Antonica"] = 0
continents["Faydwer"] = 0
continents["Odus"] = 0
if (eq.is_the_ruins_of_kunark_enabled()) then
    continents["Kunark"] = 0 -- Kunark Only
end
if (eq.is_the_scars_of_velious_enabled()) then
    continents["Velious"] = 0 -- Velious Only
end

continentsWar = {}
continentsWar["Antonica"] = 0
continentsWar["Faydwer"] = 0
continentsWar["Odus"] = 0
if (eq.is_the_ruins_of_kunark_enabled()) then
    continentsWar["Kunark"] = 0 -- Kunark Only
end

function guildmaster.do_buffs_and_ports(e)
    local mob_class = e.self:GetClass();
    
    if (mob_class == 21) then cleric_buffs(e)
    elseif (mob_class == 25) then druid_ports_and_buffs(e)
    elseif (mob_class == 29) then shaman_buffs(e)
    elseif (mob_class == 31) then wizard_ports(e)
    elseif (mob_class == 33) then enchanter_buffs(e)
    elseif (mob_class == 20) then warrior_ports(e)
    end
end

function get_money_amount(client)
    local level = client:GetLevel();
    -- If the player is less than or equal to level 10, don't charge the player anything
    if level <= 10 then
        return 0
    end
    
    -- Otherwise, charge the player 1pp per level. 11 = 1pp, 60 = 50pp
    return (level-10)
end

function take_money(client)
    local plat = get_money_amount(client);
    local copper = 1000 * get_money_amount(client);

    local result = client:TakeMoneyFromPP(copper, true);
    if result then 
        client:Message(15, plat .. " platinum pieces have been removed from your inventory")
    end

    return result
end

function cleric_buffs(e)
    if(e.message:findi("cure")) then
        e.self:Say("Cleansing your soul.");
        e.self:CastSpell(38057,e.other:GetID(),0,1); -- Spell: Purify Soul
        return
    end
    if (e.message:findi("buffs")) then
        if (take_money(e.other) ~= true) then
            e.self:Say("I'm sorry, I cannot buff you unless you have sufficient money.")
            return
        end
        -- HP
        --  1 - Courage [202]
        --  9 - Center [219]
        --  19 - Daring [89]
        --  24 - Bravery [244]
        --  34 - Valor [312]
        --  44 - Resolution [314]
        --  52 - Heroism [1533]
        --  60 - Aegolism [1447]
        if (eq.is_the_scars_of_velious_enabled() and e.other:GetLevel() >= 60) then -- Velious only
            eq.SelfCast(1447);
        elseif e.other:GetLevel() >= 52 then
            eq.SelfCast(1533);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(314);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(312);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(244);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(89);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(219);
        else
            eq.SelfCast(202);
        end
        -- AC
        --  5 - Holy Armor [11]
        --  19 - Spirit Armor [368]
        --  29 - Guard [18]
        --  39 - Armor of Faith [19]
        --  49 - Shield of Words [20]
        --  57 - Bulwark of Faith [1537]
        if e.other:GetLevel() >= 57 then
            eq.SelfCast(1537);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(20);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(19);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(18);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(368);
        elseif e.other:GetLevel() >= 5 then
            eq.SelfCast(11);
        end
        -- Symbol
        --  14 - Symbol of Transal [485]
        --  24 - Symbol of Ryltan [486]
        --  34 - Symbol of Pinzarn [487]
        --  44 - Symbol of Naltron [488]
        --  54 - Symbol of Marzin [1535]
        if e.other:GetLevel() >= 54 then
            eq.SelfCast(1535);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(488);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(487);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(486);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(485);
        end
        -- CR
        --  14 - Endure Cold [225]
        --  39 - Resist Cold [61]
        if e.other:GetLevel() >= 39 then
            eq.SelfCast(61);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(225);
        end
        -- FR
        --  9 - Endure Fire [224]
        --  34 - Resist Fire [60]
        if e.other:GetLevel() >= 34 then
            eq.SelfCast(60);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(224);
        end
        -- DR
        --  14 - Endure Disease [226]
        --  39 - Resist Disease [63]
        if e.other:GetLevel() >= 39 then
            eq.SelfCast(63);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(226);
        end
        -- PR
        --  9 - Endure Poison [227]
        --  34 - Resist Poison [62]
        if e.other:GetLevel() >= 34 then
            eq.SelfCast(62);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(227);
        end
        -- MR
        --  19 - Endure Magic [228]
        --  44 - Resist Magic [64]
        if e.other:GetLevel() >= 44 then
            eq.SelfCast(64);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(228);
        end
    else
        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As a cleric guildmaster, for a fee of " .. plat .. " platinum pieces, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures. I can also [" .. eq.say_link("cure") .. "] you at no charge.")
        else
            e.self:Say("As a cleric guildmaster, for no fee, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures. I can also [" .. eq.say_link("cure") .. "] you at no charge.")
        end   
    end
end

function druid_ports_and_buffs(e)
    local antonica_zones = {}
    antonica_zones["Lavastorm Mountains"] = 534
    antonica_zones["Misty Thicket"] = 538
    antonica_zones["North Karana"] = 530
    antonica_zones["South Ro"] = 535
    if (eq.is_the_scars_of_velious_enabled()) then
        antonica_zones["Surefall Glade"] = 2021 -- Velious Only
    end
    antonica_zones["The Feerott"] = 536
    antonica_zones["Western Commonlands"] = 531
    local faydwer_zones = {}
    faydwer_zones["Butcherblock Mountains"] = 532
    faydwer_zones["Steamfont Mountains"] = 537
    local odus_zones = {}
    odus_zones["Toxxulia Forest"] = 533
    local kunark_zones = {} -- Kunark Only
    if (eq.is_the_ruins_of_kunark_enabled()) then
        kunark_zones["Dreadlands"] = 1326
        kunark_zones["Emerald Jungle"] = 1737
        kunark_zones["Skyfire Mountains"] = 1736
    end
    local velious_zones = {} -- Velious Only
    if (eq.is_the_scars_of_velious_enabled()) then
        velious_zones["Cobalt Scar"] = 2031
        velious_zones["Iceclad Ocean"] = 1433
        velious_zones["The Great Divide"] = 2029
        velious_zones["Wakening Lands"] = 2030
    end

    if (e.message:findi("buffs")) then
        if (take_money(e.other) ~= true) then
            e.self:Say("I'm sorry, I cannot buff you unless you have sufficient money.")
            return
        end
        -- HP Type 1
        --  1 - Skin Like Wood  [26]
        --  14 - Skin Like Rock [263]
        --  24 - Skin Like Steel [421]
        --  39 - Skin Like Diamond [422]
        --  49 - Skin Like Nature [423]
        --  57 - Natureskin [1559]
        --  60 - Protection of the Glades [1442] -- Velious Only
        if (eq.is_the_scars_of_velious_enabled() and e.other:GetLevel() >= 60) then -- Velious Only
            eq.SelfCast(1442);
        elseif e.other:GetLevel() >= 57 then
            eq.SelfCast(1559);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(423);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(422);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(421);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(263);
        else
            eq.SelfCast(26);
        end
        -- STR
        --  9 - Strength of Earth [268]
        --  34 - Strength of Stone [429]
        --  44 - Storm Strength [430]
        --  55 - Girdle of Karana [1557]
        if e.other:GetLevel() >= 55 then
            eq.SelfCast(1557);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(430);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(429);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(268);
        end
        -- Regen
        --  34 - Regeneration [144]
        --  44 - Chloroplast [145]
        --  54 - Regrowth [1568]
        if e.other:GetLevel() >= 54 then
            eq.SelfCast(1568);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(145);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(144);
        end
        -- Damage Shield
        --  9 - Shield of Thistles [256]
        --  19 - Shield of Barbs [273]
        --  29 - Shield of Brambles [129]
        --  39 - Shield of Spikes [432]
        --  49 - Shield of Thorns [356]
        --  58 - Shield of Blades [1560]
        if e.other:GetLevel() >= 58 then
            eq.SelfCast(1560);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(356);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(432);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(129);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(273);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(256);
        end
        -- SoW
        --  14 - Spirit of Wolf [278]
        if e.other:GetLevel() >= 14 then
            eq.SelfCast(278);
        -- CR
        --  9 - Endure Cold [225]
        --  34 - Resist Cold [61]
        if e.other:GetLevel() >= 34 then
            eq.SelfCast(61);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(225);
        end
        -- FR
        --  1 - Endure Fire [224]
        --  24 - Resist Fire [60]
        if e.other:GetLevel() >= 24 then
            eq.SelfCast(60);
        else
            eq.SelfCast(224);
        end
        -- DR
        --  19 - Endure Disease [226]
        --  44 - Resist Disease [63]
        if e.other:GetLevel() >= 44 then
            eq.SelfCast(63);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(226);
        end
        -- PR
        --  19 - Endure Poison [227]
        --  44 - Resist Poison [62]
        if e.other:GetLevel() >= 44 then
            eq.SelfCast(62);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(227);
        end
        -- MR
        --  34 - Endure Magic [228]
        --  49 - Resist Magic [64]
        if e.other:GetLevel() >= 49 then
            eq.SelfCast(64);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(228);
        end
    end
    elseif (e.message:findi("teleport")) then
        e.self:Say("I can teleport you to the following continents: " .. build_say_links(continents))
    elseif (e.message:findi("antonica")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(antonica_zones))
    elseif (e.message:findi("faydwer")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(faydwer_zones))
    elseif (e.message:findi("odus")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(odus_zones))
    elseif (e.message:findi("kunark")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(kunark_zones))
    elseif (e.message:findi("velious")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(velious_zones))
    else   
        local all_zones = {}
        merge_tables(all_zones, antonica_zones, faydwer_zones, odus_zones, kunark_zones, velious_zones)
        for k, v in pairs(all_zones) do 
            if (e.message:findi(k)) then
                if (take_money(e.other)) then 
                    eq.SelfCast(v);
                else
                    e.self:Say("I'm sorry, I cannot teleport you unless you have sufficient money.")
                end
                return
            end
        end

        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As a druid guildmaster, for a fee of " .. plat .. " platinum pieces, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures or [" .. eq.say_link("teleport") .. "] you somewhere else.")
        else
            e.self:Say("As a druid guildmaster, for no fee, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures or [" .. eq.say_link("teleport") .. "] you somewhere else.")
        end    
    end
end

function enchanter_buffs(e)
    if (e.message:findi("buffs")) then        
        if (take_money(e.other) ~= true) then
            e.self:Say("I'm sorry, I cannot buff you unless you have sufficient money.")
            return
        end
        -- Haste
        --  16 - Quickness [39]
        --  24 - Alacrity [170]
        --  29 - Augmentation [10]
        --  39 - Celerity [171] (skip)
        --  49 - Swift Like The Wind [172] (skip)
        --  53 - Anya's Quickening [1708] (skip)
        --  56 - Augment [1729]
        --  57 - Wonderous Rapidity [1709] (skip)
        --  60 - Visions of Grandeur [1710]
        if e.other:GetLevel() >= 60 then
            eq.SelfCast(1710);
        elseif e.other:GetLevel() >= 56 then
            eq.SelfCast(1729);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(10);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(170);
        elseif e.other:GetLevel() >= 16 then
            eq.SelfCast(39);
        end
        -- Clarity
        --  16 - Breeze [697] -- Kunark Only
        --  29 - Clarity [174]
        --  54 - Clarity II [1693]
        if e.other:GetLevel() >= 54 then
            eq.SelfCast(1693);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(174);
        elseif (e.other:GetLevel() >= 16 and eq.is_the_ruins_of_kunark_enabled()) then -- Kunark Only
            eq.SelfCast(697);
        end
        -- INT/WIS
        --  39 - Insight [175]
        --  44 - Brilliance [33]
        --  57 - Enlightenment [1688]
        if e.other:GetLevel() >= 57 then
            eq.SelfCast(1688);
        else
            if e.other:GetLevel() >= 44 then
                eq.SelfCast(33);
            end
            if e.other:GetLevel() >= 39 then
                eq.SelfCast(175);
            end
        end
        -- Mana
        --  34 - Gift of Magic [1408] -- Velious Only
        --  55 - Gift of Insight [1409] -- Velious Only
        --  60 - Gift of Brilliance [1410] -- Velious Only
        if eq.is_the_scars_of_velious_enabled() then
            if e.other:GetLevel() >= 60 then -- Velious Only
                eq.SelfCast(1410);
            elseif e.other:GetLevel() >= 55 then -- Velious Only
                eq.SelfCast(1409);
            elseif e.other:GetLevel() >= 34 then -- Velious Only
                eq.SelfCast(1408);
            end
        end
    else
        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As an enchanter guildmaster, for a fee of " .. plat .. " platinum pieces, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures.")
        else
            e.self:Say("As a enchanter guildmaster, for no fee, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures.")
        end  
    end
end

function shaman_buffs(e)
    if (e.message:findi("buffs")) then
        if (take_money(e.other) ~= true) then
            e.self:Say("I'm sorry, I cannot buff you unless you have sufficient money.")
            return
        end
        -- Talisman
        --  34 - Talisman of Tnarg [167]
        --  44 - Talisman of Altuna [168]
        --  55 - Talisman of Kragg [1585]
        if e.other:GetLevel() >= 55 then
            eq.SelfCast(1585);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(168);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(167);
        end
        -- AC
        --  5 - Scale Skin [274]
        --  14 - Turtle Skin [283]
        --  24 - Protect [649]
        --  34 - Shifting Shield [431]
        --  44 - Guardian [389]
        --  54 - Shroud of the Spirits [1584]
        if e.other:GetLevel() >= 54 then
            eq.SelfCast(1584);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(389);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(431);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(649);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(283);
        elseif e.other:GetLevel() >= 5 then
            eq.SelfCast(274);
        end
        -- STR
        --  1 - Strengthen [40]
        --  19 - Spirit Strength [147]
        --  29 - Raging Strength [151]
        --  39 - Furious Strength [153]
        --  49 - Strength [159]
        --  57 - Maniacal Strength [1593]
        if e.other:GetLevel() >= 57 then
            eq.SelfCast(1593);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(159);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(153);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(151);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(147);
        else
            eq.SelfCast(40);
        end
        -- STA
        --  9 - Spirit of Bear [279]
        --  14 - Spirit of Ox [149]
        --  34 - Health [161]
        --  44 - Stamina [158]
        --  54 - Riotous Health [1595]
        if e.other:GetLevel() >= 54 then
            eq.SelfCast(1595);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(158);
        elseif e.other:GetLevel() >= 34 then
            eq.SelfCast(161);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(149);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(279);
        end
        -- DEX
        --  1 - Dexterous Aura [266]
        --  24 - Spirit of Monkey [146]
        --  29 - Rising Dexterity [349]
        --  39 - Deftness [152]
        --  49 - Dexterity [157]
        --  58 - Mortal Deftness [1596]
        if e.other:GetLevel() >= 58 then
            eq.SelfCast(1596);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(157);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(152);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(349);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(146);
        else
            eq.SelfCast(266);
        end
        -- AGI
        --  5 - Feet like Cat [269]
        --  19 - Spirit of Cat [148]
        --  44 - Agility [154]
        --  53 - Deliriously Nimble [1594]
        if e.other:GetLevel() >= 53 then
            eq.SelfCast(1594);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(154);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(148);
        elseif e.other:GetLevel() >= 5 then
            eq.SelfCast(269);
        end
        -- CHA
        --  14 - Spirit of Snake [284]
        --  39 - Glamour [155]
        --  49 - Charisma [156]
        --  59 - Unfailing Reverence [1597]
        if e.other:GetLevel() >= 59 then
            eq.SelfCast(1597);
        elseif e.other:GetLevel() >= 49 then
            eq.SelfCast(156);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(155);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(284);
        end
        -- Haste
        --  29 - Quickness [39]
        --  44 - Alacrity [170]
        --  56 - Celerity [171]
        if e.other:GetLevel() >= 56 then
            eq.SelfCast(171);
        elseif e.other:GetLevel() >= 44 then
            eq.SelfCast(170);
        elseif e.other:GetLevel() >= 29 then
            eq.SelfCast(39);
        end
        -- Regen
        --  24 - Regeneration [144]
        --  39 - Chloroplast [145]
        --  52 - Regrowth [1568]
        if e.other:GetLevel() >= 52 then
            eq.SelfCast(1568);
        elseif e.other:GetLevel() >= 39 then
            eq.SelfCast(145);
        elseif e.other:GetLevel() >= 24 then
            eq.SelfCast(144);
        end
        -- SoW
        --  9 - Spirit of Wolf [278]
        if e.other:GetLevel() >= 9 then
            eq.SelfCast(278);
        end
        -- CR
        --  1 - Endure Cold [225]
        --  24 - Resist Cold [61]
        if e.other:GetLevel() >= 24 then
            eq.SelfCast(61);
        else
            eq.SelfCast(225);
        end
        -- FR
        --  5 - Endure Fire [224]
        --  29 - Resist Fire [60]
        if e.other:GetLevel() >= 29 then
            eq.SelfCast(60);
        elseif e.other:GetLevel() >= 5 then
            eq.SelfCast(224);
        end
        -- DR
        --  9 - Endure Disease [226]
        --  34 - Resist Disease [63]
        if e.other:GetLevel() >= 34 then
            eq.SelfCast(63);
        elseif e.other:GetLevel() >= 9 then
            eq.SelfCast(226);
        end
        -- PR
        --  14 - Endure Poison [227]
        --  39 - Resist Poison [62]
        if e.other:GetLevel() >= 39 then
            eq.SelfCast(62);
        elseif e.other:GetLevel() >= 14 then
            eq.SelfCast(227);
        end
        -- MR
        --  19 - Endure Magic [228]
        --  44 - Resist Magic [64]
        if e.other:GetLevel() >= 44 then
            eq.SelfCast(64);
        elseif e.other:GetLevel() >= 19 then
            eq.SelfCast(228);
        end
        -- HP
        --  1 - Inner Fire [267]
        --  60 - Focus of Spirit [1432] -- Velious Only
        if (e.other:GetLevel() >= 60 and eq.is_the_scars_of_velious_enabled()) then -- Velious Only
            eq.SelfCast(1432);
        else
            eq.SelfCast(267);
        end
    else
        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As a shaman guildmaster, for a fee of " .. plat .. " platinum pieces, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures.")
        else
            e.self:Say("As a shaman guildmaster, for no fee, I can provide you with [" .. eq.say_link("buffs") .. "] to assist you in your adventures.")
        end  
    end
end


function warrior_ports(e)
    local antonica_zones = {}
    antonica_zones["Grobb"] = 46
    antonica_zones["Halas"] = 30
    antonica_zones["Neriak"] = 25
    antonica_zones["Freeport"] = 9
    antonica_zones["North Qeynos"] = 2
    antonica_zones["Oggok"] = 47
    antonica_zones["Rivervale"] = 20
    antonica_zones["Surefall Glade"] = 4
    local faydwer_zones = {}
    faydwer_zones["Ak'Anon"] = 56
    faydwer_zones["Felwithe"] = 61
    faydwer_zones["Kaladim"] = 68
    faydwer_zones["Kelethin"] = 54
    local odus_zones = {}
    odus_zones["Erudin"] = 24
    odus_zones["Paineel"] = 38
    local kunark_zones = {} -- Kunark Only
    if (eq.is_the_ruins_of_kunark_enabled()) then
        kunark_zones["East Cabilis"] = 78
    end

    if (e.message:findi("teleport")) then
        e.self:Say("I can teleport you to the following continents: " .. build_say_links(continentsWar))
    elseif (e.message:findi("antonica")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(antonica_zones))
    elseif (e.message:findi("faydwer")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(faydwer_zones))
    elseif (e.message:findi("odus")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(odus_zones))
    elseif (e.message:findi("kunark")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(kunark_zones))
    else
        local all_zones = {}
        merge_tables(all_zones, antonica_zones, faydwer_zones, odus_zones, kunark_zones)
        for k, v in pairs(all_zones) do 
            if (e.message:findi(k)) then
                if (take_money(e.other)) then
                    if (v == 4) then -- SFG/qeynos hills
                        e.other:MovePC(v, -180.62, 5122.38, 37.05, 154);
                        return
                    end
                    if (v == 20) then -- rivervale/kith
                        e.other:MovePC(v, -180.62, 5122.38, 37.05, 154);
                        return
                    end
                    if (v == 47) then -- oggok/feerrott
                        e.other:MovePC(v, 733.30, 1378.85, 58.54, 147);
                        return
                    end
                    if (v == 2) then -- north qeynos
                        e.other:MovePC(v, -79.11, 423.02, 3.13, 471);
                        return
                    end
                    if (v == 9) then -- freportw
                        e.other:MovePC(v, 177.93, 371.44, -24.87, 267.25);
                        return
                    end
                    if (v == 25) then -- neriak/nektulos
                        e.other:MovePC(v, -698.41, 1743.97, 71.61, 431.50);
                        return
                    end
                    if (v == 30) then -- halas/everfrost
                        e.other:MovePC(v, 629, 3139, -60.78, 481.50);
                        return
                    end
                    if (v == 46) then -- grobb/innothule
                        e.other:MovePC(v, -649, -2232.72, -1.83, 248.50);
                        return
                    end
                    if (v == 56) then -- akanon/steamfont
                        e.other:MovePC(v, 413.01, -1448.13, -104.20, 222.50);
                        return
                    end
                    if (v == 61) then -- felwithe/gfaydark
                        e.other:MovePC(54, -2304, -2165.87, 37.98, 482.50);
                        return
                    end
                    if (v == 54) then -- kelethin/gfaydark
                        e.other:MovePC(v, 10, -20, -0.72, 418.75);
                        return
                    end
                    if (v == 68) then -- kaladim/butcher
                        e.other:MovePC(v, -525.99, 2679.97, 53, 79.25);
                        return
                    end
                    if (v == 38) then -- paineel/tox
                        e.other:MovePC(v, -433.18, -2333.35, -46.37, 161.25);
                        return
                    end
                    if (v == 24) then -- erudin/tox
                        e.other:MovePC(38, 212.18, 2290, -46.37, 508.25);
                        return
                    end
                    if (v == 78) then -- cabilis/field of bone
                        e.other:MovePC(v, 3697.83, -2341.48, 7.22, 331.25);
                        return
                    end
                    e.self:Say("I'm sorry, I failed to teleport you to your destination. Try another location")
                else
                    e.self:Say("I'm sorry, I cannot teleport you unless you have sufficient money.")
                end
                return
            end
        end
    
        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As a warrior guildmaster, for a fee of " .. plat .. " platinum pieces, I can [" .. eq.say_link("teleport") .. "] you somewhere else.")
        else
            e.self:Say("As a warrior guildmaster, for no fee, I can [" .. eq.say_link("teleport") .. "] you somewhere else.")
        end  
    end
end

function wizard_ports(e)
    local antonica_zones = {}
    antonica_zones["Cazic Thule"] = 546
    antonica_zones["Nektulos Forest"] = 545
    antonica_zones["North Ro"] = 547
    antonica_zones["Western Commonlands"] = 544
    antonica_zones["Western Karana"] = 548
    local faydwer_zones = {}
    faydwer_zones["Greater Faydark"] = 543
    local odus_zones = {}
    odus_zones["Toxxulia Forest"] = 541
    local kunark_zones = {} -- Kunark Only
    if (eq.is_the_ruins_of_kunark_enabled()) then
        kunark_zones["Dreadlands"] = 1325
        kunark_zones["Emerald Jungle"] = 1739
        kunark_zones["Skyfire Mountains"] = 1738
    end
    local velious_zones = {} -- Velious Only
    if (eq.is_the_scars_of_velious_enabled()) then
        velious_zones["Cobalt Scar"] = 2028
        velious_zones["Iceclad Ocean"] = 1417
        velious_zones["The Great Divide"] = 2026
        velious_zones["Wakening Lands"] = 2027
    end

    if(e.message:findi("bind")) then
        e.self:Say("Binding your soul. You will return here when you die.");
        e.self:CastSpell(2049,e.other:GetID(),0,1); -- Spell: Bind Affinity
        return
    end

    if (e.message:findi("teleport")) then
        e.self:Say("I can teleport you to the following continents: " .. build_say_links(continents))
    elseif (e.message:findi("antonica")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(antonica_zones))
    elseif (e.message:findi("faydwer")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(faydwer_zones))
    elseif (e.message:findi("odus")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(odus_zones))
    elseif (e.message:findi("kunark")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(kunark_zones))
    elseif (e.message:findi("velious")) then
        e.self:Say("I can teleport you to the following zones: " .. build_say_links(velious_zones))
    else
        local all_zones = {}
        merge_tables(all_zones, antonica_zones, faydwer_zones, odus_zones, kunark_zones, velious_zones)
        for k, v in pairs(all_zones) do 
            if (e.message:findi(k)) then
                if (take_money(e.other)) then 
                    eq.SelfCast(v);
                else
                    e.self:Say("I'm sorry, I cannot teleport you unless you have sufficient money.")
                end
                return
            end
        end
    
        local plat = get_money_amount(e.other);
        if plat > 0 then
            e.self:Say("As a wizard guildmaster, for a fee of " .. plat .. " platinum pieces, I can [" .. eq.say_link("teleport") .. "] you somewhere else. I can also [" .. eq.say_link("bind") .. "] you.")
        else
            e.self:Say("As a wizard guildmaster, for no fee, I can [" .. eq.say_link("teleport") .. "] you somewhere else. I can also [" .. eq.say_link("bind") .. "] you.")
        end  
    end
end

-- Helper functions
function pairs_by_keys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
    end
    return iter
end

function merge_tables (t1, ...)
    for i,v in ipairs(arg) do
        for k, v in pairs(v) do
            t1[k] = v
        end
    end
end

function build_say_links(t)
    local buff_links = ""
    for k, v in pairs_by_keys(t) do 
        buff_links = buff_links .. "[" .. eq.say_link(k) .. "] "
    end

    return buff_links
end

return guildmaster;