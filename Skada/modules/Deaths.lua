local Skada = Skada
if not Skada then return end

Skada:AddLoadableModule("Deaths", function(Skada, L)
        if Skada:IsDisabled("Deaths") then
            return
        end

        local mod = Skada:NewModule(L["Deaths"])
        local playermod = mod:NewModule(L["Player's deaths"])
        local deathlogmod = mod:NewModule(L["Death log"])

        local _UnitHealth, _UnitHealthMax = UnitHealth, UnitHealthMax
        local _UnitIsFeignDeath = UnitIsFeignDeath
        local table_insert, table_remove = table.insert, table.remove
        local table_sort, table_maxn = table.sort, table.maxn
        local _GetSpellInfo = GetSpellInfo
        local _ipairs, _format, _date = ipairs, string.format, date

        local function log_deathlog(set, data, ts)
            local player = Skada:get_player(set, data.dstGUID, data.dstName, data.dstFlags)

            if player then
                -- et player maxhp if not already set
                if player.maxhp == 0 then
                    player.maxhp = _UnitHealthMax(data.dstName)
                end

                -- create a log entry if it doesn't exist.
                if not player.deathlog[1] then
                    player.deathlog[1] = {time = 0, log = {}}
                end

                -- record our log
                local deathlog = player.deathlog[1]
                table_insert(
                    deathlog.log,
                    1,
                    {
                        spellid = data.spellid,
                        source = data.srcName,
                        amount = data.amount,
                        time = ts,
                        hp = _UnitHealth(data.dstName)
                    }
                )

                -- trim things and limit to 15
                while table_maxn(deathlog.log) > 15 do
                    table_remove(deathlog.log)
                end
            end
        end

        local data = {}

        local function SpellDamage(ts, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            local spellid,
                spellname,
                spellschool,
                amount,
                overkill,
                school,
                resisted,
                blocked,
                absorbed,
                critical,
                glancing,
                crushing = ...
            dstGUID, dstName = Skada:FixMyPets(dstGUID, dstName)

            data.srcGUID = srcGUID
            data.srcName = srcName
            data.srcFlags = srcFlags

            data.dstName = dstName
            data.dstGUID = dstGUID
            data.dstFlags = dstFlags

            data.spellid = spellid
            data.spellname = spellname

            data.amount = 0 - amount

            log_deathlog(Skada.current, data, ts)
        end

        local function SwingDamage(ts, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            local amount, overkill, spellschool, resisted, blocked, absorbed, critical, glancing, crushing = ...
            dstGUID, dstName = Skada:FixMyPets(dstGUID, dstName)

            data.srcGUID = srcGUID
            data.srcName = srcName
            data.srcFlags = srcFlags

            data.dstName = dstName
            data.dstGUID = dstGUID
            data.dstFlags = dstFlags

            data.spellid = 6603
            data.spellname = MELEE
            data.amount = 0 - amount

            log_deathlog(Skada.current, data, ts)
        end

        local function SpellHeal(ts, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            local spellid, spellname, spellschool, amount, overhealing, absorbed, critical = ...

            srcGUID, srcName = Skada:FixMyPets(srcGUID, srcName)
            dstGUID, dstName = Skada:FixMyPets(dstGUID, dstName)

            data.srcGUID = srcGUID
            data.srcName = srcName
            data.srcFlags = srcFlags

            data.dstName = dstName
            data.dstGUID = dstGUID
            data.dstFlags = dstFlags

            data.spellid = spellid
            data.spellname = spellname
            data.amount = amount

            log_deathlog(Skada.current, data, ts)
        end

        local function log_death(set, playerid, playername, ts)
            local player = Skada:get_player(set, playerid, playername)
            if player then
                set.deaths = set.deaths + 1
                player.deaths = player.deaths + 1
                if player.deathlog[1] then
                    player.deathlog[1].time = ts
                end
            end
        end

        local function UnitDied(ts, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            if not _UnitIsFeignDeath(dstName) then
                log_death(Skada.current, dstGUID, dstName, ts)
                log_death(Skada.total, dstGUID, dstName, ts)
            end
        end

        local function log_resurrect(set, playerid, playername)
            local player = Skada:get_player(set, playerid, playername)
            if player then
                table_insert(player.deathlog, 1, {time = 0, log = {}})
            end
        end

        local function SpellResurrect(ts, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            log_resurrect(Skada.current, dstGUID, dstName)
        end

        function deathlogmod:Enter(win, id, label)
            self.index = id
            self.title = _format(L["%s's death log"], label)
        end

        do
            local green = {r = 0, g = 255, b = 0, a = 1}
            local red = {r = 255, g = 0, b = 0, a = 1}

            local function sort_logs(a, b)
                return a and b and a.time > b.time
            end

            function deathlogmod:Update(win, set)
                local player = Skada:find_player(set, playermod.playerid)

                if player and self.index and player.deathlog[self.index] then
                    local deathlog = player.deathlog[self.index]

                    -- add a fake entry for the actual death
                    local nr = 1
                    local pre = win.dataset[nr] or {}
                    win.dataset[nr] = pre

                    pre.id = nr
                    pre.time = deathlog.time
                    pre.label = _date("%H:%M:%S", deathlog.time) .. ": " .. _format(L["%s dies"], player.name)
                    pre.icon = "Interface\\Icons\\Ability_Rogue_FeignDeath"
                    pre.value = 0
                    pre.valuetext = ""

                    nr = nr + 1

                    table_sort(deathlog.log, sort_logs)

                    for i, log in _ipairs(deathlog.log) do
                        local diff = tonumber(log.time) - tonumber(deathlog.time)
                        if diff > -30 then
                            local d = win.dataset[nr] or {}
                            win.dataset[nr] = d

                            local spellname, _, spellicon = _GetSpellInfo(log.spellid)

                            d.id = nr
                            d.label = _format("%2.2f: %s", diff, spellname)
                            d.icon = spellicon
                            d.spellid = log.spellid
                            d.time = log.time

                            -- used for tooltip
                            d.hp = log.hp
                            d.amount = log.amount
                            d.source = log.source
                            d.spellname = spellname

                            d.value = log.hp or 0
                            local change = (log.amount > 0 and "+" or "-") .. Skada:FormatNumber(math.abs(log.amount))
                            d.valuetext =
                                Skada:FormatValueText(
                                change,
                                self.metadata.columns.Change,
                                Skada:FormatNumber(log.hp or 0),
                                self.metadata.columns.Health,
                                _format("%02.1f%%", (log.hp or 1) / (player.maxhp or 1) * 100),
                                self.metadata.columns.Percent
                            )

                            if log.amount > 0 then
                                d.color = green
                            else
                                d.color = red
                            end

                            nr = nr + 1
                        end
                    end

                    win.metadata.maxvalue = player.maxhp
                end
            end
        end

        function playermod:Enter(win, id, label)
            self.playerid = id
            self.title = _format(L["%s's deaths"], label)
        end

        function playermod:Update(win, set)
            local player = Skada:find_player(set, self.playerid)
            local max = 0

            if player and player.deathlog then
                local nr = 1

                for i, death in _ipairs(player.deathlog) do
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    local dth = death.log[2]

                    d.id = i
                    d.time = death.time
                    d.label = dth and dth.source or UNKNOW
                    d.icon = "Interface\\Icons\\Ability_Rogue_FeignDeath"

                    d.value = dth and dth.time or death.time
                    d.valuetext = _date("%H:%M:%S", d.value)

                    if d.value > max then
                        max = d.value
                    end

                    nr = nr + 1
                end
            end

            win.metadata.maxvalue = max
        end

        function mod:Update(win, set)
            local nr, max = 1, 0

            for i, player in _ipairs(set.players) do
                if player.deaths > 0 then
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    d.id = player.id
                    d.label = player.name
                    d.class = player.class
                    d.role = player.role
                    d.spec = player.spec

                    d.value = player.deaths
                    d.valuetext = tostring(player.deaths)

                    if player.deaths > max then
                        max = player.deaths
                    end

                    nr = nr + 1
                end
            end

            win.metadata.maxvalue = max
        end

        local function entry_tooltip(win, id, label, tooltip)
            local entry = win.dataset[id]
            if entry and entry.spellname then
                tooltip:AddLine(L["Spell details"] .. " - " .. _date("%H:%M:%S", entry.time))
                tooltip:AddDoubleLine(L["Spell"], entry.spellname, 255, 255, 255, 255, 255, 255)

                if entry.source then
                    tooltip:AddDoubleLine(L["Source"], entry.source, 255, 255, 255, 255, 255, 255)
                end

                if entry.hp then
                    tooltip:AddDoubleLine(HEALTH, Skada:FormatNumber(entry.hp), 255, 255, 255, 255, 255, 255)
                end

                if entry.amount then
                    local amount = (entry.amount < 0) and (0 - entry.amount) or entry.amount
                    tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(amount), 255, 255, 255, 255, 255, 255)
                end
            end
        end

        function mod:OnEnable()
            deathlogmod.metadata = {
                ordersort = true,
                tooltip = entry_tooltip,
                columns = {Change = true, Health = true, Percent = true}
            }
            playermod.metadata = {click1 = deathlogmod}
            mod.metadata = {click1 = playermod}

            Skada:RegisterForCL(SpellDamage, "SPELL_DAMAGE", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellDamage, "SPELL_PERIODIC_DAMAGE", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellDamage, "SPELL_BUILDING_DAMAGE", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellDamage, "RANGE_DAMAGE", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SwingDamage, "SWING_DAMAGE", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellHeal, "SPELL_HEAL", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellHeal, "SPELL_PERIODIC_HEAL", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(UnitDied, "UNIT_DIED", {dst_is_interesting_nopets = true})
            Skada:RegisterForCL(SpellResurrect, "SPELL_RESURRECT", {dst_is_interesting_nopets = true})

            Skada:AddMode(self)
        end

        function mod:OnDisable()
            Skada:RemoveMode(self)
        end

        function mod:SetComplete(set)
            for i, player in _ipairs(set.players) do
                if player.deaths == 0 then
                    wipe(player.deathlog)
                    player.deathlog = nil
                end
            end
        end

        function mod:AddToTooltip(set, tooltip)
            GameTooltip:AddDoubleLine(DEATHS, set.deaths, 1, 1, 1)
        end

        function mod:GetSetSummary(set)
            return set.deaths
        end

        function mod:AddPlayerAttributes(player)
            if not player.deaths then
                player.deaths = 0
                player.maxhp = 0
                player.deathlog = {}
            end
        end

        function mod:AddSetAttributes(set)
            set.deaths = set.deaths or 0
        end
    end
)