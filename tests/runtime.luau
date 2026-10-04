-- Run against examples/siff-layout.luau in a Roblox client.
return function(preview)
    local UI, controls, window = preview.UI, preview.Controls, preview.Window
    local passed = {}
    local function check(name, condition)
        assert(condition, "SiffRe test failed: " .. name)
        table.insert(passed, name)
    end
    check("four SIFF pages", #window.Pages == 4)
    check("all SIFF controls constructed", #UI.Controls == 91)
    local duplicate = UI.Groups.ESPHealth
    check("duplicate flags share state", #duplicate.Controls == 2 and duplicate.Controls[1].State == duplicate.Controls[2].State)
    local callbackValues = {}
    for i, control in ipairs(duplicate.Controls) do
        control.Options.Callback = function(value) callbackValues[i] = value end
    end
    UI:SetToggleGroupValue("ESPHealth", false)
    task.wait()
    check("duplicate flag callbacks fire", callbackValues[1] == false and callbackValues[2] == false)
    UI.SetFlags.ESPHealth(true)
    task.wait()
    check("setflags updates both controls", callbackValues[1] == true and callbackValues[2] == true)

    local slider = controls.AutoParryProximityRange
    slider:Set(12.76)
    check("fractional Decimals is a step", slider:GetValue() == 13)
    slider:Set(100)
    check("slider clamps high", slider:GetValue() == 30)
    slider:Set(-3)
    check("slider clamps low", slider:GetValue() == 5)

    local single = controls.ESPRenderMode
    single:Set("External")
    check("single dropdown selection", single:GetValue() == "External")
    single:Refresh({"Internal"})
    check("refresh removes obsolete single selection", single:GetValue() == nil)
    single:Refresh({"Internal", "External"})
    single:Set("Internal")
    local multi = controls.AutoPunishMethods
    multi:Set({M1 = true, M2 = false})
    check("multi accepts keyed selections", #multi:GetValue() == 1 and multi:GetValue()[1] == "M1")
    multi:Select("M1")
    check("required multi keeps one value", #multi:GetValue() == 1)
    multi:Set({"M1", "M2"})
    local exported = multi:GetValue()
    table.clear(exported)
    check("returned values cannot mutate control", #multi:GetValue() == 2)
    local optional = controls.ESPMode
    optional:Set({"Box"})
    optional:Select("Box")
    check("optional multi clears all", #optional:GetValue() == 0)

    local color = Color3.fromRGB(75, 180, 155)
    controls.ESPCustomColor:Set(color)
    check("colorpicker preserves Color3", UI.Flags.ESPCustomColor == color)
    local list = controls.PlayerViewerList
    list:Refresh({"Ada", "Benny", "Cora"})
    list:Set("Benny")
    list.SearchBox.Text = "co"
    check("search filters list", not list.Rows[1].Instance.Visible and list.Rows[3].Instance.Visible)
    list:Refresh({"Ada", "Cora"})
    check("refresh drops removed player", list:GetValue() == nil)
    list.SearchBox.Text = ""
    controls.ChatLogsList:Refresh({"[Ada]: hello", "[Benny]: ready"})
    check("chat holder is a live scrolling frame", controls.ChatLogsList.Items.Holder.Instance:IsA("ScrollingFrame"))

    local binding = controls.AutoParryEnabled.Bind
    binding:Set(Enum.KeyCode.F8)
    binding:Trigger()
    task.wait()
    check("keybind triggers linked toggle", controls.AutoParryEnabled:GetValue() == true)
    controls.AutoParryEnabled:Set(false)
    check("toggle synchronizes bind", binding.Toggled == false)
    binding.Toggled = true
    binding:SetMode()
    task.wait()
    check("SetMode synchronizes explicit Toggled", controls.AutoParryEnabled:GetValue() == true)
    controls.AutoParryEnabled:Set(false)

    local viewer = UI.Viewports[1]
    local world, camera, viewport = viewer.Items.World.Instance, viewer.Items.Camera.Instance, viewer.Items.Viewport.Instance
    local part = Instance.new("Part")
    part.Anchored = true
    part.Parent = world
    viewer:SetTitle("Player Viewer")
    viewer:SetVisible(true)
    camera.CFrame = CFrame.lookAt(Vector3.new(6, 4, 6), Vector3.zero)
    check("viewport keeps supplied camera", viewport.CurrentCamera == camera and world.Parent == viewport)
    viewer:Clear()
    check("Clear preserves world and camera", #world:GetChildren() == 0 and viewport.CurrentCamera == camera)
    viewer:SetVisible(false)

    local holder = list.Items.Holder.Instance
    window.Size:set(Vector2.new(390, 600))
    window.Position:set(Vector2.new(45, 70))
    for _, page in ipairs(window.Pages) do window:SelectPage(page.Name); task.wait(0.1) end
    task.wait(0.15)
    check("narrow layout renders without errors", not UI.Rere.Internal._errored)
    check("list identity survives resize and tab switching", list.Items.Holder.Instance == holder and holder.Parent ~= nil)
    for _, page in ipairs(window.Pages) do
        local layout = UI.Rere.Internal._VDOM[page.ID .. "/columns"]
        check("single column " .. page.Name, layout.Instance.Layout.FillDirection == Enum.FillDirection.Vertical)
    end
    window.Size:set(Vector2.new(760, 640))
    window:SelectPage("main")
    task.wait(0.2)
    check("wide layout restored", not UI.Rere.Internal._errored)
    check("persistent viewport survives redraw", viewer.Items.Camera.Instance == camera and camera.Parent == viewport)
    local notice = UI:Notification("Compatibility checks passed", 2, color)
    check("notification created", not notice:IsClosed())
    notice:Dismiss()
    check("notification dismissed", notice:IsClosed())
    return {passed = #passed, checks = passed}
end
