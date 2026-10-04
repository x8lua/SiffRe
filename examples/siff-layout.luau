-- UI-only fixture extracted from SIFF control declarations; no gameplay callbacks.
return function(UI)
    local controls = {}
    local c1 = UI:Window({Name = "SiffRe | SIFF", FooterText = "SiffRe 1.0.0"})
    local c2 = c1:KeybindList()
    local c3 = c1:Page({Name = "main"})
    local c4 = c3:Section({Name = "Auto Parry", Side = 1})
    local c5 = c3:Section({Name = "Auto Punish", Side = 1})
    local c6 = c3:Section({Name = "Misc", Side = 2})
    local c7 = c3:Section({Name = "Fun", Side = 2})
    local c8 = c3:Section({Name = "Auto Rhythm (PC / Mobile)", Side = 1})
    local c9 = c6:Toggle({Name = "Show Info", Flag = "ESPHealth", Default = true})
    if c9.Options.Flag then controls[c9.Options.Flag] = c9 end
    local c10 = c6:Toggle({Name = "Infinite Stamina", Flag = "InfiniteStamina", Default = false})
    if c10.Options.Flag then controls[c10.Options.Flag] = c10 end
    local c11 = c6:Toggle({Name = "Auto Sprint", Flag = "AlwaysRunning", Default = false})
    if c11.Options.Flag then controls[c11.Options.Flag] = c11 end
    local c12 = c6:Toggle({Name = "Instant Revive", Flag = "AutoRevive", Default = false})
    if c12.Options.Flag then controls[c12.Options.Flag] = c12 end
    local c13 = c6:Toggle({Name = "No Ragdoll", Flag = "NoRagdoll", Default = false})
    if c13.Options.Flag then controls[c13.Options.Flag] = c13 end
    local c14 = c6:Toggle({Name = "No Stun", Flag = "NoStun", Default = false})
    if c14.Options.Flag then controls[c14.Options.Flag] = c14 end
    local c15 = c6:Toggle({Name = "Disable Glasses Knocked", Flag = "DisableGlassesKnocked", Default = false})
    if c15.Options.Flag then controls[c15.Options.Flag] = c15 end
    local c16 = c6:Divider({})
    local c17 = c6:Toggle({Name = "Auto Respawn", Flag = "AutoRespawn", Default = false})
    if c17.Options.Flag then controls[c17.Options.Flag] = c17 end
    local c18 = c6:Slider({Name = "HP Threshold", Flag = "AutoRespawnHPThreshold", DependsOn = "AutoRespawn", Min = 1, Max = 50, Default = 25, Decimals = 1, Suffix = "%"})
    if c18.Options.Flag then controls[c18.Options.Flag] = c18 end
    local c19 = c6:Button({Name = "Respawn Character"})
    local c20 = c7:Toggle({Name = "Fling Aura", Flag = "FlingAura", Default = false})
    if c20.Options.Flag then controls[c20.Options.Flag] = c20 end
    local c21 = c7:Toggle({Name = "Change Hair Color", Flag = "ChangeHairColor", Default = false})
    if c21.Options.Flag then controls[c21.Options.Flag] = c21 end
    local c22 = c7:Dropdown({Name = "Hair Color", Flag = "SelectedHairColor", DependsOn = "ChangeHairColor", Default = "White", Multi = false})
    if c22.Options.Flag then controls[c22.Options.Flag] = c22 end
    local c23 = c6:Divider({})
    local c24 = c6:Dropdown({Name = "Area Teleport", Flag = "NishikataHighAreaTeleport", IgnoreConfig = true, Default = nil, Multi = false, MaxHeight = 180})
    if c24.Options.Flag then controls[c24.Options.Flag] = c24 end
    local c25 = c8:Toggle({Name = "Auto Rhythm", Flag = "AutoPlayerEnabled", Default = false})
    if c25.Options.Flag then controls[c25.Options.Flag] = c25 end
    local c26 = c8:Slider({Name = "Perfect", Flag = "AutoPlayerPerfect", DependsOn = "AutoPlayerEnabled", Min = 0, Max = 100, Default = 100, Decimals = 1, Suffix = "%"})
    if c26.Options.Flag then controls[c26.Options.Flag] = c26 end
    local c27 = c8:Slider({Name = "Good", Flag = "AutoPlayerGood", DependsOn = "AutoPlayerEnabled", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "%"})
    if c27.Options.Flag then controls[c27.Options.Flag] = c27 end
    local c28 = c8:Slider({Name = "Okay", Flag = "AutoPlayerOkay", DependsOn = "AutoPlayerEnabled", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "%"})
    if c28.Options.Flag then controls[c28.Options.Flag] = c28 end
    local c29 = c8:Slider({Name = "Bad", Flag = "AutoPlayerBad", DependsOn = "AutoPlayerEnabled", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "%"})
    if c29.Options.Flag then controls[c29.Options.Flag] = c29 end
    local c30 = c8:Slider({Name = "Miss", Flag = "AutoPlayerMiss", DependsOn = "AutoPlayerEnabled", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "%"})
    if c30.Options.Flag then controls[c30.Options.Flag] = c30 end
    local c31 = c3:Section({Name = "Auto Green", Side = 2})
    local c32 = c31:Toggle({Name = "Enabled", Flag = "AutoGreenEnabled", Default = false})
    if c32.Options.Flag then controls[c32.Options.Flag] = c32 end
    local c33 = c31:Dropdown({Name = "Select Method", Flag = "AutoGreenMethod", DependsOn = "AutoGreenEnabled", Items = {"Legit", "Rage"}, Multi = false})
    if c33.Options.Flag then controls[c33.Options.Flag] = c33 end
    local c34 = c4:Toggle({Name = "Enabled", Flag = "AutoParryEnabled"})
    if c34.Options.Flag then controls[c34.Options.Flag] = c34 end
    local c35 = c34:Keybind({Name = "Auto Parry", Flag = "AutoParryKeybind", Default = Enum.KeyCode.H, Mode = "Toggle"})
    local c36 = c4:Toggle({Name = "Pause M1 for Parry", Flag = "AutoParryPauseM1", DependsOn = "AutoParryEnabled"})
    if c36.Options.Flag then controls[c36.Options.Flag] = c36 end
    local c37 = c4:Dropdown({Name = "Select Priority", Flag = "AutoParryPriority", DependsOn = "AutoParryEnabled", Items = {"Block", "Evasive"}, Multi = false})
    if c37.Options.Flag then controls[c37.Options.Flag] = c37 end
    local c38 = c4:Dropdown({Name = "Evasive Mode", Flag = "AutoParryEvasiveMode", DependsOn = "AutoParryEnabled", Items = {"M1 & M2", "M2 Only"}, Multi = false})
    if c38.Options.Flag then controls[c38.Options.Flag] = c38 end
    local c39 = c4:Dropdown({Name = "Select Evasive Directional", Flag = "AutoParryEvasiveDirectional", DependsOn = "AutoParryEnabled", Items = {"Default", "Behind", "Sideways"}, Multi = false})
    if c39.Options.Flag then controls[c39.Options.Flag] = c39 end
    local c40 = c4:Slider({Name = "Detection Range", Flag = "AutoParryProximityRange", DependsOn = "AutoParryEnabled", Min = 5, Max = 30, Decimals = 0.5, Suffix = " studs"})
    if c40.Options.Flag then controls[c40.Options.Flag] = c40 end
    local c41 = c4:Slider({Name = "Facing Strictness", Flag = "AutoParryFacingThreshold", DependsOn = "AutoParryEnabled", Min = 0, Max = 1, Decimals = 0.01})
    if c41.Options.Flag then controls[c41.Options.Flag] = c41 end
    local c42 = c4:Divider({})
    local c43 = c4:Dropdown({Name = "Whitelist Players", Flag = "AutoParryWhitelistPlayers", IgnoreConfig = true, DependsOn = "AutoParryEnabled", Items = {}, Default = {}, Multi = true, MaxHeight = 170})
    if c43.Options.Flag then controls[c43.Options.Flag] = c43 end
    local c44 = c5:Toggle({Name = "Enabled", Flag = "AutoPunishEnabled"})
    if c44.Options.Flag then controls[c44.Options.Flag] = c44 end
    local c45 = c5:Dropdown({Name = "Select Method", Flag = "AutoPunishMethods", DependsOn = "AutoPunishEnabled", Items = {"M1", "M2"}, Default = {"M1", "M2"}, Multi = true, Required = true})
    if c45.Options.Flag then controls[c45.Options.Flag] = c45 end
    local c46 = c1:Page({Name = "visuals"})
    local c47 = c46:Section({Name = "ESP", Side = 1})
    local c48 = c46:Section({Name = "Name ", Side = 1})
    local c49 = c46:Section({Name = "Health", Side = 1})
    local c50 = c46:Section({Name = "Distance", Side = 1})
    local c51 = c46:Section({Name = "Settings", Side = 2})
    local c52 = c47:Toggle({Name = "Enabled", Flag = "ESPVisualEnabled", Default = false})
    if c52.Options.Flag then controls[c52.Options.Flag] = c52 end
    local c53 = c47:Toggle({Name = "Exclude Self", Flag = "ESPVisualExcludeSelf", DependsOn = "ESPVisualEnabled", Default = true})
    if c53.Options.Flag then controls[c53.Options.Flag] = c53 end
    local c54 = c47:Dropdown({Name = "Mode", Flag = "ESPMode", DependsOn = "ESPVisualEnabled", Items = {"Box", "Body", "Highlight"}, Default = {}, Multi = true})
    if c54.Options.Flag then controls[c54.Options.Flag] = c54 end
    local c55 = c48:Toggle({Name = "Enabled", Flag = "ESPName", Default = false})
    if c55.Options.Flag then controls[c55.Options.Flag] = c55 end
    local c56 = c48:Toggle({Name = "Exclude Self", Flag = "ESPNameExcludeSelf", DependsOn = "ESPName", Default = true})
    if c56.Options.Flag then controls[c56.Options.Flag] = c56 end
    local c57 = c48:Dropdown({Name = "Display", Flag = "ESPNameDisplay", DependsOn = "ESPName", Items = {"Username", "Display Name"}, Default = "Username", Multi = false})
    if c57.Options.Flag then controls[c57.Options.Flag] = c57 end
    local c58 = c49:Toggle({Name = "Enabled", Flag = "ESPHealth", Default = true})
    if c58.Options.Flag then controls[c58.Options.Flag] = c58 end
    local c59 = c49:Toggle({Name = "Exclude Self", Flag = "ESPHealthExcludeSelf", DependsOn = "ESPHealth", Default = false})
    if c59.Options.Flag then controls[c59.Options.Flag] = c59 end
    local c60 = c49:Dropdown({Name = "Mode", Flag = "ESPHealthMode", DependsOn = "ESPHealth", Items = {"Text", "Bar"}, Default = {"Text", "Bar"}, Multi = true, Required = true})
    if c60.Options.Flag then controls[c60.Options.Flag] = c60 end
    local c61 = c49:Dropdown({Name = "Display", Flag = "ESPHealthDisplay", DependsOn = "ESPHealth", Items = {"Current / Max", "Percentage"}, Default = "Current / Max", Multi = false})
    if c61.Options.Flag then controls[c61.Options.Flag] = c61 end
    local c62 = c50:Toggle({Name = "Enabled", Flag = "ESPDistanceEnabled", Default = false})
    if c62.Options.Flag then controls[c62.Options.Flag] = c62 end
    local c63 = c50:Toggle({Name = "Exclude Self", Flag = "ESPDistanceExcludeSelf", DependsOn = "ESPDistanceEnabled", Default = true})
    if c63.Options.Flag then controls[c63.Options.Flag] = c63 end
    local c64 = c51:Dropdown({Name = "Select Mode", Flag = "ESPRenderMode", Items = {"Internal", "External"}, Default = "Internal", Multi = false})
    if c64.Options.Flag then controls[c64.Options.Flag] = c64 end
    local c65 = c51:Slider({Name = "Distance", Flag = "ESPTotalDistance", Min = 50, Max = 1000, Default = 120, Decimals = 1, Suffix = " studs"})
    if c65.Options.Flag then controls[c65.Options.Flag] = c65 end
    local c66 = c51:Slider({Name = "Size", Flag = "ESPSize", Min = 0.5, Max = 2, Default = 1, Decimals = 0.05, Suffix = "x"})
    if c66.Options.Flag then controls[c66.Options.Flag] = c66 end
    local c67 = c51:Slider({Name = "Transparency", Flag = "ESPTransparency", Min = 0, Max = 1, Default = 0, Decimals = 0.05})
    if c67.Options.Flag then controls[c67.Options.Flag] = c67 end
    local c68 = c51:Slider({Name = "Name Offset", Flag = "ESPNameOffset", Min = -10, Max = 10, Default = -4, Decimals = 0.05})
    if c68.Options.Flag then controls[c68.Options.Flag] = c68 end
    local c69 = c51:Slider({Name = "Health Offset", Flag = "ESPHealthOffset", Min = -10, Max = 10, Default = -5, Decimals = 0.05})
    if c69.Options.Flag then controls[c69.Options.Flag] = c69 end
    local c70 = c51:Slider({Name = "Distance Offset", Flag = "ESPDistanceOffset", Min = -10, Max = 10, Default = 2, Decimals = 0.05})
    if c70.Options.Flag then controls[c70.Options.Flag] = c70 end
    local c71 = c51:Toggle({Name = "Visible Check", Flag = "ESPVisibleCheck", Default = true})
    if c71.Options.Flag then controls[c71.Options.Flag] = c71 end
    local c72 = c51:Dropdown({Name = "ESP Color", Flag = "ESPColorMode", Items = {"Custom", "Health Based"}, Default = "Custom", Multi = false})
    if c72.Options.Flag then controls[c72.Options.Flag] = c72 end
    local c73 = c51:Dropdown({Name = "Text Color", Flag = "ESPTextColorMode", Items = {"Custom", "Health Based"}, Default = "Custom", Multi = false})
    if c73.Options.Flag then controls[c73.Options.Flag] = c73 end
    local c74 = c51:Label({Name = "ESP Custom Color"})
    local c75 = c51:Label({Name = "ESP Visible Color"})
    local c76 = c51:Label({Name = "Text Custom Color"})
    local c77 = c1:Page({Name = "misc"})
    local c78 = c77:Section({Name = "Chat Logs", Side = 1})
    local c79 = c77:Section({Name = "Universal", Side = 2})
    local c80 = c77:Section({Name = "Players", Side = 2})
    local c81 = c78:Toggle({Name = "Enabled", Flag = "ChatLogsEnabled", Default = false})
    if c81.Options.Flag then controls[c81.Options.Flag] = c81 end
    local c82 = c78:List({Flag = "ChatLogsList", IgnoreConfig = true, DependsOn = "ChatLogsEnabled", Items = {}, Height = 300, Multi = false, Search = true, Selectable = false, Alignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Padding = 4})
    if c82.Options.Flag then controls[c82.Options.Flag] = c82 end
    local c83 = c79:Toggle({Name = "Noclip", Flag = "UniversalNoclip", Default = false})
    if c83.Options.Flag then controls[c83.Options.Flag] = c83 end
    local c84 = c79:Divider({})
    local c85 = c79:Dropdown({Name = "Waypoints", Flag = "UniversalWaypoint", IgnoreConfig = true, Items = {"No Waypoints"}, Default = "No Waypoints", Multi = false})
    if c85.Options.Flag then controls[c85.Options.Flag] = c85 end
    local c86 = c79:Button({Name = "Save Waypoint"})
    local c87 = c79:Button({Name = "Teleport Waypoint"})
    local c88 = UI:ViewportWindow({Name = "Player Viewer", Size = UDim2.fromOffset(315, 335), Position = UDim2.new(1, -335, 0.5, -168), Visible = false})
    local c89 = c80:List({Flag = "PlayerViewerList", IgnoreConfig = true, Items = {}, Height = 170, Multi = false, Search = true, Selectable = true, Alignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = false, Padding = 4})
    if c89.Options.Flag then controls[c89.Options.Flag] = c89 end
    local c90 = c80:Divider({})
    local c91 = c80:Toggle({Name = "Spectate", Flag = "PlayerViewerSpectate", Default = false})
    if c91.Options.Flag then controls[c91.Options.Flag] = c91 end
    local c92 = c80:Button({Name = "Teleport"})
    local c93 = c1:Page({Name = "home"})
    local c94 = c93:Section({Name = "Performance", Side = 1})
    local c95 = c93:Section({Name = "Reshader", Side = 1})
    local c96 = c93:Section({Name = "Security", Side = 2})
    local c97 = c93:Section({Name = "Server", Side = 2})
    local c98 = c94:Toggle({Name = "Low GFX", Flag = "HomeLowGFX", Default = false})
    if c98.Options.Flag then controls[c98.Options.Flag] = c98 end
    local c99 = c94:Toggle({Name = "Better Lightings", Flag = "HomeBetterLighting", Default = false})
    if c99.Options.Flag then controls[c99.Options.Flag] = c99 end
    local c100 = c94:Toggle({Name = "Clear Fog", Flag = "HomeClearFog", Default = false})
    if c100.Options.Flag then controls[c100.Options.Flag] = c100 end
    local c101 = c94:Slider({Name = "Camera FOV", Flag = "HomeCameraFOV", DependsOn = "HomeFOVEnabled", Min = 1, Max = 120, Decimals = 1})
    if c101.Options.Flag then controls[c101.Options.Flag] = c101 end
    local c102 = c94:Toggle({Name = "FOV Enabled", Flag = "HomeFOVEnabled", Default = false})
    if c102.Options.Flag then controls[c102.Options.Flag] = c102 end
    local c103 = c95:Toggle({Name = "Enabled", Flag = "HomeReshaderEnabled", Default = false})
    if c103.Options.Flag then controls[c103.Options.Flag] = c103 end
    local c104 = c95:Dropdown({Name = "FX Style", Flag = "HomeReshaderStyle", DependsOn = "HomeReshaderEnabled", Items = {"Vibrant", "Cinematic", "Clarity", "NeoNoir", "Sunset", "ColdSteel", "Retro", "Horror", "NightCity", "BloomPop"}, Default = "Vibrant", Multi = false})
    if c104.Options.Flag then controls[c104.Options.Flag] = c104 end
    local c105 = c96:Toggle({Name = "Anti AFK", Flag = "HomeAntiAFK", Default = true})
    if c105.Options.Flag then controls[c105.Options.Flag] = c105 end
    local c106 = c96:Toggle({Name = "Anti Mod", Flag = "HomeAntiMod", Default = true})
    if c106.Options.Flag then controls[c106.Options.Flag] = c106 end
    local c107 = c96:Divider({})
    local c108 = c96:Dropdown({Name = "Method", Flag = "HomeAntiModMethod", DependsOn = "HomeAntiMod", Items = {"Notify", "Kick"}, Default = "Notify", Multi = false})
    if c108.Options.Flag then controls[c108.Options.Flag] = c108 end
    local c109 = c96:Toggle({Name = "Silent Execution", Flag = "HomeSilentExecution", Default = false})
    if c109.Options.Flag then controls[c109.Options.Flag] = c109 end
    local c110 = c97:Toggle({Name = "Lag Switch", Flag = "HomeLagSwitch", Default = false})
    if c110.Options.Flag then controls[c110.Options.Flag] = c110 end
    local c111 = c97:Button({Name = "Rejoin"})
    local c112 = c97:Button({Name = "Best Ping"})
    local c113 = c97:Button({Name = "Random"})
    local c114 = c97:Button({Name = "Least Player"})
    local c115 = c74:Colorpicker({Name = "ESP Custom Color", Flag = "ESPCustomColor", Default = Color3.fromRGB(74, 158, 255)})
    if c115.Options.Flag then controls[c115.Options.Flag] = c115 end
    local c116 = c75:Colorpicker({Name = "ESP Visible Color", Flag = "ESPVisibleColor", Default = Color3.fromRGB(255, 0, 0)})
    if c116.Options.Flag then controls[c116.Options.Flag] = c116 end
    local c117 = c76:Colorpicker({Name = "Text Custom Color", Flag = "ESPTextCustomColor", Default = Color3.fromRGB(255, 255, 255)})
    if c117.Options.Flag then controls[c117.Options.Flag] = c117 end
    c1:Init()
    return {UI = UI, Window = c1, Controls = controls}
end
