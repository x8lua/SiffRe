# SiffRe

以 [Rere](https://github.com/x8lua/Rere) / [Iris](https://github.com/SirMallard/Iris) 為基礎，提供 SIFF 所需的 UI 呼叫介面。獨立發行，保留 MIT 授權及原作者資訊。

單一檔案 `src/SiffRe.lua` 已包含渲染引擎、相容層及通知，不需要另外下載 Rere，也不需要 Roblox Studio ModuleScript。

## 載入

```lua
local UI = assert(loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/x8lua/SiffRe/v1.0.0/src/SiffRe.lua"
)))()

local window = UI:Window({Name = "SiffRe", FooterText = "SiffRe 1.0.0"})
local main = window:Page({Name = "main"})
local section = main:Section({Name = "Settings", Side = 1})
section:Toggle({Name = "Enabled", Flag = "Enabled", Default = false, Callback = print})
window:Init()
```

`RightShift` 顯示或隱藏主視窗。視窗可拖曳、縮放；寬度小於 620 時，兩側區塊會改成單欄。重新載入 SiffRe 會清理前一個 SiffRe 實例；`UI:Destroy()` 或 `UI:Unload()` 也能手動清理。

## SIFF 相容介面

| 呼叫 | 行為 |
| --- | --- |
| `UI:Window(options)` | 建立主視窗，支援 `Name`、`FooterText`、`Size` |
| `window:Page(options)` | 建立分頁 |
| `page:Section(options)` | 建立區塊，`Side = 1 / 2` |
| `section:Toggle(options)` | 開關；同名 `Flag` 共用狀態並通知各自 Callback |
| `section:Slider(options)` | `Min`、`Max`、`Default`、`Suffix`；`Decimals` 是步距，例如 `0.5` |
| `section:Dropdown(options)` | `Items`、單選／`Multi` 多選、`Required` 至少一項 |
| `section:List(options)` | 可搜尋清單、動態刷新、可選項目、換行及固定高度 |
| `section:Label(options):Colorpicker(options)` | Color3 顏色選擇器 |
| `section:Button(options)` / `section:Divider(options)` | 按鈕與分隔線 |
| `toggle:Keybind(options)` | 按鍵擷取、重複按鍵確認、Toggle / Hold / Always 模式 |
| `window:KeybindList()` | 可顯示的快捷鍵列表 |
| `UI:Notification(text, seconds, color)` | 動畫通知，支援自訂提示顏色 |
| `UI:ViewportWindow(options)` | 獨立玩家預覽視窗，使用穩定的 ViewportFrame / WorldModel / Camera |
| `UI:SetToggleGroupValue(flag, value)` | 更新同名 Flag 的所有開關 |

控件支援 `Set`、`GetValue`、`GetValueString`、`CallFunction`、`SetVisible`；清單與下拉選單支援 `Refresh`。`DependsOn = "Flag"` 控制顯示。`UI.Flags` 可讀取目前值，`UI.SetFlags[flag](value)` 可套用值或由呼叫者覆寫。

預覽視窗提供 `Items.Viewport.Instance`、`Items.World.Instance`、`Items.Camera.Instance`，以及 `Clear`、`SetTitle`、`SetVisible`。清單提供 `Items.Holder.Instance`，可設定 `CanvasPosition`。切換分頁、隱藏視窗、切換單欄／雙欄不會替換這些實例。

Callback 在 `window:Init()` 初始化一次，之後在值改變時呼叫；執行於獨立 task，避免耗時 Callback 阻塞 Rere 的渲染。請將 Callback 中需要的狀態建立完成後再呼叫 `Init()`。

`IgnoreConfig` 為相容保留欄位；本版本沒有設定檔儲存或自動載入功能。相容範圍以 SIFF 使用的 UI API 為準。

## 範例與驗證

- `examples/basic.luau`：可直接執行的基本示例。
- `examples/siff-layout.luau`：4 個分頁、91 個控件的 SIFF 介面工廠；只包含 UI 宣告，不執行遊戲功能。
- `tests/runtime.luau`：在真實 Roblox 客戶端執行的 33 項相容性檢查。

```lua
local UI = assert(loadstring(game:HttpGet("https://raw.githubusercontent.com/x8lua/SiffRe/main/src/SiffRe.lua")))()
local build = assert(loadstring(game:HttpGet("https://raw.githubusercontent.com/x8lua/SiffRe/main/examples/siff-layout.luau")))()
local preview = build(UI)
```

本次驗證包含 Luau 0.740 完整編譯，以及 Real MCP 遊戲內的控件狀態、Callback、清單刷新、分頁切換、390 寬單欄排版、通知和預覽實例測試。UI 相容性測試不代表 SIFF 的遊戲功能已通過實戰驗證。

## 建置

```sh
node tools/build.mjs
```

`lib/` 是 Rere / Iris 引擎，`compat/SiffRe.luau` 是 SIFF 相容層，`vendor/RereNotify.luau` 是通知模組；建置結果為 `src/SiffRe.lua`。

上游來源：`x8lua/Rere` commit `51d998ba70fa56d0b98b1e3449b977332e334403`。Iris 原作者 Michael_48，維護者 SirMallard。授權詳見 `LICENSE.txt`。
