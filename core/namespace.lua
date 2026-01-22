DRAGONFLIGHT()

-- lets begin...
DF = CreateFrame'Frame'

-- saved global vars
_G.DF_Profiles = {}         -- module and module metadata data
_G.DF_LearnedData = {}      -- intellisense data
_G.DF_GlobalData = {}       -- general data like sync etc.
_G.DF_PlayerCache = {}      -- name/class mapping data

-- saved per-character vars
_G.DF_CharData = {}         -- data like stackbuttons etc.

-- main
DF.tables = {}
DF.defaults = {}
DF.modules = {}
DF.setups = {}
DF.callbacks = {}
DF.profile = {}
DF.others = {}
DF.mixins = {}
DF.lib = {}
DF.gui = {}

-- tools
DF.data = {}
DF.lua = {}
DF.math = {}
DF.hooks = {}
DF.ui = {}
DF.date = {}
DF.common = {}
DF.timers = {}
DF.animations = {}
