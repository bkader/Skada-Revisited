local L = LibStub("AceLocale-3.0"):NewLocale("Skada", "enUS", true)
if not L then return end

L["A damage meter."] = true
L["Memory usage is high. You may want to reset Skada, and enable one of the automatic reset options."] = true

L["Skada: Modes"] = true
L["Skada: Fights"] = true

L["Error: No options selected"] = true

L["Profiles"] = true
L["Enable"] = true
L["ENABLED"] = true
L["Disable"] = true
L["DISABLED"] = true

-- common lines
L["Active Time"] = true
L["Segment Time"] = true
L["Click for"] = true
L["Shift-Click for"] = true
L["Control-Click for"] = true
L["Minimum"] = true
L["Minimum hit:"] = true
L["Maximum"] = true
L["Maximum hit:"] = true
L["Average"] = true
L["Average hit:"] = true
L["Total hits:"] = true
L["Count"] = true
L["Refresh"] = true
L["Percent"] = true

L["General options"] = true

-- windows section:
L["Window"] = true
L["Windows"] = true

L["Create window"] = true
L["Enter the name for the new window."] = true

L["Delete window"] = true
L["Choose the window to be deleted."] = true
L["Are you sure you want to delete this window?"] = true

L["Rename window"] = true
L["Enter the name for the window."] = true
L["Lock window"] = true
L["Locks the bar window in place."] = true
L["Hide window"] = true
L["Hides the window."] = true
L["Snap window"] = true
L["Allows the window to snap to other Skada windows."] = true
L["Display system"] = true
L["Choose the system to be used for displaying data in this window."] = true
L["Copy settings"] = true
L["Choose the window from which you want to copy the settings."] = true

-- bars
L["Bars"] = true
L["Bar font"] = true
L["The font used by all bars."] = true
L["Bar font size"] = true
L["The font size of all bars."] = true

L["Values font"] = true
L["The font used by bar values."] = true
L["Values font size"] = true
L["The font size of bar values."] = true

L["Font flags"] = true
L["Sets the font flags."] = true
L["None"] = true
L["Outline"] = true
L["Thick outline"] = true
L["Monochrome"] = true
L["Outlined monochrome"] = true
L["Bar texture"] = true
L["The texture used by all bars."] = true
L["Bar spacing"] = true
L["Distance between bars."] = true
L["Bar height"] = true
L["The height of the bars."] = true
L["Bar width"] = true
L["The width of the bars."] = true
L["Bar orientation"] = true
L["The direction the bars are drawn in."] = true
L["Left to right"] = true
L["Right to left"] = true
L["Reverse bar growth"] = true
L["Bars will grow up instead of down."] = true
L["Bar color"] = true
L["Choose the default color of the bars."] = true
L["Background color"] = true
L["Choose the background color of the bars."] = true
L["Spell school colors"] = true
L["Use spell school colors where applicable."] = true
L["Class color bars"] = true
L["When possible, bars will be colored according to player class."] = true
L["Class color text"] = true
L["When possible, bar text will be colored according to player class."] = true
L["Class icons"] = true
L["Use class icons where applicable."] = true
L["Spec icons"] = true
L["Use specialization icons where applicable."] = true
L["Role icons"] = true
L["Use role icons where applicable."] = true
L["Show spark effect"] = true
L["Clickthrough"] = true
L["Disables mouse clicks on bars."] = true
L["Smooth bars"] = true
L["Animate bar changes smoothly rather than immediately."] = true

-- title bar
L["Title bar"] = true
L["Enables the title bar."] = true
L["Include set"] = true
L["Include set name in title bar"] = true
L["Title height"] = true
L["The height of the title frame."] = true
L["Title font size"] = true
L["The font size of the title bar."] = true
L["Title color"] = true
L["The text color of the title."] = true
L["The texture used as the background of the title."] = true
L["The background color of the title."] = true
L["Border texture"] = true
L["The texture used for the borders."] = true
L["The texture used for the border of the title."] = true
L["Border color"] = true
L["The color used for the border."] = true
L["Buttons"] = true

-- general window
L["Background"] = true
L["Background texture"] = true
L["The texture used as the background."] = true
L["Tile"] = true
L["Tile the background texture."] = true
L["Tile size"] = true
L["The size of the texture pattern."] = true
L["Background color"] = true
L["The color of the background."] = true
L["Border"] = true
L["Border thickness"] = true
L["The thickness of the borders."] = true
L["General"] = true
L["Scale"] = true
L["Sets the scale of the window."] = true
L["Strata"] = true
L["This determines what other frames will be in front of the frame."] = true
L["Width"] = true
L["Height"] = true

-- switching
L["Mode switching"] = true
L["Combat mode"] = true
L["Automatically switch to set 'Current' and this mode when entering combat."] = true
L["Return after combat"] = true
L["Return to the previous set and mode after combat ends."] = true
L["Wipe mode"] = true
L["Automatically switch to set 'Current' and this mode after a wipe."] = true

L["Inline bar display"] = true
L["Inline display is a horizontal window style."] = true
L["Text"] = true
L["Font Color"] = true
L["Font Color. \nClick \"Use class colors\" to begin."] = true
L["Width of bars. This only applies if the \"Fixed bar width\" option is used."] = true
L["Fixed bar width"] = true
L["If checked, bar width is fixed. Otherwise, bar width depends on the text width."] = true
L["Use class colors"] = true
L["Class colors:\n|cFFF58CBAKader|r - 5.71M (21.7K)\n\nWithout:\nKader - 5.71M (21.7K)"] = true
L["Put values on new line."] = true
L["New line:\nKader\n5.71M (21.7K)\n\nDivider:\nKader - 5.71M (21.7K)"] = true
L["Use ElvUI skin if avaliable."] = true
L["Check this to use ElvUI skin instead. \nDefault: checked"] = true
L["Use solid background."] = true
L["Un-check this for an opaque background."] = true

L["Data text"] = true
L["Text color"] = true
L["Choose the default color."] = true
L["Hint: Left-Click to set active mode."] = true
L["Right-click to set active set."] = true
L["Shift+Left-Click to open menu."] = true

-- data resets
L["Data resets"] = true
L["Reset on entering instance"] = true
L["Controls if data is reset when you enter an instance."] = true
L["Reset on joining a group"] = true
L["Controls if data is reset when you join a group."] = true
L["Reset on leaving a group"] = true
L["Controls if data is reset when you leave a group."] = true
L["Ask"] = true
L["Do you want to reset Skada?"] = true
L["All data has been reset."] = true

-- general options
L["Show minimap button"] = true
L["Toggles showing the minimap button."] = true
L["Shorten menus"] = true
L["Removes mode and segment menus from Skada menu to reduce its height. Menus are still accessible using window buttons."] = true
L["Translit"] = true
L["Make those russian letters that no one understand to be presented as western letters."] = true
L["Merge pets"] = true
L["Merges pets with their owners. Changing this only affects new data."] = true
L["Show totals"] = true
L["Shows a extra row with a summary in certain modes."] = true
L["Only keep boss fighs"] = true
L["Boss fights will be kept with this on, and non-boss fights are discarded."] = true
L["Hide when solo"] = true
L["Hides Skada's window when not in a party or raid."] = true
L["Hide in PvP"] = true
L["Hides Skada's window when in Battlegrounds/Arenas."] = true
L["Hide in combat"] = true
L["Hides Skada's window when in combat."] = true
L["Disable while hidden"] = true
L["Skada will not collect any data when automatically hidden."] = true
L["Sort modes by usage"] = true
L["The mode list will be sorted to reflect usage instead of alphabetically."] = true
L["Show rank numbers"] = true
L["Shows numbers for relative ranks for modes where it is applicable."] = true
L["Aggressive combat detection"] = true
L["Skada usually uses a very conservative (simple) combat detection scheme that works best in raids. With this option Skada attempts to emulate other damage meters. Useful for running dungeons. Meaningless on boss encounters."] = true
L["Autostop"] = true
L["Automatically stops the current segment after half of all raid members have died."] = true
L["Always show self"] = true
L["Keeps the player shown last even if there is not enough space."] = true
L["Number format"] = true
L["Controls the way large numbers are displayed."] = true
L["Condensed"] = true
L["Detailed"] = true
L["Data feed"] = true
L["Choose which data feed to show in the DataBroker view. This requires an LDB display addon, such as Titan Panel."] = true
L["Number set duplicates"] = true
L["Append a count to set names with duplicate mob names."] = true
L["Set format"] = true
L["Controls the way set names are displayed."] = true
L["Memory Check"] = true
L["Checks memory usage and warns you if it is greater than or equal to 30mb."] = true
L["Data segments to keep"] = true
L["The number of fight segments to keep. Persistent segments are not included in this."] = true
L["Update frequency"] = true
L["How often windows are updated. Shorter for faster updates. Increases CPU usage."] = true

-- columns
L["Columns"] = true

-- tooltips
L["Tooltips"] = true
L["Show tooltips"] = true
L["Shows tooltips with extra information in some modes."] = true
L["Informative tooltips"] = true
L["Shows subview summaries in the tooltips."] = true
L["Subview rows"] = true
L["The number of rows from each subview to show when using informative tooltips."] = true
L["Tooltip position"] = true
L["Position of the tooltips."] = true
L["Default"] = true
L["Top right"] = true
L["Top left"] = true
L["Bottom right"] = true
L["Bottom left"] = true
L["Smart"] = true
L["Follow Cursor"] = true

-- disabled modules
L["Modules"] = true
L["Disabled Modules"] = true
L["Tick the modules you want to disable."] = true
L["This change requires a UI reload. Are you sure?"] = true
L["Adds a set of standard themes to Skada. Custom themes can also be used."] = true

-- themes module
L["Theme"] = true
L["Themes"] = true
L["Apply theme"] = true
L["Theme applied!"] = true
L["Name of your new theme."] = true
L["Save theme"] = true
L["Delete theme"] = true

-- scroll module
L["Scroll"] = true
L["Mouse"] = true
L["Scrolling speed"] = true
L["Scroll icon"] = true
L["Scroll mouse button"] = true
L["Keybinding"] = true
L["Key scrolling speed"] = true

-- minimap button
L["Skada summary"] = true
L["Left-Click to toggle windows."] = true
L["Shift+Left-Click to reset."] = true
L["Right-click to open menu"] = true

-- skada menu
L["Skada Menu"] = true
L["Delete segment"] = true
L["Keep segment"] = true
L["Toggle window"] = true
L["Start new segment"] = true

-- window buttons
L["Configure"] = true
L["Opens the configuration window."] = true
L["Resets all fight data except those marked as kept."] = true
L["Segment"] = true
L["Jump to a specific segment."] = true
L["Mode"] = true
L["Jump to a specific mode."] = true
L["Report"] = true
L["Opens a dialog that lets you report your data to others in various ways."] = true
L["Stop"] = "Stop/Resume"
L["Stops or resumes the current segment. Useful for discounting data after a wipe. Can also be set to automatically stop in the settings."] = true

-- default segments
L["Total"] = true
L["Current"] = "Current fight"

-- report module and window
L["Skada: %s for %s:"] = true
L["Channel"] = true
L["Self"] = true
L["Party"] = true
L["Whisper"] = true
L["Say"] = true
L["Whisper Target"] = true
L["Raid"] = true
L["Guild"] = true
L["Officer"] = true
L["Lines"] = true
L["There is nothing to report."] = true
L["No mode or segment selected for report."] = true

-- ================== --
-- Bar Display Module --
-- ================== --

L["Bar display"] = true
L["Bar display is the normal bar window used by most damage meters. It can be extensively styled."] = true

-- ============= --
-- Threat Module --
-- ============= --
L["Threat"] = "Etc.: Threat"
L["Threat warning"] = true
L["Do not warn while tanking"] = true
L["Flash screen"] = true
L["This will cause the screen to flash as a threat warning."] = true
L["Shake screen"] = true
L["This will cause the screen to shake as a threat warning."] = true
L["Play sound"] = true
L["This will play a sound as a threat warning."] = true
L["Threat sound"] = true
L["The sound that will be played when your threat percentage reaches a certain point."] = true
L["Threat threshold"] = true
L["When your threat reaches this level, relative to tank, warnings are shown."] = true
L["Show raw threat"] = true
L["Shows raw threat percentage relative to tank instead of modified for range."] = true
L["Use focus target"] = true
L["Shows threat on focus target, or focus target's target, when available."] = true
L["TPS"] = true
L["Threat: Personal Threat"] = true

-- ======================== --
-- Absorbs & Healing Module --
-- ======================== --
L["Healing"] = "A&H: Healing"
L["Healed player list"] = true
L["Healing spell list"] = true
L["%s's healing"] = true
L["%s's healing spells"] = true
L["%s's healed players"] = true
L["HPS"] = true

L["Total healing"] = "A&H: Healing [total]"

L["Overhealing"] = "A&H: Overhealing"
L["Overheal"] = true
L["Overhealed player list"] = true
L["Overhealing spell list"] = true
L["%s's overhealing spells"] = true
L["%s's overhealed players"] = true

L["Healing and Overhealing"] = "A&H: Healing and Overhealing"
L["Healing and overhealing spells"] = true
L["Healed and overhealed players"] = true
L["%s's healing and overhealing spells"] = true
L["%s's healed and overhealed players"] = true

L["Absorbs"] = "A&H: Absorbs"
L["Absorbed player list"] = true
L["Absorb spell list"] = true
L["%s's absorbed players"] = true
L["%s's absorb spells"] = true

L["Absorbs and healing"] = "A&H: Absorbs and Healing"
L["Absorbs and healing spell list"] = true
L["Absorbed and healed players"] = true
L["%s's absorb and healing spells"] = true
L["%s's absorbed and healed players"] = true

L["Healing received"] = "A&H: Healing [received]"
L["Healing player list"] = true
L["%s's received healing"] = true

-- ============ --
-- Auras Module --
-- ============ --

L["Uptime"] = true

L["Buffs and Debuffs"] = "Auras"
L["Buffs"] = "Auras: Buffs"
L["Buff spell list"] = true
L["%s's buffs"] = true

L["Debuffs"] = "Auras: Debuffs"
L["Debuff spell list"] = true
L["Debuff target list"] = true
L["%s's debuffs"] = true
L["%s's <%s> targets"] = true

L["Sunder Counter"] = "Auras: Sunder Counter"
L["Sunder target list"] = true

-- ================= --
-- CC Tracker Module --
-- ================= --

L["CC Tracker"] = true

-- CC Done:
L["CC Done"] = "CC: Done"
L["CC Done spells"] = true
L["CC Done spell targets"] = true
L["CC Done targets"] = true
L["CC Done target spells"] = true
L["%s's CC Done <%s> targets"] = true
L["%s's CC Done <%s> spells"] = true
L["%s's CC Done spells"] = true
L["%s's CC Done targets"] = true

-- CC Taken
L["CC Taken"] = "CC: Taken"
L["CC Taken spells"] = true
L["CC Taken spell sources"] = true
L["CC Taken sources"] = true
L["CC Taken source spells"] = true
L["%s's CC Taken <%s> sources"] = true
L["%s's CC Taken <%s> spells"] = true
L["%s's CC Taken spells"] = true
L["%s's CC Taken sources"] = true

L["CC Breaks"] = true
L["CC Breakers"] = "CC: Breakers"
L["CC Break spells"] = true
L["CC Break spell targets"] = true
L["CC Break targets"] = true
L["CC Break target spells"] = true
L["%s's CC Break <%s> spells"] = true
L["%s's CC Break <%s> targets"] = true
L["%s's CC Break spells"] = true
L["%s's CC Break targets"] = true

-- options
L["CC"] = true
L["Announce CC breaking to party"] = true
L["Ignore Main Tanks"] = true
L["%s on %s removed by %s"] = true
L["%s on %s removed by %s's %s"] = true

-- ============= --
-- Damage Module --
-- ============= --

-- damage done module
L["Damage"] = "DD: Damage done"
L["Damage target list"] = true
L["Damage spell list"] = true
L["Damage spell details"] = true
L["Damage spell targets"] = true
L["Damage done"] = "DD: Damage done"
L["%s's damage"] = true
L["%s's <%s> damage"] = true

L["Useful damage"] = "DD: Useful damage"

L["Damage done by spell"] = "DD: By spell"
L["%s's sources"] = true

L["DPS"] = "DD: DPS"
L["Damage: Personal DPS"] = true

L["RDPS"] = true
L["Damage: Raid DPS"] = true

-- damage taken module
L["Damage taken"] = "DT: Damage taken"
L["Damage taken by %s"] = true
L["%s damage on %s"] = true

L["Damage source list"] = true
L["Damage spell sources"] = true
L["Damage taken by spell"] = "DT: From spells"
L["%s's targets"] = true
L["DTPS"] = true

-- enemy damage done module
L["Enemy damage done"] = "DT: From enemies"
L["Damage done per player"] = true
L["Damage from %s"] = true
L["%s's damage on %s"] = true

-- enemy damage taken module
L["Enemy damage taken"] = "DD: Taken by enemy"
L["Damage taken per player"] = true
L["Damage on %s"] = true
L["%s's damage sources"] = true

-- avoidance and mitigation module
L["Avoidance & Mitigation"] = "DT: Avoidance & Mitigation"
L["Damage breakdown"] = true
L["%s's damage breakdown"] = true

-- friendly fire module
L["Friendly Fire"] = "DD: Friendly Fire"

L["Critical"] = true
L["Glancing"] = true
L["Crushing"] = true

-- useful damage targets
L["Useful targets"] = true
L["Oozes"] = true
L["Princes overkilling"] = true
L["Adds"] = true
L["Halion and Inferno"] = true
L["Valkyrs overkilling"] = true

-- missing bosses entries
L["Cult Adherent"] = true
L["Cult Fanatic"] = true
L["Darnavan"] = true
L["Deformed Fanatic"] = true
L["Empowered Adherent"] = true
L["Gas Cloud"] = true
L["Living Inferno"] = true
L["Reanimated Adherent"] = true
L["Reanimated Fanatic"] = true
L["Volatile Ooze"] = true
L["Wicked Spirit"] = true

L["Kor'kron Sergeant"] = true
L["Kor'kron Axethrower"] = true
L["Kor'kron Rocketeer"] = true
L["Kor'kron Battle-Mage"] = true
L["Skybreaker Sergeant"] = true
L["Skybreaker Rifleman"] = true
L["Skybreaker Mortar Soldier"] = true
L["Skybreaker Sorcerer"] = true
L["Stinky"] = true
L["Precious"] = true
L["Dream Cloud"] = true
L["Risen Archmage"] = true
L["Blazing Skeleton"] = true
L["Blistering Zombie"] = true
L["Gluttonous Abomination"] = true

-- ============= --
-- Deaths Module --
-- ============= --
L["Deaths"] = "Etc.: Deaths"
L["%s's death"] = true
L["%s's deaths"] = true
L["Death log"] = true
L["%s's death log"] = true
L["Player's deaths"] = true
L["%s dies"] = true
L["Spell details"] = true
L["Spell"] = true
L["Amount"] = true
L["Source"] = true
L["Health"] = true
L["Change"] = true

-- activity module
L["Activity"] = "Etc.: Activity"
L["Activity per target"] = true

-- ==================== --
-- dispels module lines --
-- ==================== --

L["Dispels"] = "Etc.: Dispels"

L["Dispel spell list"] = true
L["Dispelled spell list"] = true
L["Dispelled target list"] = true

L["%s's dispel spells"] = true
L["%s's dispelled spells"] = true
L["%s's dispelled targets"] = true

-- ==================== --
-- failbot module lines --
-- ==================== --

L["Fails"] = "Etc.: Fails"
L["%s's fails"] = true
L["Player's failed events"] = true
L["Event's failed players"] = true

-- ======================== --
-- improvement module lines --
-- ======================== --

L["Improvement"] = "Etc.: Improvement"
L["Improvement modes"] = true
L["Improvement comparison"] = true
L["Do you want to reset your improvement data?"] = true
L["%s's overall data"] = true

-- ======================= --
-- interrupts module lines --
-- ======================= --

L["Interrupts"] = "Etc.: Interrupts"
L["Interrupt spells"] = true
L["Interrupted spells"] = true
L["Interrupted targets"] = true
L["%s's interrupt spells"] = true
L["%s's interrupted spells"] = true
L["%s's interrupted targets"] = true

-- =================== --
-- Power gained module --
-- =================== --

L["Power"] = true
L["Power gained"] = true
L["%s's gained %s"] = true
L["Power gained: Mana"] = true
L["Mana gained spell list"] = true
L["Power gained: Rage"] = true
L["Rage gained spell list"] = true
L["Power gained: Energy"] = true
L["Energy gained spell list"] = true
L["Power gained: Runic Power"] = true
L["Runic Power gained spell list"] = true

-- ==================== --
-- Parry module lines --
-- ==================== --

L["Parry-haste"] = "Etc.: Parry-haste"
L["Parry target list"] = true
L["%s's parry targets"] = true

-- ==================== --
-- Potions module lines --
-- ==================== --

L["Potions"] = "Etc.: Potions"
L["Potions list"] = true
L["Players list"] = true
L["%s's used potions"] = true

-- ====================== --
-- resurrect module lines --
-- ====================== --

L["Resurrects"] = "Etc.: Resurrects"
L["Resurrect spell list"] = true
L["Resurrect spell target list"] = true
L["Resurrect target list"] = true
L["Resurrect target spell list"] = true

L["%s's resurrect spells"] = true
L["%s's resurrect targets"] = true
L["%s's received resurrects"] = true
L["%s's resurrect <%s> targets"] = true

-- ==================== --
-- spamage module lines --
-- ==================== --

L["Spamage"] = true
L["Suppresses chat messages from damage meters and provides single chat-link damage statistics in a popup."] = true
L["Capture Delay"] = true
L["How many seconds the addon waits after \"Skada: *\" lines before it assumes spam burst is over. 1 seems to work in most cases"] = true
L["Filter Custom Channels"] = true
L["Selects the action to perform when encountering damage meter data in custom channels"] = true
L["Filter Guild"] = true
L["Selects the action to perform when encountering damage meter data in guild chat"] = true
L["Filter Officer"] = true
L["Selects the action to perform when encountering damage meter data in officer chat"] = true
L["Filter Party"] = true
L["Selects the action to perform when encountering damage meter data in party chat"] = true
L["Filter Raid"] = true
L["Selects the action to perform when encountering damage meter data in raid chat"] = true
L["Filter Say"] = true
L["Selects the action to perform when encountering damage meter data in say chat"] = true
L["Filter Whisper"] = true
L["Selects the action to perform when encountering damage meter whisper"] = true
L["Filter Yell"] = true
L["Selects the action to perform when encountering damage meter data in yell chat"] = true
L["Do Nothing"] = true
L["Compress"] = true
L["Suppress"] = true
L["Reported by: %s"] = true

-- ===================== --
-- nickname module lines --
-- ===================== --

L["Nickname"] = true
L["Set a nickname for you.\nNicknames are sent to group members and Skada can use them instead of your character name."] = true
L["Nickname isn't a valid string."] = true
L["Your nickname is too long, max of 12 characters is allowed."] = true
L["Only letters and two spaces are allowed."] = true
L["You can't use the same letter three times consecutively, two spaces consecutively or more then two spaces."] = true
L["Ignore Nicknames"] = true
L["When enabled, nicknames set by Skada users are ignored."] = true
L["Name display"] = true
L["Choose how names are shown on your bars."] = true
