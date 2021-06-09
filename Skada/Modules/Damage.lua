assert(Skada, "Skada not found!")

local GetSpellInfo = Skada.GetSpellInfo or GetSpellInfo
local format, max = string.format, math.max
local pairs, ipairs, select = pairs, ipairs, select

-- list of miss types
local misstypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"}

-- ================== --
-- Damage Done Module --
-- ================== --

Skada:AddLoadableModule("Damage", function(Skada, L)
	if Skada:IsDisabled("Damage") then return end

	local mod = Skada:NewModule(L["Damage"])
	local playermod = mod:NewModule(L["Damage spell list"])
	local spellmod = playermod:NewModule(L["Damage spell details"])
	local targetmod = mod:NewModule(L["Damage target list"])

	local UnitGUID = UnitGUID

	local function log_damage(set, dmg, tick)
		local player = Skada:get_player(set, dmg.playerid, dmg.playername, dmg.playerflags)
		if not player then return end

		player.damagedone = player.damagedone or {}
		player.damagedone.amount = (player.damagedone.amount or 0) + dmg.amount
		set.damagedone = (set.damagedone or 0) + dmg.amount

		local spellname = dmg.spellname
		local spell = player.damagedone.spells and player.damagedone.spells[spellname]
		if not spell then
			player.damagedone.spells = player.damagedone.spells or {}
			spell = {
				id = dmg.spellid,
				school = dmg.spellschool,
				amount = 0,
				isdot = tick or nil
			}
			player.damagedone.spells[spellname] = spell
		elseif dmg.spellschool and dmg.spellschool ~= spell.school then
			spellname = spellname .. " (" .. (Skada.schoolnames[dmg.spellschool] or OTHER) .. ")"
			if not player.damagedone.spells[spellname] then
				player.damagedone.spells[spellname] = {
					id = dmg.spellid,
					school = dmg.spellschool,
					amount = 0,
					isdot = tick or nil
				}
			end
			spell = player.damagedone.spells[spellname]
		end
		spell.count = (spell.count or 0) + 1
		spell.amount = spell.amount + dmg.amount

		if spell.max == nil or dmg.amount > spell.max then
			spell.max = dmg.amount
		end

		if (spell.min == nil or dmg.amount < spell.min) and not dmg.missed then
			spell.min = dmg.amount
		end

		if dmg.critical then
			spell.critical = (spell.critical or 0) + 1
			spell.criticalamount = (spell.criticalamount or 0) + dmg.amount

			if not spell.criticalmax or dmg.amount > spell.criticalmax then
				spell.criticalmax = dmg.amount
			end

			if not spell.criticalmin or dmg.amount < spell.criticalmin then
				spell.criticalmin = dmg.amount
			end
		elseif dmg.missed ~= nil then
			spell[dmg.missed] = (spell[dmg.missed] or 0) + 1
		elseif dmg.glancing then
			spell.glancing = (spell.glancing or 0) + 1
		elseif dmg.crushing then
			spell.crushing = (spell.crushing or 0) + 1
		else
			spell.hit = (spell.hit or 0) + 1
			spell.hitamount = (spell.hitamount or 0) + dmg.amount
			if not spell.hitmax or dmg.amount > spell.hitmax then
				spell.hitmax = dmg.amount
			end
			if not spell.hitmin or dmg.amount < spell.hitmin then
				spell.hitmin = dmg.amount
			end
		end

		-- add the damage overkill
		local overkill = dmg.overkill or 0
		player.damagedone.overkill = (player.damagedone.overkill or 0) + overkill
		spell.overkill = (spell.overkill or 0) + overkill
		set.overkill = (set.overkill or 0) + overkill

		-- saving this to total set may become a memory hog deluxe.
		if set == Skada.current and dmg.dstName and dmg.amount > 0 then
			spell.targets = spell.targets or {}
			if not spell.targets[dmg.dstName] then
				spell.targets[dmg.dstName] = {amount = dmg.amount, overkill = overkill}
			else
				spell.targets[dmg.dstName].amount = spell.targets[dmg.dstName].amount + dmg.amount
				spell.targets[dmg.dstName].overkill = spell.targets[dmg.dstName].overkill + overkill
			end

			player.damagedone.targets = player.damagedone.targets or {}
			if not player.damagedone.targets[dmg.dstName] then
				player.damagedone.targets[dmg.dstName] = {amount = dmg.amount, overkill = overkill}
			else
				player.damagedone.targets[dmg.dstName].amount = player.damagedone.targets[dmg.dstName].amount + dmg.amount
				player.damagedone.targets[dmg.dstName].overkill = player.damagedone.targets[dmg.dstName].overkill + overkill
			end
		end
	end

	local dmg = {}

	local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		if srcGUID ~= dstGUID then
			local spellid, spellname, spellschool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...

			dmg.playerid = srcGUID
			dmg.playername = srcName
			dmg.playerflags = srcFlags
			dmg.dstName = dstName

			dmg.spellid = spellid
			dmg.spellname = spellname
			dmg.spellschool = spellschool
			dmg.amount = amount

			dmg.overkill = overkill
			dmg.resisted = resisted
			dmg.blocked = blocked
			dmg.absorbed = absorbed
			dmg.critical = critical
			dmg.glancing = glancing
			dmg.crushing = crushing
			dmg.missed = nil

			Skada:FixPets(dmg)

			log_damage(Skada.current, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
			log_damage(Skada.total, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
		end
	end

	local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellDamage(nil, nil, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		if srcGUID ~= dstGUID then
			local spellid, spellname, spellschool, misstype, amount = ...

			dmg.playerid = srcGUID
			dmg.playername = srcName
			dmg.playerflags = srcFlags
			dmg.dstName = dstName

			dmg.spellid = spellid
			dmg.spellname = spellname
			dmg.spellschool = spellschool

			dmg.amount = 0
			dmg.overkill = 0
			dmg.resisted = nil
			dmg.blocked = nil
			dmg.absorbed = nil
			dmg.critical = nil
			dmg.glancing = nil
			dmg.crushing = nil
			dmg.missed = misstype

			Skada:FixPets(dmg)

			log_damage(Skada.current, dmg)
			log_damage(Skada.total, dmg)
		end
	end

	local function SwingMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellMissed(nil, nil, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function getDPS(set, player)
		local amount = player.damagedone and player.damagedone.amount or 0
		return amount / max(1, Skada:PlayerActiveTime(set, player)), amount
	end
	mod.getDPS = getDPS

	local function getRaidDPS(set)
		return (set.damagedone or 0) / max(1, Skada:GetSetTime(set)), (set.damagedone or 0)
	end
	mod.getRaidDPS = getRaidDPS

	local function damage_tooltip(win, id, label, tooltip)
		local set = win:get_selected_set()
		local player = Skada:find_player(set, id)
		if player then
			local totaltime = Skada:GetSetTime(set)
			local activetime = Skada:PlayerActiveTime(set, player)
			tooltip:AddDoubleLine(L["Activity"], format("%.1f%%", 100 * activetime / totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Segment Time"], Skada:FormatTime(totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Active Time"], Skada:FormatTime(Skada:PlayerActiveTime(set, player, true)), 1, 1, 1)
		end
	end

	local function playermod_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), win.playerid)
		if player and player.damagedone then
			local spell = player.damagedone.spells and player.damagedone.spells[id]
			if spell then
				tooltip:AddLine(player.name .. " - " .. label)

				if spell.school then
					local c = Skada.schoolcolors[spell.school]
					local n = Skada.schoolnames[spell.school]
					if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
				end

				if spell.max and spell.min then
					tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.min), 1, 1, 1)
					tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.max), 1, 1, 1)
				end
				tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.amount / spell.count), 1, 1, 1)

				if (spell.overkill or 0) > 0 then
					tooltip:AddDoubleLine(L["Overkill"], Skada:FormatNumber(spell.overkill), 1, 1, 1)
				end
			end
		end
	end

	local function spellmod_tooltip(win, id, label, tooltip)
		if label == L["Critical Hits"] or label == L["Normal Hits"] or label == L.ABSORB or label == L.BLOCK or label == L.RESIST then
			local player = Skada:find_player(win:get_selected_set(), win.playerid)
			if player and player.damagedone then
				local spell = player.damagedone.spells and player.damagedone.spells[win.spellname]
				if spell then
					tooltip:AddLine(player.name .. " - " .. win.spellname)

					if spell.school then
						local c = Skada.schoolcolors[spell.school]
						local n = Skada.schoolnames[spell.school]
						if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
					end

					if label == L["Critical Hits"] and spell.criticalamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.criticalmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.criticalmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.criticalamount / spell.critical), 1, 1, 1)
					elseif label == L["Normal Hits"] and spell.hitamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.hitmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.hitmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.hitamount / spell.hit), 1, 1, 1)
					elseif label == L.ABSORB and (spell.absorbed or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.absorbed), 1, 1, 1)
					elseif label == L.BLOCK and (spell.blocked or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.blocked), 1, 1, 1)
					elseif label == L.RESIST and (spell.resisted or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.resisted), 1, 1, 1)
					end
				end
			end
		end
	end

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's damage"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = format(L["%s's damage"], player.name)
			local total = select(2, getDPS(set, player))

			if total > 0 and player.damagedone.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in pairs(player.damagedone.spells) do
					if spell.amount > 0 then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = spellname
						d.spellid = spell.id
						d.label = spellname
						if spell.isdot then
							d.text = spellname .. L["DoT"]
						end
						d.icon = select(3, GetSpellInfo(spell.id))
						d.spellschool = spell.school

						d.value = spell.amount
						d.valuetext = Skada:FormatValueText(
							Skada:FormatNumber(spell.amount),
							mod.metadata.columns.Damage,
							format("%.1f%%", 100 * spell.amount / total),
							mod.metadata.columns.Percent
						)

						if spell.amount > maxvalue then
							maxvalue = spell.amount
						end
						nr = nr + 1
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function targetmod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's targets"], label)
	end

	function targetmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = format(L["%s's targets"], player.name)
			local total = select(2, getDPS(set, player))

			if total > 0 and player.damagedone.targets then
				local maxvalue, nr = 0, 1

				for targetname, target in pairs(player.damagedone.targets) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = targetname
					d.label = targetname

					d.value = target.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(target.amount),
						mod.metadata.columns.Damage,
						format("%.1f%%", 100 * target.amount / total),
						mod.metadata.columns.Percent
					)

					if target.amount > maxvalue then
						maxvalue = target.amount
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	local function add_detail_bar(win, nr, title, value, percent)
		local d = win.dataset[nr] or {}
		win.dataset[nr] = d

		d.id = title
		d.label = title
		d.value = value
		d.valuetext = Skada:FormatValueText(
			value,
			mod.metadata.columns.Damage,
			format("%.1f%%", 100 * value / max(1, win.metadata.maxvalue)),
			percent and mod.metadata.columns.Percent
		)
		nr = nr + 1
		return nr
	end

	function spellmod:Enter(win, id, label)
		win.spellname = label
		win.title = format(L["%s's <%s> damage"], win.playername or UNKNOWN, label)
	end

	function spellmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = format(L["%s's <%s> damage"], player.name, win.spellname)

			local spell
			if player.damagedone and win.spellname then
				spell = player.damagedone.spells and player.damagedone.spells[win.spellname]
			end

			if spell then
				win.metadata.maxvalue = spell.count

				local nr = add_detail_bar(win, 1, L["Hits"], spell.count)

				if (spell.hit or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Normal Hits"], spell.hit, true)
				end

				if (spell.critical or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Critical Hits"], spell.critical, true)
				end

				if (spell.glancing or 0) > 0 then
					add_detail_bar(win, nr, L["Glancing"], spell.glancing, true)
					nr = nr + 1
				end

				if (spell.crushing or 0) > 0 then
					add_detail_bar(win, nr, L["Crushing"], spell.crushing, true)
					nr = nr + 1
				end

				for _, misstype in ipairs(misstypes) do
					if (spell[misstype] or 0) > 0 then
						nr = add_detail_bar(win, nr, L[misstype], spell[misstype], true)
					end
				end
			end
		end
	end

	function mod:Update(win, set)
		win.title = L["Damage"]
		local total = set.damagedone or 0

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in Skada:IteratePlayers(set) do
				local dps, amount = getDPS(set, player)
				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = Skada:FormatName(player.name, player.id)
					d.class = player.class or "PET"
					d.role = player.role
					d.spec = player.spec

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Damage,
						Skada:FormatNumber(dps),
						self.metadata.columns.DPS,
						format("%.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	local function feed_personal_dps()
		if Skada.current then
			local player = Skada:find_player(Skada.current, UnitGUID("player"))
			if player then
				return Skada:FormatNumber(getDPS(Skada.current, player)) .. " " .. L["DPS"]
			end
		end
	end

	local function feed_raid_dps()
		if Skada.current then
			return Skada:FormatNumber(getRaidDPS(Skada.current)) .. " " .. L["RDPS"]
		end
	end

	function mod:OnEnable()
		spellmod.metadata = {tooltip = spellmod_tooltip}
		playermod.metadata = {post_tooltip = playermod_tooltip, click1 = spellmod}
		targetmod.metadata = {}
		self.metadata = {
			showspots = true,
			post_tooltip = damage_tooltip,
			click1 = playermod,
			click2 = targetmod,
			nototalclick = {targetmod},
			columns = {Damage = true, DPS = true, Percent = true},
			icon = "Interface\\Icons\\spell_fire_firebolt"
		}

		Skada:RegisterForCL(SpellDamage, "DAMAGE_SHIELD", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "DAMAGE_SPLIT", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "RANGE_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_BUILDING_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_EXTRA_ATTACKS", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_PERIODIC_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SwingDamage, "SWING_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})

		Skada:RegisterForCL(SpellMissed, "DAMAGE_SHIELD_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "RANGE_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_BUILDING_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_PERIODIC_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SwingMissed, "SWING_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})

		Skada:AddFeed(L["Damage: Personal DPS"], feed_personal_dps)
		Skada:AddFeed(L["Damage: Raid DPS"], feed_raid_dps)

		Skada:AddMode(self, L["Damage Done"])
	end

	function mod:OnDisable()
		Skada:RemoveFeed(L["Damage: Personal DPS"])
		Skada:RemoveFeed(L["Damage: Raid DPS"])
		Skada:RemoveMode(self)
	end

	function mod:AddToTooltip(set, tooltip)
		local dps, amount = getRaidDPS(set)
		tooltip:AddDoubleLine(L["Damage"], Skada:FormatNumber(amount), 1, 1, 1)
		tooltip:AddDoubleLine(L["DPS"], Skada:FormatNumber(dps), 1, 1, 1)
	end

	function mod:GetSetSummary(set)
		local dps, amount = getRaidDPS(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(amount),
			self.metadata.columns.Damage,
			Skada:FormatNumber(dps),
			self.metadata.columns.DPS
		)
	end

	function mod:SetComplete(set)
		for _, player in Skada:IteratePlayers(set) do
			if player.damagedone and player.damagedone.amount == 0 then
				player.damagedone.spells = nil
				player.damagedone.targets = nil
			end
		end
	end
end)

-- ============================= --
-- Damage done per second module --
-- ============================= --

Skada:AddLoadableModule("DPS", function(Skada, L)
	if Skada:IsDisabled("Damage", "DPS") then return end

	local parentmod = Skada:GetModule(L["Damage"], true)
	if not parentmod then return end

	local mod = Skada:NewModule(L["DPS"])
	local getDPS = parentmod.getDPS
	local getRaidDPS = parentmod.getRaidDPS

	local function dps_tooltip(win, id, label, tooltip)
		local set = win:get_selected_set()
		local player = Skada:find_player(set, id)
		if player then
			local totaltime = Skada:GetSetTime(set)
			local activetime = Skada:PlayerActiveTime(set, player)
			local dps, amount = getDPS(set, player)
			tooltip:AddLine(player.name .. " - " .. L["DPS"])
			tooltip:AddDoubleLine(L["Segment Time"], Skada:FormatTime(totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Active Time"], Skada:FormatTime(Skada:PlayerActiveTime(set, player, true)), 1, 1, 1)
			tooltip:AddDoubleLine(L["Damage Done"], Skada:FormatNumber(player.damagedone.amount), 1, 1, 1)
			tooltip:AddDoubleLine(Skada:FormatNumber(amount) .. "/" .. Skada:FormatTime(activetime), Skada:FormatNumber(dps), 1, 1, 1)
		end
	end

	function mod:Update(win, set)
		win.title = L["DPS"]
		local total = getRaidDPS(set)

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in Skada:IteratePlayers(set) do
				local amount = getDPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = Skada:FormatName(player.name, player.id)
					d.class = player.class or "PET"
					d.role = player.role
					d.spec = player.spec

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.DPS,
						format("%.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		self.metadata = {
			showspots = true,
			tooltip = dps_tooltip,
			click1 = parentmod.metadata.click1,
			click2 = parentmod.metadata.click2,
			nototalclick = {parentmod.metadata.click2},
			columns = {DPS = true, Percent = true},
			icon = "Interface\\Icons\\inv_misc_pocketwatch_01"
		}

		Skada:AddMode(self, L["Damage Done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self, L["Damage Done"])
	end

	function mod:GetSetSummary(set)
		return Skada:FormatNumber(getRaidDPS(set))
	end
end)

-- =========================== --
-- Damage Done By Spell Module --
-- =========================== --

Skada:AddLoadableModule("Damage Done By Spell", function(Skada, L)
	if Skada:IsDisabled("Damage", "Damage Done By Spell") then return end

	local mod = Skada:NewModule(L["Damage Done By Spell"])
	local sourcemod = mod:NewModule(L["Damage spell sources"])

	local cached = {}

	function sourcemod:Enter(win, id, label)
		win.spellname = label
		win.title = format(L["%s's sources"], label)
	end

	function sourcemod:Update(win, set)
		win.title = format(L["%s's sources"], win.spellname or UNKNOWN)

		if win.spellname and cached[win.spellname] then
			local total = cached[win.spellname].amount or 0

			if total > 0 then
				local maxvalue, nr = 0, 1

				for playername, player in pairs(cached[win.spellname].players) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = playername
					d.class = player.class or "PET"
					d.role = player.role
					d.spec = player.spec

					d.value = player.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(player.amount),
						mod.metadata.columns.Damage,
						format("%.1f%%", 100 * player.amount / total),
						mod.metadata.columns.Percent
					)

					if player.amount > maxvalue then
						maxvalue = player.amount
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	-- for performance purposes, we ignore total segment
	function mod:Update(win, set)
		win.title = L["Damage Done By Spell"]

		if win.selectedset ~= "total" then
			local total = set.damagedone or 0
			if total == 0 then
				return
			end

			cached = wipe(cached or {})

			for _, player in Skada:IteratePlayers(set) do
				if player.damagedone and player.damagedone.spells then
					for spellname, spell in pairs(player.damagedone.spells) do
						if spell.amount > 0 then
							if not cached[spellname] then
								cached[spellname] = {
									id = spell.id,
									school = spell.school,
									amount = spell.amount,
									isdot = spell.isdot,
									players = {}
								}
							else
								cached[spellname].amount = cached[spellname].amount + spell.amount
							end

							if not cached[spellname].players[player.name] then
								cached[spellname].players[player.name] = {
									id = player.id,
									class = player.class,
									role = player.role,
									spec = player.spec,
									amount = spell.amount
								}
							else
								cached[spellname].players[player.name].amount =
									cached[spellname].players[player.name].amount + spell.amount
							end
						end
					end
				end
			end

			local maxvalue, nr = 0, 1

			for spellname, spell in pairs(cached) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = spellname
				d.spellid = spell.id
				d.label = spellname
				if spell.isdot then
					d.text = spellname .. L["DoT"]
				end
				d.icon = select(3, GetSpellInfo(spell.id))
				d.spellschool = spell.school

				d.value = spell.amount
				d.valuetext = Skada:FormatValueText(
					Skada:FormatNumber(spell.amount),
					self.metadata.columns.Damage,
					format("%.1f%%", 100 * spell.amount / total),
					self.metadata.columns.Percent
				)

				if spell.amount > maxvalue then
					maxvalue = spell.amount
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		sourcemod.metadata = {showspots = true}
		self.metadata = {
			showspots = true,
			click1 = sourcemod,
			columns = {Damage = true, Percent = true},
			icon = "Interface\\Icons\\spell_nature_lightning"
		}
		Skada:AddMode(self, L["Damage Done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end
end)

-- ==================== --
-- Useful Damage Module --
-- ==================== --
--
-- this module uses the data from Damage module and
-- show the "effective" damage and dps by substructing
-- the overkill from the amount of damage done.
--

Skada:AddLoadableModule("Useful Damage", function(Skada, L)
	if Skada:IsDisabled("Damage", "Useful Damage") then return end

	local mod = Skada:NewModule(L["Useful Damage"])
	local playermod = mod:NewModule(L["Damage spell list"])
	local targetmod = mod:NewModule(L["Damage target list"])
	local detailmod = targetmod:NewModule(L["More Details"])

	local function getDPS(set, player)
		local amount = player.damagedone and (player.damagedone.amount - (player.damagedone.overkill or 0)) or 0
		return amount / max(1, Skada:PlayerActiveTime(set, player)), amount
	end

	local function getRaidDPS(set)
		local amount = (set.damagedone or 0) - (set.overkill or 0)
		return amount / max(1, Skada:GetSetTime(set)), amount
	end

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's damage"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = format(L["%s's damage"], player.name)
			local total = select(2, getDPS(set, player))

			if total > 0 and player.damagedone.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in pairs(player.damagedone.spells) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = spellname
					d.spellid = spell.id
					d.label = spellname
					if spell.isdot then
						d.text = spellname .. L["DoT"]
					end
					d.icon = select(3, GetSpellInfo(spell.id))
					d.spellschool = spell.school

					d.value = max(0, (spell.amount or 0) - (spell.overkill or 0))
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(d.value),
						mod.metadata.columns.Damage,
						format("%.1f%%", 100 * d.value / total),
						mod.metadata.columns.Percent
					)

					if d.value > maxvalue then
						maxvalue = d.value
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function targetmod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's targets"], label)
	end

	function targetmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = format(L["%s's targets"], player.name)
			local total = select(2, getDPS(set, player))

			if total > 0 and player.damagedone.targets then
				local maxvalue, nr = 0, 1

				for targetname, target in pairs(player.damagedone.targets) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = targetname
					d.label = targetname

					d.value = max(0, (target.amount or 0) - (target.overkill or 0))
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(d.value),
						mod.metadata.columns.Damage,
						format("%.1f%%", 100 * d.value / total),
						mod.metadata.columns.Percent
					)

					if d.value > maxvalue then
						maxvalue = d.value
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function detailmod:Enter(win, id, label, tooltip)
		win.targetname = label
		win.title = format(L["Useful damage on %s"], label)
	end

	function detailmod:Update(win, set)
		win.title = format(L["Useful damage on %s"], win.targetname or UNKNOWN)

		local total, players = 0, {}

		for _, player in Skada:IteratePlayers(set) do
			if player.damagedone and player.damagedone.targets and player.damagedone.targets[win.targetname] then
				local amount = max(0, player.damagedone.targets[win.targetname].amount - player.damagedone.targets[win.targetname].overkill)
				total = total + amount
				players[player.name] = {
					id = player.id,
					class = player.class,
					role = player.role,
					spec = player.spec,
					amount = amount
				}
			end
		end

		if total > 0 then
			local maxvalue, nr = 0, 1

			for playername, player in pairs(players) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = player.id
				d.label = Skada:FormatName(playername)
				d.class = player.class or "PET"
				d.role = player.role
				d.spec = player.spec

				d.value = player.amount
				d.valuetext = Skada:FormatValueText(
					Skada:FormatNumber(player.amount),
					mod.metadata.columns.Damage,
					format("%.1f%%", 100 * player.amount / total),
					mod.metadata.columns.Percent
				)

				if player.amount > maxvalue then
					maxvalue = player.amount
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:Update(win, set)
		win.title = L["Useful Damage"]
		local total = select(2, getRaidDPS(set))

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in Skada:IteratePlayers(set) do
				local dps, amount = getDPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = Skada:FormatName(player.name, player.id)
					d.class = player.class or "PET"
					d.role = player.role
					d.spec = player.spec

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Damage,
						Skada:FormatNumber(dps),
						self.metadata.columns.DPS,
						format("%.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		detailmod.metadata = {showspots = true}
		targetmod.metadata = {click1 = detailmod}
		self.metadata = {
			showspots = true,
			click1 = playermod,
			click2 = targetmod,
			nototalclick = {targetmod},
			columns = {Damage = true, DPS = true, Percent = true},
			icon = "Interface\\Icons\\spell_fire_fireball02"
		}
		Skada:AddMode(self, L["Damage Done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function mod:GetSetSummary(set)
		local dps, amount = getRaidDPS(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(amount),
			self.metadata.columns.Damage,
			Skada:FormatNumber(dps),
			self.metadata.columns.DPS
		)
	end
end)

-- ============== --
-- Overkill Module --
-- ============== --

Skada:AddLoadableModule("Overkill", function(Skada, L)
	if Skada:IsDisabled("Damage", "Overkill") then return end

	local mod = Skada:NewModule(L["Overkill"])
	local playermod = mod:NewModule(L["Overkill spell list"])
	local targetmod = mod:NewModule(L["Overkill target list"])

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's overkill spells"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = format(L["%s's overkill spells"], player.name)
			local total = player.damagedone and player.damagedone.overkill or 0

			if total > 0 and player.damagedone.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in pairs(player.damagedone.spells) do
					if (spell.overkill or 0) > 0 then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = spellname
						d.spellid = spell.id
						d.label = spellname
						if spell.isdot then
							d.text = spellname .. L["DoT"]
						end
						d.icon = select(3, GetSpellInfo(spell.id))
						d.spellschool = spell.school

						d.value = spell.overkill
						d.valuetext = Skada:FormatValueText(
							Skada:FormatNumber(spell.overkill),
							mod.metadata.columns.Damage,
							format("%.1f%%", 100 * spell.overkill / total),
							mod.metadata.columns.Percent
						)

						if spell.overkill > maxvalue then
							maxvalue = spell.overkill
						end
						nr = nr + 1
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function targetmod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = format(L["%s's overkill targets"], label)
	end

	function targetmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = format(L["%s's overkill targets"], player.name)
			local total = player.damagedone and player.damagedone.overkill or 0

			if total > 0 and player.damagedone.targets then
				local maxvalue, nr = 0, 1

				for targetname, target in pairs(player.damagedone.targets) do
					if (target.overkill or 0) > 0 then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = targetname
						d.label = targetname

						d.value = target.overkill
						d.valuetext = Skada:FormatValueText(
							Skada:FormatNumber(target.overkill),
							mod.metadata.columns.Damage,
							format("%.1f%%", 100 * target.overkill / total),
							mod.metadata.columns.Percent
						)

						if target.overkill > maxvalue then
							maxvalue = target.overkill
						end
						nr = nr + 1
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function mod:Update(win, set)
		win.title = L["Overkill"]
		local total = set.overkill or 0

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in Skada:IteratePlayers(set) do
				if player.damagedone and (player.damagedone.overkill or 0) > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = Skada:FormatName(player.name, player.id)
					d.class = player.class or "PET"
					d.role = player.role
					d.spec = player.spec

					d.value = player.damagedone.overkill
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(d.value),
						self.metadata.columns.Damage,
						format("%.1f%%", 100 * d.value / total),
						self.metadata.columns.Percent
					)

					if d.value > maxvalue then
						maxvalue = d.value
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		self.metadata = {
			showspots = true,
			click1 = playermod,
			click2 = targetmod,
			nototalclick = {targetmod},
			columns = {Damage = true, Percent = true},
			icon = "Interface\\Icons\\spell_fire_incinerate"
		}
		Skada:AddMode(self, L["Damage Done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self, L["Damage Done"])
	end
end)