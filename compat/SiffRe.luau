--!nocheck
-- Retained SIFF controls backed by the bundled Rere / Iris renderer.
return function(Rere, Notifications)
    local environment = (getgenv and getgenv()) or _G
    if environment.SiffRe and type(environment.SiffRe.Destroy) == "function" then
        environment.SiffRe:Destroy()
    end
    local UI = {Version = "1.0.0", Flags = {}, SetFlags = {}, Windows = {}, Controls = {},
        Groups = {}, Binds = {}, Viewports = {}, Connections = {}, Alive = true, Rere = Rere}
    environment.SiffRe = UI
    local serial = 0
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local parent = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")
    local parking = Instance.new("Folder")
    parking.Name = "SiffReOwned"
    parking.Parent = parent

    local function id()
        serial += 1
        return "SiffRe/" .. serial
    end
    local function state(value)
        Rere.SetNextWidgetID(id())
        return Rere.State(value)
    end
    local function copy(value)
        return type(value) == "table" and table.clone(value) or value
    end
    local function same(a, b)
        if type(a) ~= "table" or type(b) ~= "table" then return a == b end
        if #a ~= #b then return false end
        for i, value in ipairs(a) do if value ~= b[i] then return false end end
        return true
    end
    local function connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(UI.Connections, connection)
        return connection
    end
    local function dispatch(control, ...)
        local args = table.pack(...)
        if type(control.Options.Callback) ~= "function" then return end
        task.spawn(function()
            if not UI.Alive or control.Removed then return end
            local ok, err = pcall(control.Options.Callback, table.unpack(args, 1, args.n))
            if not ok then warn("[SiffRe " .. control.Name .. "] " .. tostring(err)) end
        end)
    end
    local function make(class, properties, owner)
        local instance = Instance.new(class)
        for key, value in pairs(properties) do instance[key] = value end
        instance.Parent = owner
        return instance
    end
    local function styledText(class, properties, owner)
        local defaults = {Font = Enum.Font.Arial, TextSize = 13, TextColor3 = Color3.fromRGB(231, 233, 238),
            BackgroundTransparency = 1, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left}
        for key, value in pairs(properties) do defaults[key] = value end
        return make(class, defaults, owner)
    end
    local function keyName(value)
        if typeof(value) == "EnumItem" then return value.Name end
        if value == nil or value == "Unknown" then return "None" end
        return tostring(value)
    end
    local Control = {}
    Control.__index = Control
    local Section = {}
    Section.__index = Section
    local Window = {}
    Window.__index = Window
    local Page = {}
    Page.__index = Page

    local function normalize(control, value)
        local options = control.Options
        if control.Kind == "Toggle" then return value == true end
        if control.Kind == "Slider" then
            local minimum, maximum = options.Min or 0, options.Max or 100
            local step = math.max(tonumber(options.Decimals) or 1, 0.000001)
            local number = tonumber(value) or minimum
            return math.clamp(minimum + math.round((number - minimum) / step) * step, minimum, maximum)
        end
        if control.Kind == "Dropdown" or control.Kind == "List" then
            if options.Multi then
                local selected = {}
                for _, item in ipairs(control.Values) do
                    if type(value) == "table" and (table.find(value, item) or value[item] == true) then
                        table.insert(selected, item)
                    end
                end
                if options.Required and #selected == 0 and #control.Values > 0 then
                    local previous = control.State and control.State.value or {}
                    for _, item in ipairs(previous) do
                        if table.find(control.Values, item) then table.insert(selected, item); break end
                    end
                    if #selected == 0 then table.insert(selected, control.Values[1]) end
                end
                return selected
            end
            if value ~= nil and table.find(control.Values, value) then return value end
            return options.Required and control.Values[1] or nil
        end
        if control.Kind == "Colorpicker" then
            return typeof(value) == "Color3" and value or Color3.new(1, 1, 1)
        end
        return value
    end
    function Control:GetValue() return copy(self.State and self.State.value) end
    function Control:GetValueString()
        local value = self:GetValue()
        return type(value) == "table" and table.concat(value, ", ") or tostring(value or "")
    end
    function Control:Set(value)
        if not self.State or self.Removed then return self end
        value = normalize(self, value)
        if not same(value, self.State.value) then self.State:set(copy(value)) end
        return self
    end
    function Control:CallFunction() dispatch(self, self:GetValue()) end
    function Control:SetVisible(visible) self.Visible = visible ~= false; return self end
    function Control:SetTitle(name) self.Name = tostring(name); return self end
    function Control:Remove() self.Removed = true; self.Visible = false end
    function Control:Refresh(items)
        self.Values = table.clone(items or {})
        if self.Kind == "List" then self:RebuildList() end
        self:Set(self:GetValue())
        return self
    end
    local function selected(control, item)
        local value = control.State.value
        return control.Options.Multi and table.find(value, item) ~= nil or value == item
    end
    function Control:Select(item)
        if not self.Options.Multi then self:Set(item); return end
        local values = self:GetValue()
        local index = table.find(values, item)
        if index then table.remove(values, index) else table.insert(values, item) end
        self:Set(values)
    end
    function Control:FilterList()
        local query = self.SearchBox and string.lower(self.SearchBox.Text) or ""
        for _, row in ipairs(self.Rows or {}) do
            row.Instance.Visible = query == "" or string.find(string.lower(tostring(row.Value)), query, 1, true) ~= nil
            row.Instance.BackgroundTransparency = selected(self, row.Value) and 0 or 1
        end
    end
    function Control:RebuildList()
        for _, row in ipairs(self.Rows or {}) do row.Instance:Destroy() end
        self.Rows = {}
        local holder = self.Items.Holder.Instance
        for index, value in ipairs(self.Values) do
            local selectable = self.Options.Selectable ~= false
            local row = styledText(selectable and "TextButton" or "TextLabel", {
                Name = "Entry", Text = tostring(value), Size = UDim2.new(1, -8, 0, 24),
                AutomaticSize = self.Options.TextWrapped and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                TextWrapped = self.Options.TextWrapped == true, LayoutOrder = index,
                TextXAlignment = self.Options.Alignment or Enum.TextXAlignment.Left,
                TextYAlignment = self.Options.TextYAlignment or Enum.TextYAlignment.Center,
                BackgroundColor3 = Color3.fromRGB(55, 83, 98),
            }, holder)
            make("UIPadding", {PaddingLeft = UDim.new(0, self.Options.Padding or 4),
                PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)}, row)
            if selectable then row.Activated:Connect(function() self:Select(value) end) end
            table.insert(self.Rows, {Value = value, Instance = row})
        end
        self:FilterList()
    end
    local function setupList(control)
        local height = control.Options.Height or 170
        local searchHeight = control.Options.Search and 30 or 0
        local root = make("Frame", {Name = "SiffReList", Size = UDim2.new(1, 0, 0, height + searchHeight),
            BackgroundTransparency = 1}, parking)
        if control.Options.Search then
            control.SearchBox = styledText("TextBox", {Name = "Search", Text = "", PlaceholderText = "Search",
                ClearTextOnFocus = false, BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(39, 41, 46),
                Size = UDim2.new(1, 0, 0, 25)}, root)
            connect(control.SearchBox:GetPropertyChangedSignal("Text"), function() control:FilterList() end)
        end
        local holder = make("ScrollingFrame", {Name = "Holder", Size = UDim2.new(1, 0, 0, height),
            Position = UDim2.fromOffset(0, searchHeight), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(27, 29, 33), BorderSizePixel = 0, ScrollBarThickness = 4,
            ScrollingDirection = Enum.ScrollingDirection.Y}, root)
        make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, holder)
        control.Root = root
        control.Items = {Holder = {Instance = holder}}
        control:RebuildList()
    end

    local function newControl(section, kind, options)
        options = options or {}
        local control = setmetatable({ID = id(), Kind = kind, Name = options.Name or "", Options = options,
            Section = section, Visible = true, Values = table.clone(options.Items or {}), Items = {}}, Control)
        table.insert(section.Controls, control)
        table.insert(UI.Controls, control)
        if kind ~= "Button" and kind ~= "Label" and kind ~= "Divider" then
            local value = normalize(control, options.Default)
            local group = options.Flag and UI.Groups[options.Flag]
            if group then
                assert(group.Kind == kind, "SiffRe: incompatible duplicate flag " .. options.Flag)
            else
                group = {State = state(value), Controls = {}, Kind = kind}
                if options.Flag then UI.Groups[options.Flag] = group end
                group.State:onChange(function(newValue)
                    if options.Flag then UI.Flags[options.Flag] = copy(newValue) end
                    for _, member in ipairs(group.Controls) do
                        if member.Bind then member.Bind.Toggled = newValue == true end
                        if member.Kind == "List" then member:FilterList() end
                        dispatch(member, copy(newValue))
                    end
                end)
            end
            control.State = group.State
            table.insert(group.Controls, control)
            if options.Flag then
                UI.Flags[options.Flag] = copy(control.State.value)
                UI.SetFlags[options.Flag] = function(newValue) control:Set(newValue) end
            end
        end
        if kind == "List" then setupList(control) end
        return control
    end
    for _, kind in ipairs({"Toggle", "Slider", "Dropdown", "Colorpicker", "Button", "Label", "Divider", "List"}) do
        Section[kind] = function(self, options) return newControl(self, kind, options) end
    end
    function Control:Colorpicker(options)
        self.Attachment = self.Section:Colorpicker(options)
        return self.Attachment
    end
    function UI:SetToggleGroupValue(flag, value)
        local group = self.Groups[flag]
        if group and group.Kind == "Toggle" then group.State:set(value == true) end
    end
    function Control:Keybind(options)
        options = options or {}
        local toggle = self
        local binding = {ID = id(), Name = options.Name or self.Name, Options = options, Toggle = self,
            State = state(keyName(options.Default)), Mode = options.Mode or "Toggle", Toggled = self:GetValue() == true}
        self.Bind = binding
        function binding:Set(value) self.State:set(keyName(value)); return self end
        function binding:GetValue() return self.State.value end
        function binding:SetMode(mode)
            if mode then self.Mode = mode end
            if self.Mode == "Always" then self.Toggled = true end
            if self.Toggled ~= toggle:GetValue() then
                if self.Options.Callback then dispatch(self, self.Toggled) else toggle:Set(self.Toggled) end
            end
        end
        function binding:Trigger()
            self.Toggled = self.Mode == "Hold" or self.Mode == "Always" or not toggle:GetValue()
            if self.Options.Callback then dispatch(self, self.Toggled) else toggle:Set(self.Toggled) end
        end
        binding.State:onChange(function(value)
            if options.Flag then UI.Flags[options.Flag] = value end
        end)
        if options.Flag then
            UI.Flags[options.Flag] = binding.State.value
            UI.SetFlags[options.Flag] = function(value) binding:Set(value) end
        end
        Rere.RegisterKeybind(binding.State, function() binding:Trigger() end, binding.Name)
        table.insert(UI.Binds, binding)
        return binding
    end
    connect(UIS.InputEnded, function(input)
        for _, binding in ipairs(UI.Binds) do
            if binding.Mode == "Hold" and binding.State.value == input.KeyCode.Name then
                binding.Toggled = false
                if binding.Options.Callback then dispatch(binding, false) else binding.Toggle:Set(false) end
            end
        end
    end)

    function UI:Window(options)
        options = options or {}
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local size = options.Size or Vector2.new(math.min(760, viewport.X - 24), math.min(640, viewport.Y - 60))
        if typeof(size) == "UDim2" then size = Vector2.new(size.X.Offset, size.Y.Offset) end
        local window = setmetatable({ID = id(), Name = options.Name or "SiffRe", Options = options, Pages = {},
            Size = state(size), Position = state(Vector2.new(math.max(12, (viewport.X - size.X) / 2), 32)),
            Open = state(true), TabIndex = state(1), Ready = false}, Window)
        table.insert(self.Windows, window)
        return window
    end
    function Window:Page(options)
        local page = setmetatable({ID = id(), Name = options.Name or "Page", Sections = {}, Window = self,
            Open = state(#self.Pages == 0)}, Page)
        table.insert(self.Pages, page)
        return page
    end
    function Window:SelectPage(name)
        for index, page in ipairs(self.Pages) do
            if page.Name == name or index == name then
                for _, other in ipairs(self.Pages) do other.Open:set(other == page) end
                self.TabIndex:set(index)
                return page
            end
        end
    end
    function Page:Section(options)
        local section = setmetatable({ID = id(), Name = options.Name or "", Side = options.Side or 1,
            Controls = {}, Page = self}, Section)
        table.insert(self.Sections, section)
        return section
    end
    function Window:KeybindList()
        if self.BindList then return self.BindList end
        local list = {Visible = false, Open = state(false), Size = state(Vector2.new(240, 200)), ID = id()}
        function list:SetVisible(visible) self.Visible = visible ~= false; self.Open:set(self.Visible) end
        self.BindList = list
        return list
    end
    function Window:SetVisible(visible) self.Open:set(visible ~= false) end
    function Window:SetTitle(name) self.Name = tostring(name) end
    function Window:Init()
        if self.Ready then return self end
        self.Ready = true
        UI:Init()
        for _, page in ipairs(self.Pages) do
            for _, section in ipairs(page.Sections) do
                for _, control in ipairs(section.Controls) do
                    if control.State then control:CallFunction() end
                end
            end
        end
        return self
    end

    function UI:Notification(message, duration, color)
        if not self.Notifications then
            self.Notifications = Notifications.new({Parent = parent, Name = "SiffReNotifications", Width = 340})
        end
        return self.Notifications:Notify({Title = "SiffRe", Text = tostring(message), Duration = duration or 4,
            Kind = "Info", Color = color})
    end
    function UI:ViewportWindow(options)
        options = options or {}
        local size = options.Size or UDim2.fromOffset(315, 335)
        local screen = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local pos = options.Position or UDim2.fromOffset(30, 70)
        local viewport = make("ViewportFrame", {Name = "SiffReViewport", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(25, 27, 31), BorderSizePixel = 0,
            Ambient = Color3.fromRGB(200, 200, 200), LightColor = Color3.new(1, 1, 1)}, parking)
        local world = make("WorldModel", {Name = "World"}, viewport)
        local camera = make("Camera", {Name = "Camera", FieldOfView = 50}, viewport)
        viewport.CurrentCamera = camera
        local value = {ID = id(), Name = options.Name or "Player Viewer", Root = viewport,
            Open = state(options.Visible ~= false), Size = state(Vector2.new(size.X.Offset, size.Y.Offset)),
            Position = state(Vector2.new(pos.X.Scale * screen.X + pos.X.Offset, pos.Y.Scale * screen.Y + pos.Y.Offset)),
            Items = {Viewport = {Instance = viewport}, World = {Instance = world}, Camera = {Instance = camera}}}
        function value:Clear() world:ClearAllChildren() end
        function value:SetTitle(name) self.Name = tostring(name) end
        function value:SetVisible(visible) self.Open:set(visible ~= false) end
        function value:Destroy() self:Clear(); self.Open:set(false); self.Removed = true end
        table.insert(self.Viewports, value)
        return value
    end

    -- Keep live list, WorldModel and Camera instances stable across redraws and tab changes.
    local hosts = {}
    Rere.Internal.WidgetConstructor("SiffReColumns", {
        hasState = false, hasChildren = true, Args = {Columns = 1}, Events = {},
        Generate = function()
            local root = make("Frame", {Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1}, nil)
            make("UIListLayout", {Name = "Layout", SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 16)}, root)
            for side = 1, 2 do
                make("Frame", {Name = "Side" .. side, LayoutOrder = side, AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.new(0.5, -8, 0, 0), BackgroundTransparency = 1}, root)
            end
            return root
        end,
        Update = function(widget)
            local stacked = widget.arguments.Columns == 1
            widget.Instance.Layout.FillDirection = stacked and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
            for side = 1, 2 do
                widget.Instance["Side" .. side].Size = UDim2.new(stacked and 1 or 0.5, stacked and 0 or -8, 0, 0)
            end
        end,
        ChildAdded = function(widget, child)
            return widget.Instance[string.sub(child.ID, -1) == "2" and "Side2" or "Side1"]
        end,
        Discard = function(widget) widget.Instance:Destroy() end,
    })
    Rere.Internal.WidgetConstructor("SiffReHost", {
        hasState = false, hasChildren = false, Args = {ID = 1, Height = 2}, Events = {},
        Generate = function() return make("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0}, nil) end,
        Update = function(widget)
            widget.Instance.Size = UDim2.new(1, 0, 0, widget.arguments.Height)
            local object = hosts[widget.arguments.ID]
            if object then object.Parent = widget.Instance end
        end,
        Discard = function(widget)
            local object = hosts[widget.arguments.ID]
            if object and UI.Alive then object.Parent = parking end
            widget.Instance:Destroy()
        end,
    })
    local function host(object, key, height)
        hosts[key] = object
        Rere.SetNextWidgetID(key .. "/host")
        return Rere.Internal._Insert("SiffReHost", {key, height})
    end
    local function visible(control)
        if not control.Visible or control.Removed then return false end
        local dependency = control.Options.DependsOn
        if not dependency then return true end
        if type(dependency) == "function" then return dependency(UI.Flags) == true end
        return UI.Flags[dependency] == true
    end
    local function renderControl(control)
        local options, kind = control.Options, control.Kind
        Rere.PushId(control.ID)
        Rere.SetNextWidgetID(control.ID .. "/group")
        local group = Rere.Group()
        group.Instance.Visible = visible(control)
        if kind == "Toggle" then
            if control.Bind then
                Rere.Toggle({control.Name}, {isChecked = control.State, keybind = control.Bind.State})
                Rere.RegisterKeybind(control.Bind.State, function() control.Bind:Trigger() end, control.Bind.Name)
            else
                Rere.Checkbox({control.Name}, {isChecked = control.State})
            end
        elseif kind == "Slider" then
            Rere.Text({control.Name})
            local step = options.Decimals or 1
            local digits = 0
            while digits < 5 and math.abs(step * 10 ^ digits - math.round(step * 10 ^ digits)) > 0.000001 do digits += 1 end
            local suffix = string.gsub(options.Suffix or "", "%%", "%%%%")
            Rere.SliderNum({"", step, options.Min or 0, options.Max or 100, "%0." .. digits .. "f" .. suffix}, {number = control.State})
        elseif kind == "Dropdown" then
            Rere.Text({control.Name})
            if not control.Preview then control.Preview = state("") end
            control.Preview:set(control:GetValueString() ~= "" and control:GetValueString() or "None")
            local combo = Rere.Combo({""}, {index = control.Preview})
            for index, value in ipairs(control.Values) do
                Rere.PushId(tostring(index))
                control.SelectionStates = control.SelectionStates or {}
                local optionState = control.SelectionStates[value]
                if not optionState then
                    optionState = state(selected(control, value))
                    control.SelectionStates[value] = optionState
                end
                optionState:set(selected(control, value))
                local item = Rere.Selectable({tostring(value), nil, true}, {index = optionState})
                if item.clicked() then
                    control:Select(value)
                    if not options.Multi then combo.state.isOpened:set(false) end
                end
                Rere.PopId()
            end
            Rere.End()
        elseif kind == "Colorpicker" then
            Rere.Text({control.Name})
            Rere.InputColor3({""}, {color = control.State})
        elseif kind == "Button" then
            if Rere.Button({control.Name}).clicked() then dispatch(control) end
        elseif kind == "Label" then
            if not control.Attachment then Rere.TextWrapped({control.Name}) end
        elseif kind == "Divider" then
            Rere.Separator()
        elseif kind == "List" then
            if control.Name ~= "" then Rere.Text({control.Name}) end
            host(control.Root, control.ID, control.Options.Height and control.Options.Height + (options.Search and 30 or 0) or 200)
        end
        Rere.End()
        Rere.PopId()
    end
    local function renderWindow(window)
        Rere.PushId(window.ID)
        Rere.SetNextWidgetID(window.ID)
        Rere.Window({window.Name}, {size = window.Size, position = window.Position, isOpened = window.Open})
        Rere.TabBar({}, {index = window.TabIndex})
        for _, page in ipairs(window.Pages) do
            Rere.PushId(page.ID)
            Rere.Tab({page.Name, false}, {isOpened = page.Open})
            local columns = window.Size.value.X < 620 and 1 or 2
            Rere.SetNextWidgetID(page.ID .. "/columns")
            Rere.Internal._Insert("SiffReColumns", {columns})
            for side = 1, 2 do
                Rere.SetNextWidgetID(page.ID .. "/side/" .. side)
                Rere.Group()
                for _, section in ipairs(page.Sections) do
                    if section.Side == side then
                        Rere.PushId(section.ID)
                        Rere.Text({section.Name, false, Color3.fromRGB(105, 190, 177)})
                        Rere.Separator()
                        for _, control in ipairs(section.Controls) do renderControl(control) end
                        Rere.Separator()
                        Rere.PopId()
                    end
                end
                Rere.End()
            end
            Rere.End()
            Rere.End()
            Rere.PopId()
        end
        Rere.End()
        if window.Options.FooterText then Rere.TextWrapped({window.Options.FooterText}) end
        if window.BindList then
            if Rere.Checkbox({"Keybinds"}, {isChecked = window.BindList.Open}).checked() then window.BindList.Visible = true end
        end
        Rere.End()
        Rere.PopId()
        if window.BindList then
            local list = window.BindList
            Rere.SetNextWidgetID(list.ID)
            Rere.Window({"Keybinds"}, {size = list.Size, isOpened = list.Open})
            for _, binding in ipairs(UI.Binds) do
                Rere.Text({binding.Name .. "  [" .. binding.State.value .. "]  " .. (binding.Toggle:GetValue() and "On" or "Off")})
            end
            Rere.End()
        end
    end
    function UI:Init()
        if self.Started then return self end
        self.Started = true
        Rere.UpdateGlobalConfig({TextSize = 14, TextFont = Font.fromEnum(Enum.Font.Arial),
            ItemWidth = UDim.new(1, 0), ContentWidth = UDim.new(1, -8),
            TitleBgActiveColor = Color3.fromRGB(43, 53, 53), FrameBgColor = Color3.fromRGB(45, 47, 52),
            ButtonColor = Color3.fromRGB(53, 68, 70), TabActiveColor = Color3.fromRGB(47, 92, 84),
            WindowRounding = 4, FrameRounding = 3, WindowPadding = Vector2.new(12, 10),
            ItemSpacing = Vector2.new(8, 7), CellPadding = Vector2.new(8, 5)})
        Rere.Init(parent)
        local menuKey = state("RightShift")
        Rere.RegisterKeybind(menuKey, function()
            for _, window in ipairs(self.Windows) do window:SetVisible(not window.Open.value) end
        end, "SiffRe menu")
        self.DisconnectRender = Rere:Connect(function()
            for _, window in ipairs(self.Windows) do if window.Ready then renderWindow(window) end end
            for _, viewport in ipairs(self.Viewports) do
                if not viewport.Removed then
                    Rere.SetNextWidgetID(viewport.ID)
                    Rere.Window({viewport.Name}, {size = viewport.Size, position = viewport.Position, isOpened = viewport.Open})
                    host(viewport.Root, viewport.ID, math.max(80, viewport.Size.value.Y - 55))
                    Rere.End()
                end
            end
        end)
        return self
    end
    function UI:Destroy()
        if not self.Alive then return end
        self.Alive = false
        for _, connection in ipairs(self.Connections) do connection:Disconnect() end
        table.clear(self.Connections)
        if self.DisconnectRender then self.DisconnectRender() end
        if self.Notifications then self.Notifications:Destroy() end
        Rere.Shutdown()
        parking:Destroy()
        if environment.SiffRe == self then environment.SiffRe = nil end
    end
    UI.Unload = UI.Destroy
    return UI
end
