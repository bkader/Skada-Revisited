local L = LibStub("AceLocale-3.0"):NewLocale("Skada", "zhTW", false)
if not L then return end

-- L["A damage meter."]=true
-- L["Memory usage is high. You may want to reset Skada, and enable one of the automatic reset options."]=true

-- L["Skada: Modes"]=true
-- L["Skada: Fights"]=true

-- L["Error: No options selected"]=true

-- L["Profiles"]=true
-- L["Enable"]=true
-- L["Disable"]=true

-- -- common lines
-- L["Active Time"]=true
-- L["Segment Time"]=true
-- L["Click for"]=true
-- L["Shift-Click for"]=true
-- L["Control-Click for"]=true
-- L["Minimum hit:"]=true
-- L["Maximum hit:"]=true
-- L["Average hit:"]=true
-- L["Total hits:"]=true
-- L["Percent"]=true

-- L["General options"]=true

-- -- windows section:
-- L["Window"]=true
-- L["Windows"]=true

-- L["Create window"]=true
-- L["Enter the name for the new window."]=true

-- L["Delete window"]=true
-- L["Choose the window to be deleted."]=true

-- L["Deletes the chosen window."]=true

-- L["Rename window"]=true
-- L["Enter the name for the window."]=true
-- L["Lock window"]=true
-- L["Locks the bar window in place."]=true
-- L["Hide window"]=true
-- L["Hides the window."]=true
-- L["Display system"]=true
-- L["Choose the system to be used for displaying data in this window."]=true

-- -- bars
-- L["Bars"]=true
-- L["Bar font"]=true
-- L["The font used by all bars."]=true
-- L["Bar font size"]=true
-- L["The font size of all bars."]=true
-- L["Font flags"]=true
-- L["Sets the font flags."]=true
-- L["None"]=true
-- L["Outline"]=true
-- L["Thick outline"]=true
-- L["Monochrome"]=true
-- L["Outlined monochrome"]=true
-- L["Bar texture"]=true
-- L["The texture used by all bars."]=true
-- L["Bar spacing"]=true
-- L["Distance between bars."]=true
-- L["Bar height"]=true
-- L["The height of the bars."]=true
-- L["Bar width"]=true
-- L["The width of the bars."]=true
-- L["Bar orientation"]=true
-- L["The direction the bars are drawn in."]=true
-- L["Left to right"]=true
-- L["Right to left"]=true
-- L["Reverse bar growth"]=true
-- L["Bars will grow up instead of down."]=true
-- L["Bar color"]=true
-- L["Choose the default color of the bars."]=true
-- L["Background color"]=true
-- L["Choose the background color of the bars."]=true
-- L["Class color bars"]=true
-- L["When possible, bars will be colored according to player class."]=true
-- L["Class color text"]=true
-- L["When possible, bar text will be colored according to player class."]=true
-- L["Class icons"]=true
-- L["Use class icons where applicable."]=true
-- L["Role icons"]=true
-- L["Use role icons where applicable."]=true
-- L["Clickthrough"]=true
-- L["Disables mouse clicks on bars."]=true
-- L["Smooth bars"]=true
-- L["Animate bar changes smoothly rather than immediately."]=true

-- -- title bar
-- L["Title bar"]=true
-- L["Enables the title bar."]=true
-- L["Include set"]=true
-- L["Include set name in title bar"]=true
-- L["Title height"]=true
-- L["The height of the title frame."]=true
-- L["Title font size"]=true
-- L["The font size of the title bar."]=true
-- L["Title color"]=true
-- L["The text color of the title."]=true
-- L["The texture used as the background of the title."]=true
-- L["The background color of the title."]=true
-- L["Border texture"]=true
-- L["The texture used for the borders."]=true
-- L["The texture used for the border of the title."]=true
-- L["Border color"]=true
-- L["The color used for the border."]=true
-- L["Buttons"]=true

-- -- general window
-- L["Background"]=true
-- L["Background texture"]=true
-- L["The texture used as the background."]=true
-- L["Tile"]=true
-- L["Tile the background texture."]=true
-- L["Tile size"]=true
-- L["The size of the texture pattern."]=true
-- L["Background color"]=true
-- L["The color of the background."]=true
-- L["Border"]=true
-- L["Border thickness"]=true
-- L["The thickness of the borders."]=true
-- L["General"]=true
-- L["Scale"]=true
-- L["Sets the scale of the window."]=true
-- L["Strata"]=true
-- L["This determines what other frames will be in front of the frame."]=true
-- L["Width"]=true
-- L["Height"]=true

-- -- switching
-- L["Mode switching"]=true
-- L["Combat mode"]=true
-- L["Automatically switch to set 'Current' and this mode when entering combat."]=true
-- L["Return after combat"]=true
-- L["Return to the previous set and mode after combat ends."]=true
-- L["Wipe mode"]=true
-- L["Automatically switch to set 'Current' and this mode after a wipe."]=true
-- L["None"]=true

-- L["Inline bar display"]=true
-- L["Inline display is a horizontal window style."]=true
-- L["Fixed bar width"]=true
-- L["If checked, bar width is fixed. Otherwise, bar width depends on the text width."]=true

-- -- data resets
-- L["Data resets"]=true
-- L["Reset on entering instance"]=true
-- L["Controls if data is reset when you enter an instance."]=true
-- L["Reset on joining a group"]=true
-- L["Controls if data is reset when you join a group."]=true
-- L["Reset on leaving a group"]=true
-- L["Controls if data is reset when you leave a group."]=true
-- L["Ask"]=true
-- L["Do you want to reset Skada?"]=true
-- L["All data has been reset."]=true

-- -- general options
-- L["Show minimap button"]=true
-- L["Toggles showing the minimap button."]=true
-- L["Merge pets"]=true
-- L["Merges pets with their owners. Changing this only affects new data."]=true
-- L["Show totals"]=true
-- L["Shows a extra row with a summary in certain modes."]=true
-- L["Only keep boss fighs"]=true
-- L["Boss fights will be kept with this on, and non-boss fights are discarded."]=true
-- L["Hide when solo"]=true
-- L["Hides Skada's window when not in a party or raid."]=true
-- L["Hide in PvP"]=true
-- L["Hides Skada's window when in Battlegrounds/Arenas."]=true
-- L["Hide in combat"]=true
-- L["Hides Skada's window when in combat."]=true
-- L["Disable while hidden"]=true
-- L["Skada will not collect any data when automatically hidden."]=true
-- L["Sort modes by usage"]=true
-- L["The mode list will be sorted to reflect usage instead of alphabetically."]=true
-- L["Show rank numbers"]=true
-- L["Shows numbers for relative ranks for modes where it is applicable."]=true
-- L["Aggressive combat detection"]=true
-- L["Skada usually uses a very conservative (simple) combat detection scheme that works best in raids. With this option Skada attempts to emulate other damage meters. Useful for running dungeons. Meaningless on boss encounters."]=true
-- L["Autostop"]=true
-- L["Automatically stops the current segment after half of all raid members have died."]=true
-- L["Always show self"]=true
-- L["Keeps the player shown last even if there is not enough space."]=true
-- L["Number format"]=true
-- L["Controls the way large numbers are displayed."]=true
-- L["Condensed"]=true
-- L["Detailed"]=true
-- L["Data feed"]=true
-- L["Choose which data feed to show in the DataBroker view. This requires an LDB display addon, such as Titan Panel."]=true
-- L["Number set duplicates"]=true
-- L["Append a count to set names with duplicate mob names."]=true
-- L["Set format"]=true
-- L["Controls the way set names are displayed."]=true
-- L["Data segments to keep"]=true
-- L["The number of fight segments to keep. Persistent segments are not included in this."]=true
-- L["Update frequency"]=true
-- L["How often windows are updated. Shorter for faster updates. Increases CPU usage."]=true

-- -- columns
-- L["Columns"]=true

-- -- tooltips
-- L["Tooltips"]=true
-- L["Show tooltips"]=true
-- L["Shows tooltips with extra information in some modes."]=true
-- L["Informative tooltips"]=true
-- L["Shows subview summaries in the tooltips."]=true
-- L["Subview rows"]=true
-- L["The number of rows from each subview to show when using informative tooltips."]=true
-- L["Tooltip position"]=true
-- L["Position of the tooltips."]=true
-- L["Default"]=true
-- L["Top right"]=true
-- L["Top left"]=true
-- L["Smart"]=true

-- -- disabled modules
-- L["Disabled Modules"]=true
-- L["Tick the modules you want to disable."]=true
-- L["This change requires a UI reload. Are you sure?"]=true
-- L["Adds a set of standard themes to Skada. Custom themes can also be used."]=true

-- -- themes module
-- L["Theme"]=true
-- L["Themes"]=true
-- L["Apply theme"]=true
-- L["Theme applied!"]=true
-- L["Name of your new theme."]=true
-- L["Save theme"]=true
-- L["Delete theme"]=true

-- -- scroll module
-- L["Scroll"]=true
-- L["Mouse"]=true
-- L["Scrolling speed"]=true
-- L["Scroll icon"]=true
-- L["Scroll mouse button"]=true
-- L["Keybinding"]=true
-- L["Key scrolling speed"]=true

-- -- minimap button
-- L["Skada summary"]=true
-- L["Hint: Left-Click to toggle Skada window."]=true
-- L["Shift+Left-Click to reset."]=true
-- L["Right-click to open menu"]=true

-- -- skada menu
-- L["Skada Menu"]=true
-- L["Delete segment"]=true
-- L["Keep segment"]=true
-- L["Toggle window"]=true
-- L["Start new segment"]=true

-- -- window buttons
-- L["Configure"]=true
-- L["opens the configuration window"]=true
-- L["Reset"]=true
-- L["resets all data"]=true
-- L["Segment"]=true
-- L["Mode"]=true
-- L["Report"]=true

-- -- default segments
-- L["Total"]=true
-- L["Current"]="Current fight"

-- -- report module and window
-- L["Skada: %s for %s:"]=true
-- L["Channel"]=true
-- L["Self"]=true
-- L["Party"]=true
-- L["Whisper"]=true
-- L["Say"]=true
-- L["Whisper Target"]=true
-- L["Raid"]=true
-- L["Guild"]=true
-- L["Officer"]=true
-- L["Lines"]=true
-- L["There is nothing to report."]=true
-- L["No mode or segment selected for report."]=true

-- -- ================== --
-- -- Bar Display Module --
-- -- ================== --

-- L["Bar display"]=true
-- L["Bar display is the normal bar window used by most damage meters. It can be extensively styled."]=true

-- -- ============= --
-- -- Threat Module --
-- -- ============= --
-- L["Threat"]=true
-- L["Threat warning"]=true
-- L["Do not warn while tanking"]=true
-- L["Flash screen"]=true
-- L["This will cause the screen to flash as a threat warning."]=true
-- L["Shake screen"]=true
-- L["This will cause the screen to shake as a threat warning."]=true
-- L["Play sound"]=true
-- L["This will play a sound as a threat warning."]=true
-- L["Threat sound"]=true
-- L["The sound that will be played when your threat percentage reaches a certain point."]=true
-- L["Threat threshold"]=true
-- L["When your threat reaches this level, relative to tank, warnings are shown."]=true
-- L["Show raw threat"]=true
-- L["Shows raw threat percentage relative to tank instead of modified for range."]=true
-- L["Use focus target"]=true
-- L["Shows threat on focus target, or focus target's target, when available."]=true
-- L["TPS"]=true
-- L["Threat: Personal Threat"]=true

-- -- ======================== --
-- -- Absorbs & Healing Module --
-- -- ======================== --
-- L["Absorbs and healing"]=true
-- L["Healing and absorbs spell list"]=true
-- L["Healed and absorbed players"]=true
-- L["%s's absorbs and healing"]=true
-- L["Healed by %s"]=true

-- L["Healing"]=true
-- L["Healing spell list"]=true
-- L["Healed players"]=true

-- L["%s's healing"]=true

-- L["HPS"]=true

-- L["Total healing"]=true

-- L["Overhealing"]=true
-- L["Overheal"]=true

-- L["Absorbs"]=true
-- L["Absorb details"]=true
-- L["%s's absorbed players"]=true

-- L["Critical"]=true

-- -- ============ --
-- -- Auras Module --
-- -- ============ --

-- L["Auras"]=true
-- L["Buff and debuff"]=true
-- L["Auras: Buff uptime"]=true
-- L["Auras: Debuff uptime"]=true
-- L["Auras: Sunders Counter"]=true
-- L["Auras spell list"]=true
-- L["Auras target list"]=true
-- L["Buff Uptime"]=true
-- L["Debuff Uptime"]=true
-- L["%s's buff uptime"]=true
-- L["%s's debuff uptime"]=true
-- L["%s's debuff targets"]=true
-- L["%s's <%s> targets"]=true
-- L["Refreshes"]=true

-- -- ================= --
-- -- CC Tracker Module --
-- -- ================= --

-- L["CC Tracker"]=true

-- -- CC Done:
-- L["CC Done"]=true
-- L["CC Done spells"]=true
-- L["CC Done spell targets"]=true
-- L["CC Done targets"]=true
-- L["CC Done target spells"]=true
-- L["%s's CC Done <%s> targets"]=true
-- L["%s's CC Done <%s> spells"]=true
-- L["%s's CC Done spells"]=true
-- L["%s's CC Done targets"]=true

-- -- CC Taken
-- L["CC Taken"]=true
-- L["CC Taken spells"]=true
-- L["CC Taken spell sources"]=true
-- L["CC Taken sources"]=true
-- L["CC Taken source spells"]=true
-- L["%s's CC Taken <%s> sources"]=true
-- L["%s's CC Taken <%s> spells"]=true
-- L["%s's CC Taken spells"]=true
-- L["%s's CC Taken sources"]=true

-- L["CC Breaks"]=true
-- L["CC Breakers"]=true
-- L["CC Break spells"]=true
-- L["CC Break spell targets"]=true
-- L["CC Break targets"]=true
-- L["CC Break target spells"]=true
-- L["%s's CC Break <%s> spells"]=true
-- L["%s's CC Break <%s> targets"]=true
-- L["%s's CC Break spells"]=true
-- L["%s's CC Break targets"]=true

-- -- options
-- L["CC"]=true
-- L["Announce CC breaking to party"]=true
-- L["Ignore Main Tanks"]=true
-- L["%s on %s removed by %s"]= true
-- L["%s on %s removed by %s's %s"]= true


-- -- ============= --
-- -- Damage Module --
-- -- ============= --

-- -- damage done module
-- L["Damage"]=true
-- L["Damage spell list"]=true
-- L["Damage spell details"]=true
-- L["Damage spell targets"]=true
-- L["Damage done"]=true
-- L["%s's damage"]=true

-- L["Damage done by spell"]=true
-- L["%s's sources"]=true

-- L["DPS"]=true
-- L["Damage: Personal DPS"]=true

-- L["RDPS"]=true
-- L["Damage: Raid DPS"]=true

-- -- damage taken module
-- L["Damage taken"]=true
-- L["%s's damage taken"]=true
-- L["Damage spell sources"]=true
-- L["Damage taken by spell"]=true
-- L["%s's targets"]=true
-- L["DTPS"]=true

-- -- enemy damage done module
-- L["Enemy damage done"]=true
-- L["Damage done per player"]=true
-- L["Damage from %s"]=true

-- -- enemy damage taken module
-- L["Enemy damage taken"]=true
-- L["Damage taken per player"]=true
-- L["Damage on %s"]=true
-- L["%s's damage sources"]=true

-- -- avoidance and mitigation module
-- L["Avoidance & Mitigation"]=true
-- L["Damage breakdown"]=true
-- L["%s's damage breakdown"]=true

-- -- friendly fire module
-- L["Friendly Fire"]=true

-- L["Glancing"]=true
-- L["Crushing"]=true

-- -- ============= --
-- -- Deaths Module --
-- -- ============= --
-- L["Deaths"]=true
-- L["%s's death"]=true
-- L["%s's deaths"]=true
-- L["Death log"]=true
-- L["%s's death log"]=true
-- L["Player's deaths"]=true
-- L["%s dies"]=true
-- L["Spell details"]=true
-- L["Spell"]=true
-- L["Amount"]=true
-- L["Source"]=true
-- L["Health"]=true
-- L["Change"]=true

-- -- activity module
-- L["Activity"]=true
-- L["Activity per target"]=true

-- -- ==================== --
-- -- dispels module lines --
-- -- ==================== --

-- L["Dispels"]=true

-- L["Dispel spell list"]=true
-- L["Dispelled spell list"]=true
-- L["Dispelled target list"]=true

-- L["%s's dispel spells"]=true
-- L["%s's dispelled spells"]=true
-- L["%s's dispelled targets"]=true

-- -- ==================== --
-- -- failbot module lines --
-- -- ==================== --

-- L["Fails"]=true
-- L["%s's fails"]=true
-- L["Player's failed events"]=true
-- L["Event's failed players"]=true

-- -- ======================== --
-- -- improvement module lines --
-- -- ======================== --

-- L["Improvement"]=true
-- L["Improvement modes"]=true
-- L["Improvement comparison"]=true
-- L["Do you want to reset your improvement data?"]=true
-- L["%s's overall data"]=true

-- -- ======================= --
-- -- interrupts module lines --
-- -- ======================= --

-- L["Interrupts"]=true
-- L["Interrupt spells"]=true
-- L["Interrupted spells"]=true
-- L["Interrupted targets"]=true

-- -- =================== --
-- -- Power gained module --
-- -- =================== --

-- L["Power"]=true
-- L["Power gained"]=true
-- L["%s's gained %s"]=true
-- L["Power gained: Mana"]=true
-- L["Mana gained spell list"]=true
-- L["Power gained: Rage"]=true
-- L["Rage gained spell list"]=true
-- L["Power gained: Energy"]=true
-- L["Energy gained spell list"]=true
-- L["Power gained: Runic Power"]=true
-- L["Runic Power gained spell list"]=true

-- -- ====================== --
-- -- resurrect module lines --
-- -- ====================== --

-- L["Resurrects"]=true
-- L["Resurrect spell list"]=true
-- L["Resurrect spell target list"]=true
-- L["Resurrect target list"]=true
-- L["Resurrect target spell list"]=true
-- L["received resurrects"]=true

-- L["%s's resurrect spells"]=true
-- L["%s's resurrect targets"]=true
-- L["%s's received resurrects"]=true
-- L["%s's resurrect <%s> targets"]=true
