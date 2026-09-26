---
title: 手动安装
editLink: true
---

<script setup>
import { Info24Regular, QuestionCircle24Regular, ErrorCircle24Regular } from '@vicons/fluent';
</script>

# 手动安装 {#title}

<DocProp>
  <template #last-edit>2026.09.19</template>
  <template #est-time>20 ~ 40 分钟</template>
  <template #difficulty>进阶</template>
</DocProp>

<ClientOnlyNAlert title="建议先看完这一段再决定" type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  手动安装是把「一键安装器」自动做的事全部手工复现一遍, <b>明显更慢, 也更容易出错</b>, 需要一定的技术基础。
  如果您只是想用上 HugoAura, 请使用 <a href="/userGuide/installation/autoInstall">一键安装</a> (双击运行, 约 3 ~ 5 分钟)。
</ClientOnlyNAlert>

本教程面向: 喜欢 **Build from source** 的用户, 以及无法运行安装器的场景 (杀软拦截, Windows 7, 需要完全掌控每一步)。

整个过程需要 **管理员权限** 的终端 (命令提示符 / PowerShell)。

## 开始之前: 一键安装 vs 手动安装 {#comparison}

| 对比项 | 一键安装 | 手动安装 (本教程) |
| --- | --- | --- |
| 需要的常识 | 从浏览器下载文件, 双击运行 | 从 GitHub 下载源码或 `git clone`, 使用 NPM, 使用 VSCode, 使用命令提示符 |
| 预估耗时 | 约 3 ~ 5 分钟 | 约 20 ~ 40 分钟 |
| 阅读难度 | 入门 | 进阶 |
| 是否需要装工具链 | 否 | 是 (Git, Node.js, 编辑器, asar 工具) |
| 出错风险 | 低 (失败有日志, 自动回退下载源) | 较高 (补丁匹配, 文件占用都要自己处理) |

## 0. 原理速览 {#principle}

安装器本质上只做 8 件事, 手动就是把这 8 步复现一遍:

1. 找到希沃管家的 `resources` 目录
2. 获取 `core.zip` (注入核心) 和 `aura.zip` (Aura 本体)
3. 解压两者
4. 卸载希沃的文件系统过滤驱动 `SeewoKeLiteLady`
5. 把 aura 内容放到 `resources\aura`
6. **解包 `app.asar` → 改 `main.js` → 塞入 core 文件 → 重新打包**
7. 置空 `Verify.json`, 用新 asar 替换旧 `app.asar`
8. 把版本信息写进注册表 (可选, 仅用于安装器自身识别)

## 1. 前置准备 {#preparation}

### 1.1 需要的工具 {#preparation-tools}

<ClientOnlyNAlert title="这套流程需要一点技术常识" type="info">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  本教程假定您能自行完成: 从 GitHub 下载源码或 <code>git clone</code>, 使用 NPM 安装依赖, 使用 VSCode 编辑文件, 以及以管理员身份使用命令提示符。
</ClientOnlyNAlert>

| 工具 | 用途 | 是否必需 |
| --- | --- | --- |
| **Git** | `git clone` 上游源码仓库 (也可改用网页上的 Download ZIP 代替) | 走源码路线必需 |
| **Node.js + NPM** | 安装 `@electron/asar` (asar 打包工具); `npm install` 安装仓库开发依赖 | 必需 |
| **VSCode** (或任意文本编辑器) | 编辑 `main.js` 的 4 处补丁; 可选: 附加调试器 | 必需 (编辑器) |
| **管理员命令提示符 / PowerShell** | 执行本教程全部命令, 卸载驱动, 替换文件 | 必需 |
| **asar CLI** | 解包 / 重新打包 `app.asar` | 必需 |

另外确认设备上 **希沃管家 (SeewoServiceAssistant)** 已安装, 并建议先更新到 [e.seewo.com](https://e.seewo.com/) 上的最新版——受注入技术限制, HugoAura 只对最新版管家提供支持。

### 1.2 安装工具链 {#preparation-toolchain}

```powershell
# 已有可跳过
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Microsoft.VisualStudioCode -e

# 安装 asar 打包工具 (官方 @electron/asar)
npm i -g @electron/asar
asar --version
```

### 1.3 定位希沃管家目录 {#preparation-locate}

安装器使用通配符匹配, 多个匹配时取最后一个 (即版本号最大的那个):

```powershell
$RES = (Get-Item "C:\Program Files (x86)\Seewo\SeewoService\SeewoService_*\SeewoServiceAssistant\resources").FullName
$RES
```

若报错说明未装希沃管家, 或安装路径不在默认位置 (那就手动找到 `...\SeewoServiceAssistant\resources` 目录并赋值给 `$RES`)。

## 2. 获取资源文件 (二选一) {#download-assets}

HugoAura 的注入需要两份资源, 上游仓库里它们就是两个目录:

- `aura.zip` = 仓库 `src/aura/` 的打包, **内容整体要放到 `resources\aura`**
- `core.zip` = 仓库 `src/core/` 的打包, **内含 `hook.js`, `preload.js`, `zeron.js`**, 要塞进 asar 包

### 路线 A: 从源码构建 (git clone) {#download-assets-source}

```powershell
git clone https://github.com/blingbling-bow/HugoAura-Enhanced.git C:\AuraSrc
# 网络受限时可套用镜像前缀, 例如:
# git clone https://cdn.gh-proxy.org/https://github.com/blingbling-bow/HugoAura-Enhanced.git C:\AuraSrc

cd C:\AuraSrc
npm install    # 可选: 安装 electron 等开发依赖, 仅用于本地调试, 不影响安装
```

仓库默认分支为 `dev`, clone 下来的就是最新源码 (等价于最新的 CI 构建)。无需任何编译或打包步骤——直接使用:

```powershell
$AURA_SRC = "C:\AuraSrc\src\aura"
$CORE_SRC = "C:\AuraSrc\src\core"
```

### 路线 B: 下载 Release 资源包 {#download-assets-release}

到 [HugoAura-Enhanced Releases](https://github.com/blingbling-bow/HugoAura-Enhanced/releases) 下载对应 tag 的 `core.zip` 和 `aura.zip` (一般推荐 CI 版, 与一般软件不同, 稳定版不一定能良好兼容最新版管家)。国内可套用镜像:

```powershell
$tag    = "v0.2.0-rc2"                                          # 按需替换
$mirror = "https://cdn.gh-proxy.org/https://github.com"          # 也可换 axisnow.gh-proxy.org / git.yylx.win
$base   = "$mirror/blingbling-bow/HugoAura-Enhanced/releases/download/$tag"

New-Item -ItemType Directory -Force C:\AuraManual | Out-Null
Invoke-WebRequest "$base/core.zip" -OutFile C:\AuraManual\core.zip
Invoke-WebRequest "$base/aura.zip" -OutFile C:\AuraManual\aura.zip
```

可选校验 (一键安装器会做字节数 + SHA256 双重校验, 手动时建议至少核对一次):

```powershell
$api  = "https://api.github.com/repos/blingbling-bow/HugoAura-Enhanced/releases/tags/$tag"
$json = Invoke-RestMethod $api
$json.assets | Where-Object name -in 'core.zip','aura.zip' | Select-Object name, digest
Get-FileHash C:\AuraManual\core.zip, C:\AuraManual\aura.zip -Algorithm SHA256
```

## 3. 整理出待安装内容 {#extract}

**路线 B** 需要解压; **路线 A** 直接指向源码目录即可。

```powershell
# 路线 B 才需要执行
Expand-Archive C:\AuraManual\core.zip -DestinationPath C:\AuraManual\core -Force
Expand-Archive C:\AuraManual\aura.zip -DestinationPath C:\AuraManual\aura -Force
$AURA_SRC = "C:\AuraManual\aura"
$CORE_SRC = "C:\AuraManual\core"
```

核对形态是否正确:

```powershell
Get-ChildItem $AURA_SRC          # 应看到 init\、jsRewrite\、mainProcess\ 等
Get-ChildItem $CORE_SRC          # 应看到 hook.js、preload.js、zeron.js
```

- `$AURA_SRC` 这一层内容整体就是最终的 `resources\aura`, **不要再嵌套一层 `aura`**

## 4. 卸载过滤驱动 + 结束希沃进程 {#unload-driver}

```powershell
fltmc unload SeewoKeLiteLady

taskkill /f /im SeewoServiceAssistant.exe
taskkill /f /im SeewoCore.exe
taskkill /f /im SeewoAbility.exe
```

- `fltmc unload` 失败通常说明驱动未加载, 可继续; 但若后续写入报「拒绝访问 / 被占用」, 基本就是它或进程没清干净
- 安装器会在整个安装过程中 **每 0.5 秒** 循环结束这三个进程。手动操作时, 建议在第 6 步替换文件前把上面三条 `taskkill` 再重复执行几次

## 5. 放置 aura 目录 {#place-aura}

```powershell
# 首次安装 ($RES\aura 不存在)
robocopy $AURA_SRC "$RES\aura" /E

# 升级 ($RES\aura 已存在): 先清空再复制, /MIR 会自动删除多余文件
robocopy $AURA_SRC "$RES\aura" /MIR
```

<ClientOnlyNAlert title="升级场景的关键区别" type="info">
  <template #icon>
    <Info24Regular />
  </template>
  安装器检测到 <code>aura</code> 目录已存在时, 会改用 <b><code>app.asar.bak</code></b> 而不是 <code>app.asar</code> 作为打补丁的输入。
  原因是当前 <code>app.asar</code> 已经被 patch 过, 补丁锚点已改变, 再次打补丁会失败。所以第 6 步的输入路径要跟着换。
</ClientOnlyNAlert>

## 6. 打包并替换 app.asar {#patch-asar}

### 6.1 备份原始 ASAR (首次安装必做) {#patch-asar-backup}

```powershell
if (-not (Test-Path "$RES\app.asar.bak")) {
    Copy-Item "$RES\app.asar" "$RES\app.asar.bak" -Force
}
```

`app.asar.bak` 是「原版纯净包」, 后续升级都靠它复原后再打补丁, **不要修改或删除它**。

### 6.2 解包 {#patch-asar-extract}

```powershell
# 升级场景用 bak, 首次安装用 app.asar
$SRC = if (Test-Path "$RES\app.asar.bak") { "$RES\app.asar.bak" } else { "$RES\app.asar" }

Remove-Item C:\AuraManual\asar -Recurse -Force -ErrorAction SilentlyContinue
asar extract "$SRC" C:\AuraManual\asar
```

用 **VSCode** (或其他编辑器) 打开 `C:\AuraManual\asar\main.js`, **精确**做以下 4 处修改 (改完逐个 `Ctrl+F` 确认):

**① 文件最开头插入一行**

```javascript
const hook = require("./hook.js");
```

**② 注入 zeron (查找)**

```
o.l=!0,o.exports}n.m=e
```

替换为:

```
o.l=!0,o.exports};const zeron = require("./zeron.js");n = zeron(n);n.m=e
```

**③ 注入 hook 调用 (查找)**

```
let f=new s(Object.assign({},{transparent:!0,
```

替换为 (注意前面多一个分号):

```
;hook({ central: n, windowName: this.wname, config: c });let f=new s(Object.assign({},{transparent:!0,
```

**④ 挂载 preload (查找)**

```
enableRemoteModule:!0,devTools:!!c.canOpenDevTool},parent:this.parentWindow||null
```

替换为 (在原串末尾插入 `preload` 字段):

```
enableRemoteModule:!0,devTools:!!c.canOpenDevTool,preload: __dirname + "\\preload.js"},parent:this.parentWindow||null
```

<ClientOnlyNAlert title="这 4 处补丁必须逐条核对" type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  哪一处没匹配上, 最终都会导致 Aura 加载不出来。一键安装器在匹配失败时会直接报错中止, 手动时没人帮您兜底。
</ClientOnlyNAlert>

### 6.3 把 core 文件放进解包目录 {#patch-asar-copy-core}

```powershell
Copy-Item "$CORE_SRC\hook.js", "$CORE_SRC\preload.js", "$CORE_SRC\zeron.js" C:\AuraManual\asar\ -Force
```

这三个文件必须在 **asar 包内** (和 `main.js` 同级), 因为 `main.js` 里是用 `require("./hook.js")` 相对引用的。

### 6.4 重新打包 {#patch-asar-pack}

```powershell
asar pack C:\AuraManual\asar C:\AuraManual\app-patched.asar
```

<ClientOnlyNAlert title="如果原包里存在未打包文件" type="info">
  <template #icon>
    <Info24Regular />
  </template>
  若 <code>resources</code> 下存在 <code>app.asar.unpacked</code> 目录, 说明原包存在未打包文件, 重新打包时需保持同样的解包配置:
</ClientOnlyNAlert>

```powershell
asar pack C:\AuraManual\asar C:\AuraManual\app-patched.asar --unpack-dir "对应的目录名"
```

一键安装器内部会自动处理这一点, 手动时需要自己确认。

### 6.5 置空校验数据 {#patch-asar-verify}

```powershell
$verify = Join-Path (Split-Path $RES -Parent) "Verify.json"   # 即 SeewoServiceAssistant\Verify.json
if (Test-Path $verify) { Set-Content -Path $verify -Value "[]" -Encoding UTF8 -NoNewline }
```

### 6.6 替换 {#patch-asar-replace}

```powershell
taskkill /f /im SeewoServiceAssistant.exe
taskkill /f /im SeewoCore.exe
taskkill /f /im SeewoAbility.exe
Remove-Item "$RES\app.asar" -Force
Move-Item C:\AuraManual\app-patched.asar "$RES\app.asar" -Force
```

若删除被拒, 说明进程或过滤驱动仍在占用, 回到第 4 步重做。

## 7. 写入注册表 (可选) {#registry}

仅用于安装器 / 其他工具识别当前安装版本, 跳过不影响运行:

```powershell
$key = "HKCU:\SOFTWARE\HugoAura"
New-Item -Path $key -Force | Out-Null
Set-ItemProperty $key -Name Version     -Value $tag          # 走源码路线时可填 "local"
Set-ItemProperty $key -Name InstallTime -Value (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
```

## 8. 验证 {#verify}

```powershell
Test-Path "$RES\aura"                    # True
Test-Path "$RES\app.asar"                # True
Test-Path "$RES\app.asar.bak"            # True (原版备份)
asar list "$RES\app.asar" | Select-String "hook.js|zeron.js|preload.js"   # 三个都在
```

之后启动希沃管家, Aura 的界面 / 注入即应生效。

## 9. 卸载 / 回滚 {#uninstall}

```powershell
fltmc unload SeewoKeLiteLady
taskkill /f /im SeewoServiceAssistant.exe
taskkill /f /im SeewoCore.exe
taskkill /f /im SeewoAbility.exe

Remove-Item "$RES\aura" -Recurse -Force
if (Test-Path "$RES\app.asar.bak") { Move-Item "$RES\app.asar.bak" "$RES\app.asar" -Force }
Remove-Item "HKCU:\SOFTWARE\HugoAura" -Recurse -Force
Remove-Item C:\AuraManual, C:\AuraSrc -Recurse -Force -ErrorAction SilentlyContinue
```

## 10. 常见问题 {#faq}

| 现象 | 原因 / 处理 |
| --- | --- |
| 删除 `app.asar` 报拒绝访问 | 过滤驱动未卸载或进程未清干净, 重做第 4 步 |
| 管家启动后无变化 | `main.js` 4 处补丁有漏改, 或 `hook.js` / `zeron.js` / `preload.js` 没放进 asar 包内 |
| `asar extract` 报错 | 换用官方 `@electron/asar`; 希沃这个包结构较特殊, 一键安装器专门为它打过适配补丁 |
| 升级后失效 | 必须用 `app.asar.bak` 作为补丁输入, 不能对已 patch 的 `app.asar` 二次打补丁 |
| 找不到 `Verify.json` | 正常, 该文件在部分版本不存在, 跳过即可 |
| `git clone` 卡住 / 失败 | 网络受限, 套镜像前缀, 或改用路线 B 下载 Release 资源包 |
| 手动装完发现很麻烦 | 这正是本教程开头建议优先使用一键安装的原因 |

## 附: 从源码调试 (可选) {#dev-tips}

上游仓库自带几个开发脚本 (位于 `scripts\`), 适合在 VSCode 里边改边试, 不用反复重打包:

| 脚本 | 作用 |
| --- | --- |
| `cd.bat` | 自动定位 `SeewoServiceAssistant` 目录并打开命令行 |
| `kad.bat` | 结束希沃进程, 删除 `app.asar`, 把 `app-unpacked` 目录直接部署为 `app.asar` (免打包热替换) |
| `kar.bat` | 结束希沃进程并以 `--inspect 9229 --aura-debug` 启动管家, 便于 VSCode 附加调试器 |

<ClientOnlyNAlert title="这些是开发者工具" type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  上述脚本会把未打包的目录当作 <code>app.asar</code> 使用, 仅建议在本机调试时使用。正式安装请按本教程第 6 步正常打包。
</ClientOnlyNAlert>
