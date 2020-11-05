local Skada=Skada
if not Skada then return end

local pairs, ipairs=pairs, ipairs
local select, format=select, string.format
local UnitGUID, UnitName, UnitClass=UnitGUID, UnitName, UnitClass
local GetSpellInfo=GetSpellInfo

Skada:AddLoadableModule("Healing", nil, function(Skada, L)
  if Skada:IsDisabled("Healing") then return end

  local mod=Skada:NewModule(L["Healing"])
  local playermod=mod:NewModule(L["Healed player list"])
  local spellmod=mod:NewModule(L["Healing spell list"])

  local function log_heal(set, data, tick)
    local player=Skada:get_player(set, data.playerid, data.playername)
    if not player then return end

    -- get rid of overhealing
    local amount=math.max(0, data.amount-data.overhealing)

    -- record the healing
    player.healing.amount=player.healing.amount+amount
    set.healing=set.healing+amount

    -- record the overhealing
    player.healing.overhealing=player.healing.overhealing+data.overhealing
    set.overhealing=set.overhealing+data.overhealing

    -- record the target
    if not player.healing.targets[data.dstName] then
      local unitclass=select(2, UnitClass(data.dstName))
      local unitrole=UnitGroupRolesAssigned(data.dstName) or "NONE"
      player.healing.targets[data.dstName]={id=data.dstGUID, class=unitclass, role=unitrole, amount=0}
    end
    player.healing.targets[data.dstName].amount=player.healing.targets[data.dstName].amount+amount

    -- record the spell
    if data.spellid then
      if not player.healing.spells[data.spellid] then
        player.healing.spells[data.spellid]={school=data.spellschool, amount=0, count=0, overhealing=0}
      end

      local spell=player.healing.spells[data.spellid]
      spell.count=spell.count+1
      spell.amount=spell.amount+amount
      spell.overhealing=spell.overhealing+data.overhealing

      if not spell.min or amount<spell.min then
        spell.min=amount
      end
      if not spell.max or amount>spell.max then
        spell.max=amount
      end

      if data.critical then
        spell.critical=(spell.critical or 0)+1
      end
    end
  end

  local heal={}

  local function SpellHeal(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, amount, overhealing, absorbed, critical=...

    if absorbed==1 and not critical then
      critical=absorbed
      absorbed=nil
    end

    heal.playerid=srcGUID
    heal.playername=srcGUID

    heal.dstGUID=dstGUID
    heal.dstName=dstName

    heal.spellid=spellid
    heal.spellname=spellname
    heal.spellschool=spellschool

    heal.amount=amount
    heal.overhealing=overhealing
    heal.absorbed=absorbed
    heal.critical=critical

    Skada:FixPets(heal)
    log_heal(Skada.current, heal)
    log_heal(Skada.total, heal)
  end

  local function getHPS(set, player)
    local totaltime=Skada:PlayerActiveTime(set, player)
    return player.healing.amount/math.max(1, totaltime)
  end

  local function spell_tooltip(win, id, label, tooltip)
    local player=Skada:find_player(win:get_selected_set(), spellmod.playerid)
    if player then
      local spell=player.healing.spells[id]
      if spell then
        tooltip:AddLine(player.name.." - "..label)
        if spell.school then
          local c=Skada.schoolcolors[spell.school]
          local n=Skada.schoolnames[spell.school]
          if c and n then
            tooltip:AddLine(L[n], c.r, c.g, c.b)
          end
        end
        tooltip:AddDoubleLine(L["Total"], spell.count, 255, 255, 255, 255, 255, 255)
        if spell.min and spell.max then
          tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.min), 255, 255, 255, 255, 255, 255)
          tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.max), 255, 255, 255, 255, 255, 255)
        end
        tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.amount/spell.count), 255, 255, 255, 255, 255, 255)
        if spell.critical then
          tooltip:AddDoubleLine(CRIT_ABBR, format("%02.1f%%", spell.critical/spell.count*100), 255, 255, 255, 255, 255, 255)
        end
        if spell.overhealing>0 then
          tooltip:AddDoubleLine(L["Overhealing"], format("%02.1f%%", spell.overhealing/(spell.overhealing+spell.amount)*100), 255, 255, 255, 255, 255, 255)
        end
      end
    end
  end

  function spellmod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's healing spells"], label)
  end

  function spellmod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local nr=1

      for spellid, spell in pairs(player.healing.spells) do
        if spell.amount>0 then
          local spellname, _, spellicon=GetSpellInfo(spellid)

          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=spellid
          d.icon=spellicon
          d.spellid=spellid
          d.label=spellname
          d.spellschool=spell.school

          d.value=spell.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(spell.amount), self.metadata.columns.Healing,
            format("%02.1f%%", spell.amount/player.healing.amount*100), self.metadata.columns.Percent
          )

          if spell.amount>max then
            max=spell.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function playermod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's healed players"], label)
  end

  function playermod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local nr=1

      for targetname, target in pairs(player.healing.targets) do
        if target.amount>0 then
          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=target.id
          d.label=targetname
          d.class=target.class
          d.role=target.role

          d.value=target.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(target.amount), self.metadata.columns.Healing,
            format("%02.1f%%", target.amount/player.healing.amount*100), self.metadata.columns.Percent
          )

          if target.amount>max then
            max=target.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:Update(win, set)
    local nr, max=1, 0

    for i, player in ipairs(set.players) do
      if player.healing.amount>0 then
        local d=win.dataset[nr] or {}
        win.dataset[nr]=d

        d.id=player.id
        d.label=player.name
        d.class=player.class
        d.role=player.role

        d.value=player.healing.amount
        d.valuetext=Skada:FormatValueText(
          Skada:FormatNumber(player.healing.amount), self.metadata.columns.Healing,
          Skada:FormatNumber(getHPS(set, player)), self.metadata.columns.HPS,
          format("%02.1f%%", player.healing.amount/set.healing*100), self.metadata.columns.Percent
        )

        if player.healing.amount>max then
          max=player.healing.amount
        end

        nr=nr+1
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:OnEnable()
    spellmod.metadata={tooltip=spell_tooltip, columns={Healing=true, Percent=true}}
    playermod.metadata={showspots=true, columns={Healing=true, Percent=true}}
    mod.metadata={showspots=true, click1=spellmod, click2=playermod, columns={Healing=true, HPS=true, Percent=true}}

    Skada:RegisterForCL(SpellHeal, "SPELL_HEAL", {src_is_interesting=true})
    Skada:RegisterForCL(SpellHeal, "SPELL_PERIODIC_HEAL", {src_is_interesting=true})

    Skada:AddMode(self, L["Absorbs and healing"])
  end

  function mod:OnDisable()
    Skada:RemoveMode(self)
  end

  function mod:GetSetSummary(set)
    return Skada:FormatNumber(set.healing)
  end

  function mod:AddPlayerAttributes(player)
    if not player.healing then
      player.healing={amount=0, overhealing=0, spells={}, targets={}}
    end
  end

  function mod:AddSetAttributes(set)
    set.healing=set.healing or 0
    set.overhealing=set.overhealing or 0
  end
end)

-- Total healing
Skada:AddLoadableModule("Total healing", nil, function(Skada, L)
  if Skada:IsDisabled("Healing", "Total healing") then return end
  local mod=Skada:NewModule(L["Total healing"])

  function mod:Update(win, set)
    local maxvalue=0
    for i, player in ipairs(set.players) do
      if player.healing.amount+player.healing.overhealing>maxvalue then
        maxvalue=player.healing.amount+player.healing.overhealing
      end
    end

    local nr, max=1, 0

    for i, player in ipairs(set.players) do
      local total=(player.healing.amount or 0)+(player.healing.overhealing or 0)
      if total>0 then
        local d=win.dataset[nr] or {}
        win.dataset[nr]=d

        d.id=player.id
        d.label=player.name
        d.class=player.class
        d.role=player.role

        d.value=player.healing.amount
        d.valuetext=Skada:FormatNumber(player.healing.amount).."/"..Skada:FormatNumber(player.healing.overhealing)

        d.color={r=0, g=1, b=0, a=1}
        d.backgroundcolor={r=1, g=0, b=0, a=1}
        d.backgroundwidth=total/maxvalue

        if total>max then
          max=total
        end

        nr=nr+1
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:OnEnable()
    mod.metadata={showspots=true}
    Skada:AddMode(self, L["Absorbs and healing"])
  end

  function mod:OnDisable()
    Skada:RemoveMode(self)
  end

  function mod:GetSetSummary(set)
    return Skada:FormatNumber(set.healing+set.overhealing)
  end
end)

-- Overhealing
Skada:AddLoadableModule("Overhealing", nil, function(Skada, L)
  if Skada:IsDisabled("Healing", "Overhealing") then return end
  local mod=Skada:NewModule(L["Overhealing"])

  function mod:Update(win, set)
    local nr, max=1, 0

    for i, player in ipairs(set.players) do
      if player.healing.overhealing>0 then
        local d=win.dataset[nr] or {}
        win.dataset[nr]=d

        d.id=player.id
        d.label=player.name
        d.class=player.class
        d.role=player.role

        d.value=player.healing.overhealing
        d.valuetext=Skada:FormatValueText(
          Skada:FormatNumber(player.healing.overhealing), self.metadata.columns.Overheal,
          format("%02.1f%%", player.healing.overhealing/set.overhealing*100), self.metadata.columns.Percent
        )

        if player.healing.overhealing>max then
          max=player.healing.overhealing
        end

        nr=nr+1
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:OnEnable()
    mod.metadata={showspots=true, columns={Overheal=true, Percent=true}}
    Skada:AddMode(self, L["Absorbs and healing"])
  end

  function mod:OnDisable()
    Skada:RemoveMode(self)
  end

  function mod:GetSetSummary(set)
    return Skada:FormatNumber(set.overhealing)
  end
end)

-- Absorbs
Skada:AddLoadableModule("Absorbs", nil, function(Skada, L)
  if Skada:IsDisabled("Absorbs") then return end

  local mod=Skada:NewModule(L["Absorbs"])
  local spellmod=mod:NewModule(L["Absorb spell list"])
  local playermod=mod:NewModule(L["Absorbed player list"])

  local absorbspells={[48707]=5,[51052]=10,[51271]=20,[77535]=10,[62606]=10,[11426]=60,[13031]=60,[13032]=60,[13033]=60,[27134]=60,[33405]=60,[43038]=60,[43039]=60,[6143]=30,[8461]=30,[8462]=30,[10177]=30,[28609]=30,[32796]=30,[43012]=30,[1463]=60,[8494]=60,[8495]=60,[10191]=60,[10192]=60,[10193]=60,[27131]=60,[43019]=60,[43020]=60,[543]=30,[8457]=30,[8458]=30,[10223]=30,[10225]=30,[27128]=30,[43010]=30,[58597]=6,[17]=30,[592]=30,[600]=30,[3747]=30,[6065]=30,[6066]=30,[10898]=30,[10899]=30,[10900]=30,[10901]=30,[25217]=30,[25218]=30,[48065]=30,[48066]=30,[47509]=12,[47511]=12,[47515]=12,[47753]=12,[54704]=12,[47788]=10,[7812]=30,[19438]=30,[19440]=30,[19441]=30,[19442]=30,[19443]=30,[27273]=30,[47985]=30,[47986]=30,[6229]=30,[11739]=30,[11740]=30,[28610]=30,[47890]=30,[47891]=30,[29674]=86400,[29719]=86400,[29701]=86400,[28538]=120,[28537]=120,[28536]=120,[28513]=120,[28512]=120,[28511]=120,[7233]=120,[7239]=120,[7242]=120,[7245]=120,[6052]=120,[53915]=120,[53914]=120,[53913]=120,[53911]=120,[53910]=120,[17548]=120,[17546]=120,[17545]=120,[17544]=120,[17543]=120,[17549]=120,[28527]=15,[29432]=3600,[36481]=4,[57350]=6,[17252]=30,[25750]=15,[25747]=15,[25746]=15,[23991]=15,[30997]=300,[31002]=300,[30999]=300,[30994]=300,[31000]=300,[23506]=20,[12561]=60,[31771]=20,[21956]=10,[29506]=20,[4057]=60,[4077]=60,[39228]=20,[27779]=30,[11657]=20,[10368]=15,[37515]=15,[42137]=86400,[26467]=30,[26470]=8,[27539]=6,[28810]=30,[54808]=12,[55019]=12,[64411]=15,[64413]=8,[40322]=30,[65874]=15,[67257]=15,[67256]=15,[67258]=15,[65858]=15,[67260]=15,[67259]=15,[67261]=15}

  local shields={}

  local function AuraApplied(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, auratype=...
    if absorbspells[spellid] then
      local shield=shields[dstName] or {}
      shields[dstName]=shield
      shield[spellid]=shield[spellid] or {}
      shield[spellid][srcName]=timestamp+absorbspells[spellid]
    end
  end

  local function AuraRemoved(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, auratype=...
    if absorbspells[spellid] then
      if shields[dstName] and shields[dstName][spellid] and shields[dstName][spellid][dstName] then
        shields[dstName][spellid][dstName]=timestamp+0.1
      end
    end
  end

  local function log_absorb(set, srcName, dstName, amount, spellid)
    local player=Skada:get_player(set, UnitGUID(srcName), srcName)
    if not player then return end

    -- add absorbs amount
    player.absorbs.amount=player.absorbs.amount+amount
    set.absorbs=set.absorbs+amount

    -- record the target
    if not player.absorbs.targets[dstName] then
      local unitclass=select(2, UnitClass(dstName))
      local unitrole=UnitGroupRolesAssigned(dstName) or "NONE"
      player.absorbs.targets[dstName]={class=unitclass, role=unitrole, amount=0}
    end
    player.absorbs.targets[dstName].amount=player.absorbs.targets[dstName].amount+amount

    -- record the spell
    if not player.absorbs.spells[spellid] then
      player.absorbs.spells[spellid]={count=0, amount=0}
    end
    local spell=player.absorbs.spells[spellid]
    spell.amount=spell.amount+amount
    spell.count=spell.count+1

    if not spell.min or amount<spell.min then
      spell.min=amount
    end

    if not spell.max or amount>spell.max then
      spell.max=amount
    end
  end

  local function process_absorb(timestamp, dstGUID, dstName, srcGUID, srcName, amount)
    local mintime, found_src, found_spellid
    -- FIXME: W221   variable 'mintime' is never set
    for shield_id, spells in pairs(shields[dstName]) do
      for shield_src, ts in pairs(spells) do
        if ts-timestamp>0 and (mintime==nil or ts-timestamp<mintime) then
          found_src=shield_src
          found_spellid=shield_id
        end
      end
    end

    if found_src then
      log_absorb(Skada.current, found_src, dstName, amount, found_spellid)
      log_absorb(Skada.total, found_src, dstName, amount, found_spellid)
    end
  end

  local preabsorb={}

  local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing=...
    if absorbed and absorbed>0 and dstName and shields[dstName] and srcName then
      process_absorb(timestamp, dstGUID, dstName, srcGUID, srcName, absorbed)
    end
  end

  local function SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, misstype, absorbed=...
    if misstype=="ABSORB" and absorbed>0 and dstName and shields[dstName] and srcName then
      process_absorb(timestamp, dstGUID, dstName, srcGUID, srcName, absorbed)
    end
  end

  local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local amount, overkill, spellschool, resisted, blocked, absorbed, critical, glancing, crushing=...
    if absorbed and absorbed>0 and dstName and shields[dstName] and srcName then
      process_absorb(timestamp, dstGUID, dstName, srcGUID, srcName, absorbed)
    end
  end

  local function SwingMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, nil, nil, nil, ...)
  end

  local function spell_tooltip(win, id, label, tooltip)
    local player=Skada:find_player(win:get_selected_set(), spellmod.playerid)
    if player then
      local spell=player.absorbs.spells[id]
      if spell then
        tooltip:AddLine(player.name.." - "..label)
        if spell.min and spell.max then
          tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.min), 255, 255, 255, 255, 255, 255)
          tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.max), 255, 255, 255, 255, 255, 255)
        end
        tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.amount/spell.count), 255, 255, 255, 255, 255, 255)
      end
    end
  end

  function spellmod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's absorb spells"], label)
  end

  function spellmod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local nr=1

      for spellid, spell in pairs(player.absorbs.spells) do
        if spell.amount>0 then
          local spellname, _, spellicon=GetSpellInfo(spellid)
          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=spellid
          d.spellid=spellid
          d.label=spellname
          d.icon=spellicon

          d.value=spell.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(spell.amount), mod.metadata.columns.Absorbs,
            format("%02.1f%%", spell.amount/player.absorbs.amount*100), mod.metadata.columns.Percent
          )

          if spell.amount>max then
            max=spell.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function playermod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's absorbed players"], label)
  end

  function playermod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local nr=1
      for targetname, target in pairs(player.absorbs.targets) do
        if target.amount>0 then
          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=targetname
          d.label=targetname
          d.class=target.class
          d.role=target.role

          d.value=target.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(target.amount), mod.metadata.columns.Absorbs,
            format("%02.1f%%", target.amount/player.absorbs.amount*100), mod.metadata.columns.Percent
          )

          if target.amount>max then
            max=target.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:Update(win, set)
    local total=(set.healing or 0)+(set.absorbs or 0)

    local nr, max=1, 0
    for i, player in ipairs(set.players) do
      if player.absorbs.amount>0 then
        local d=win.dataset[nr] or {}
        win.dataset[nr]=d

        d.id=player.id
        d.label=player.name
        d.class=player.class
        d.role=player.role
        d.value=player.absorbs.amount
        d.valuetext=Skada:FormatValueText(
          Skada:FormatNumber(player.absorbs.amount), self.metadata.columns.Absorbs,
          format("%02.1f%%", player.absorbs.amount/math.max(1, set.absorbs)*100), self.metadata.columns.Percent
        )

        if player.absorbs.amount>max then
          max=player.absorbs.amount
        end

        nr=nr+1
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:OnEnable()
    spellmod.metadata={tooltip=spell_tooltip}
    playermod.metadata={showspots=true}
    mod.metadata={showspots=true, click1=spellmod, click2=playermod, columns={Absorbs=true, Percent=true}}

    Skada:RegisterForCL(AuraApplied, "SPELL_AURA_REFRESH", {src_is_interesting_nopets=true})
    Skada:RegisterForCL(AuraApplied, "SPELL_AURA_APPLIED", {src_is_interesting_nopets=true})
    Skada:RegisterForCL(AuraRemoved, "SPELL_AURA_REMOVED", {src_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellDamage, "DAMAGE_SHIELD", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellDamage, "SPELL_DAMAGE", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellDamage, "SPELL_PERIODIC_DAMAGE", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellDamage, "SPELL_BUILDING_DAMAGE", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellDamage, "RANGE_DAMAGE", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SwingDamage, "SWING_DAMAGE", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellMissed, "SPELL_MISSED", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellMissed, "SPELL_PERIODIC_MISSED", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellMissed, "SPELL_BUILDING_MISSED", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SpellMissed, "RANGE_MISSED", {dst_is_interesting_nopets=true})
    Skada:RegisterForCL(SwingMissed, "SWING_MISSED", {dst_is_interesting_nopets=true})

    Skada:AddMode(self, L["Absorbs and healing"])
  end

  function mod:OnDisable()
    Skada:RemoveMode(self)
  end

  function mod:GetSetSummary(set)
    return Skada:FormatNumber(set.absorbs)
  end

  function mod:AddPlayerAttributes(player)
    if not player.absorbs then
      player.absorbs={amount=0, spells={}, targets={}}
    end
  end

  function mod:AddSetAttributes(set)
    set.absorbs=set.absorbs or 0
    shields={}
  end
end)

-- -- Absorbs and healing
Skada:AddLoadableModule("Absorbs and healing", nil, function(Skada, L)
  if Skada:IsDisabled("Healing", "Absorbs", "Absorbs and healing") then return end

  local mod=Skada:NewModule(L["Absorbs and healing"])
  local playermod=mod:NewModule(L["Healed and absorbed players"])
  local spellmod=mod:NewModule(L["Healing and absorbs spell list"])

  local function getHPS(set, player)
    local totaltime=Skada:PlayerActiveTime(set, player)
    return (player.healing.amount+player.absorbs.amount)/math.max(1, totaltime)
  end

  local function spell_tooltip(win, id, label, tooltip)
    local player=Skada:find_player(win:get_selected_set(), spellmod.playerid)
    if player then
      local spell=player.healing.spells[id] or player.absorbs.spells[id]
      if spell then
        tooltip:AddLine(player.name.." - "..label)
        if spell.school then
          local c=Skada.schoolcolors[spell.school]
          local n=Skada.schoolnames[spell.school]
          if c and n then
            tooltip:AddLine(L[n], c.r, c.g, c.b)
          end
        end
        tooltip:AddDoubleLine(L["Count"], spell.count, 255, 255, 255, 255, 255, 255)
        if spell.min and spell.max then
          tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.min), 255, 255, 255, 255, 255, 255)
          tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.max), 255, 255, 255, 255, 255, 255)
        end
        tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.amount/spell.count), 255, 255, 255, 255, 255, 255)
        if spell.critical then
          tooltip:AddDoubleLine(CRIT_ABBR, format("%02.1f%%", spell.critical/spell.count*100), 255, 255, 255, 255, 255, 255)
        end
        if spell.overhealing and spell.overhealing>0 then
          tooltip:AddDoubleLine(L["Overhealing"], format("%02.1f%%", spell.overhealing/(spell.overhealing+spell.amount)*100), 255, 255, 255, 255, 255, 255)
        end
      end
    end
  end

  function spellmod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's absorb and healing spells"], label)
  end

  function spellmod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local spells={}

      for spellid, spell in pairs(player.healing.spells) do
        spells[spellid]=CopyTable(spell)
      end
      for spellid, spell in pairs(player.absorbs.spells) do
        if not spells[spellid] then
          spells[spellid]=CopyTable(spell)
        else
          spells[spellid].amount=spells[spellid].amount+spell.amount
        end
      end

      local total=player.healing.amount+player.absorbs.amount
      local nr=1
      for spellid, spell in pairs(spells) do
        if spell.amount>0 then
          local spellname, _, spellicon=GetSpellInfo(spellid)

          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=spellid
          d.label=spellname
          d.icon=spellicon
          d.spellid=spellid
          d.spellschool=spell.school

          d.value=spell.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(spell.amount), self.metadata.columns.Healing,
            format("%02.1f%%", spell.amount/total*100), self.metadata.columns.Percent
          )

          if spell.amount>max then
            max=spell.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function playermod:Enter(win, id, label)
    self.playerid=id
    self.title=format(L["%s's absorbed and healed players"], label)
  end

  function playermod:Update(win, set)
    local player=Skada:find_player(set, self.playerid)
    local max=0

    if player then
      local targets={}

      for targetname, target in pairs(player.healing.targets) do
        targets[targetname]=CopyTable(target)
      end
      for targetname, target in pairs(player.absorbs.targets) do
        if not targets[targetname] then
          targets[targetname]=CopyTable(target)
        else
          targets[targetname].amount=targets[targetname].amount+target.amount
        end
      end

      local total=player.healing.amount+player.absorbs.amount
      local nr=1
      for targetname, target in pairs(targets) do
        if target.amount>0 then
          local d=win.dataset[nr] or {}
          win.dataset[nr]=d

          d.id=target.id
          d.label=targetname
          d.class=target.class
          d.role=target.role

          d.value=target.amount
          d.valuetext=Skada:FormatValueText(
            Skada:FormatNumber(target.amount), self.metadata.columns.Healing,
            format("%02.1f%%", target.amount/total*100), self.metadata.columns.Percent
          )

          if target.amount>max then
            max=target.amount
          end

          nr=nr+1
        end
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:Update(win, set)
    local nr, max=1, 0

    for i, player in ipairs(set.players) do
      local healing=player.healing.amount+player.absorbs.amount

      if healing>0 then
        local d=win.dataset[nr] or {}
        win.dataset[nr]=d

        d.id=player.id
        d.label=player.name
        d.class=player.class
        d.role=player.role

        d.value=healing
        d.valuetext=Skada:FormatValueText(
          Skada:FormatNumber(healing), self.metadata.columns.Healing,
          Skada:FormatNumber(getHPS(set, player)), self.metadata.columns.HPS,
          format("%02.1f%%", healing/(set.healing+set.absorbs)*100), self.metadata.columns.Percent
        )

        if healing>max then
          max=healing
        end

        nr=nr+1
      end
    end

    win.metadata.maxvalue=max
  end

  function mod:OnEnable()
    spellmod.metadata={tooltip=spell_tooltip, columns={Healing=true, Percent=true}}
    playermod.metadata={showspots=true, columns={Healing=true, Percent=true}}
    mod.metadata={showspots=true, click1=spellmod, click2=playermod, columns={Healing=true, HPS=true, Percent=true}}

    Skada:AddMode(self, L["Absorbs and healing"])
  end

  function mod:OnDisable()
    Skada:RemoveMode(self)
  end

  function mod:GetSetSummary(set)
    return Skada:FormatNumber(set.healing+set.absorbs)
  end
end)
