]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    warn("Player Hub: execute em um contexto local compatível.")
    return
end

local parent
pcall(function()
    if typeof(gethui) == "function" then
        parent = gethui()
    end
end)
if not parent then
    parent = player:WaitForChild("PlayerGui")
end

pcall(function()
    local old = parent:FindFirstChild("PlayerHubNeon")
    if old then old:Destroy() end
end)

local THEME = {
    bg = Color3.fromRGB(9, 10, 19),
    panel = Color3.fromRGB(17, 19, 34),
    panel2 = Color3.fromRGB(24, 27, 46),
    cyan = Color3.fromRGB(0, 225, 255),
    purple = Color3.fromRGB(155, 85, 255),
    white = Color3.fromRGB(235, 240, 255),
    muted = Color3.fromRGB(143, 151, 179),
    green = Color3.fromRGB(73, 255, 174),
    red = Color3.fromRGB(255, 91, 127)
}

local gui = Instance.new("ScreenGui")
gui.Name = "PlayerHubNeon"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local function make(className, props, parentObject)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do
        object[key] = value
    end
    object.Parent = parentObject
    return object
end

local function round(object, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, object)
end

local function outline(object, color, thickness, transparency)
    return make("UIStroke", {
        Color = color or THEME.purple,
        Thickness = thickness or 1,
        Transparency = transparency or 0.2
    }, object)
end

local function tween(object, duration, properties)
    local t = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    t:Play()
    return t
end

local main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(660, 470),
    BackgroundColor3 = THEME.bg,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true
}, gui)
round(main, 12)
local mainStroke = outline(main, THEME.purple, 2, 0.08)

local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 66),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0
}, main)
round(header, 12)
make("Frame", {
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0
}, header)

local title = make("TextLabel", {
    Position = UDim2.fromOffset(18, 9),
    Size = UDim2.new(1, -180, 0, 29),
    BackgroundTransparency = 1,
    Text = "PLAYER HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    TextColor3 = THEME.cyan,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

make("TextLabel", {
    Position = UDim2.fromOffset(20, 39),
    Size = UDim2.new(1, -180, 0, 15),
    BackgroundTransparency = 1,
    Text = "NEON OVERDRIVE  •  VISUAL DEMO",
    Font = Enum.Font.Code,
    TextSize = 10,
    TextColor3 = THEME.muted,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local status = make("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -112, 0, 22),
    Size = UDim2.fromOffset(105, 22),
    BackgroundTransparency = 1,
    Text = "● SYSTEM READY",
    Font = Enum.Font.Code,
    TextSize = 10,
    TextColor3 = THEME.green,
    TextXAlignment = Enum.TextXAlignment.Right
}, header)

local minButton = make("TextButton", {
    Name = "Minimize",
    Position = UDim2.new(1, -76, 0, 18),
    Size = UDim2.fromOffset(25, 27),
    BackgroundColor3 = THEME.bg,
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextColor3 = THEME.cyan,
    AutoButtonColor = true
}, header)
round(minButton, 6)

local closeButton = make("TextButton", {
    Name = "Close",
    Position = UDim2.new(1, -42, 0, 18),
    Size = UDim2.fromOffset(25, 27),
    BackgroundColor3 = THEME.bg,
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = THEME.red,
    AutoButtonColor = true
}, header)
round(closeButton, 6)

local sidebar = make("Frame", {
    Name = "Sidebar",
    Position = UDim2.fromOffset(12, 78),
    Size = UDim2.new(0, 158, 1, -90),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0
}, main)
round(sidebar, 9)
make("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, sidebar)

local content = make("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(182, 78),
    Size = UDim2.new(1, -194, 1, -90),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, main)
round(content, 9)

local pages, tabButtons = {}, {}
local tabNames = {"Combat", "Movement", "Teleport", "Macro", "Settings"}

local function createPage(name)
    local page = make("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = THEME.purple,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, content)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14)
    }, page)
    make("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)
    pages[name] = page
    return page
end

for _, name in ipairs(tabNames) do
    createPage(name)
    local tab = make("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 39),
        BackgroundColor3 = THEME.bg,
        BorderSizePixel = 0,
        Text = "  ◈   " .. name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = THEME.muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, sidebar)
    round(tab, 7)
    tabButtons[name] = tab
end

local function addLabel(parentObject, text, height, color, font, size)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, height or 26),
        BackgroundTransparency = 1,
        Text = text,
        Font = font or Enum.Font.GothamBold,
        TextSize = size or 15,
        TextColor3 = color or THEME.white,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true
    }, parentObject)
end

local function addButton(parentObject, text, callback)
    local button = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = THEME.bg,
        BorderSizePixel = 0,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = THEME.white,
        AutoButtonColor = false
    }, parentObject)
    round(button, 7)
    local line = outline(button, THEME.purple, 1, 0.22)
    button.MouseEnter:Connect(function()
        tween(button, 0.12, {BackgroundColor3 = THEME.panel2})
        tween(line, 0.12, {Transparency = 0})
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.12, {BackgroundColor3 = THEME.bg})
        tween(line, 0.12, {Transparency = 0.22})
    end)
    button.Activated:Connect(callback)
    return button
end

local function addToggle(parentObject, name, defaultValue)
    local enabled = defaultValue == true
    local button
    local function refresh()
        button.Text = (enabled and "●  ON    " or "○  OFF   ") .. name .. "  •  VISUAL"
        button.TextColor3 = enabled and THEME.cyan or THEME.white
    end
    button = addButton(parentObject, name, function()
        enabled = not enabled
        refresh()
    end)
    refresh()
    return function() return enabled end
end

local function addSlider(parentObject, name, minValue, maxValue, initial)
    local value = initial
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = THEME.bg,
        BorderSizePixel = 0
    }, parentObject)
    round(row, 7)
    addLabel(row, name, 23, THEME.white, Enum.Font.GothamMedium, 12).Position = UDim2.fromOffset(10, 3)
    local valueLabel = make("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 3),
        Size = UDim2.fromOffset(48, 23),
        BackgroundTransparency = 1,
        Text = tostring(value),
        Font = Enum.Font.Code,
        TextSize = 12,
        TextColor3 = THEME.cyan,
        TextXAlignment = Enum.TextXAlignment.Right
    }, row)
    local bar = make("Frame", {
        Position = UDim2.new(0, 10, 0, 34),
        Size = UDim2.new(1, -20, 0, 7),
        BackgroundColor3 = THEME.panel2,
        BorderSizePixel = 0
    }, row)
    round(bar, 4)
    local fill = make("Frame", {
        Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = THEME.purple,
        BorderSizePixel = 0
    }, bar)
    round(fill, 4)
    local hit = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, -9),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    }, bar)
    local dragging = false
    local function update(input)
        local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(minValue + (maxValue - minValue) * alpha + 0.5)
        valueLabel.Text = tostring(value)
        tween(fill, 0.06, {Size = UDim2.new(alpha, 0, 1, 0)})
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    hit.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- Combat page: UI toggles only
do
    local p = pages.Combat
    addLabel(p, "COMBAT MODULES", 28, THEME.cyan, Enum.Font.GothamBlack, 17)
    addLabel(p, "Demonstração visual; não mira nem ataca jogadores.", 35, THEME.muted, Enum.Font.Gotham, 11)
    addToggle(p, "Aim Lock indicator", false)
    addToggle(p, "ESP panel preview", false)
    addToggle(p, "Kill Aura indicator", false)
    addToggle(p, "Auto Click indicator", false)
    addToggle(p, "Auto Combo indicator", false)
    addSlider(p, "FOV preview", 30, 300, 120)
end

-- Movement page: visual settings only
do
    local p = pages.Movement
    addLabel(p, "MOVEMENT MODULES", 28, THEME.cyan, Enum.Font.GothamBlack, 17)
    addLabel(p, "Valores ilustrativos; não alteram a física do personagem.", 35, THEME.muted, Enum.Font.Gotham, 11)
    addToggle(p, "Speed HUD", false)
    addToggle(p, "Jump HUD", false)
    addToggle(p, "Dash indicator", false)
    addSlider(p, "Speed preview", 1, 100, 16)
    addSlider(p, "Jump preview", 1, 100, 20)
end

-- Teleport page: marker preview only
do
    local p = pages.Teleport
    addLabel(p, "TELEPORT / WAYPOINTS", 28, THEME.cyan, Enum.Font.GothamBlack, 16)
    addLabel(p, "Marcadores fictícios; nenhum teleporte é executado.", 36, THEME.muted, Enum.Font.Gotham, 11)
    local markerStatus = addLabel(p, "Waypoint: nenhum selecionado", 30, THEME.white, Enum.Font.Code, 11)
    addButton(p, "Selecionar marcador de demonstração", function()
        markerStatus.Text = "Waypoint: DEMO-01 selecionado"
        markerStatus.TextColor3 = THEME.green
    end)
    addButton(p, "Limpar marcador", function()
        markerStatus.Text = "Waypoint: nenhum selecionado"
        markerStatus.TextColor3 = THEME.white
    end)
end

-- Macro page: no synthetic input
do
    local p = pages.Macro
    addLabel(p, "MACRO LAB", 28, THEME.cyan, Enum.Font.GothamBlack, 17)
    addLabel(p, "O painel não grava nem envia entradas automáticas.", 36, THEME.muted, Enum.Font.Gotham, 11)
    local macroStatus = addLabel(p, "Status: idle", 28, THEME.white, Enum.Font.Code, 12)
    addButton(p, "Iniciar prévia", function()
        macroStatus.Text = "Status: preview running"
        macroStatus.TextColor3 = THEME.green
    end)
    addButton(p, "Parar prévia", function()
        macroStatus.Text = "Status: idle"
        macroStatus.TextColor3 = THEME.white
    end)
    addButton(p, "Limpar prévia", function()
        macroStatus.Text = "Status: cleared"
        macroStatus.TextColor3 = THEME.muted
    end)
end

-- Settings page
do
    local p = pages.Settings
    addLabel(p, "SYSTEM SETTINGS", 28, THEME.cyan, Enum.Font.GothamBlack, 17)
    addToggle(p, "Neon effects", true)
    addToggle(p, "Compact status panel", false)
    addButton(p, "Accent: cyan / purple", function()
        if title.TextColor3 == THEME.cyan then
            title.TextColor3 = THEME.purple
            mainStroke.Color = THEME.cyan
        else
            title.TextColor3 = THEME.cyan
            mainStroke.Color = THEME.purple
        end
    end)
    addButton(p, "Reset panel position", function()
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
    end)
    addButton(p, "Close Player Hub", function()
        gui:Destroy()
    end)
    addLabel(p, "Profiles: demo profile (session only)", 26, THEME.muted, Enum.Font.Code, 11)
end

local function selectTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = tabName == name
        local button = tabButtons[tabName]
        button.BackgroundColor3 = tabName == name and THEME.panel2 or THEME.bg
        button.TextColor3 = tabName == name and THEME.cyan or THEME.muted
    end
end

for _, name in ipairs(tabNames) do
    tabButtons[name].Activated:Connect(function()
        selectTab(name)
    end)
end
selectTab("Combat")

-- Drag window using header
local dragging, dragStart, startPosition = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
minButton.Activated:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(660, 66) or UDim2.fromOffset(660, 470)
    minButton.Text = minimized and "+" or "—"
end)

closeButton.Activated:Connect(function()
    gui:Destroy()
end)

-- Subtle header pulse
task.spawn(function()
    while gui.Parent do
        tween(title, 0.9, {TextColor3 = THEME.purple})
        task.wait(0.9)
        if not gui.Parent then break end
        tween(title, 0.9, {TextColor3 = THEME.cyan})
        task.wait(0.9)
    end
end)

print("Player Hub visual demo loaded.")
