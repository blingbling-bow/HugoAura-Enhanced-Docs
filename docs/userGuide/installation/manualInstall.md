---
title: 手动安装
editLink: true
---

# 手动安装 {#title}

<DocProp>
  <template #last-edit>2026.09.26</template>
  <template #est-time>20 ~ 40 分钟</template>
  <template #difficulty>进阶</template>
</DocProp>

适用于无法运行安装器（杀软拦截、Windows 7、想完全掌控过程）的场景。全过程需 **管理员权限** 的 PowerShell。

## 0. 原理速览 {#principle}

安装器本质上只做 8 件事，手动就是把这 8 步复现一遍：

1. 找到希沃管家的 `resources` 目录
2. 下载 `core.zip`（注入核心）和 `aura.zip`（Aura 本体）
3. 解压两者
4. 卸载希沃的文件系统过滤驱动 `SeewoKeLiteLady`
5. 把 aura 内容放到 `resources\aura`
6. **解包 `app.asar` → 改 `main.js` → 塞入 core 文件 → 重新打包**
7. 置空 `Verify.json`、用新 asar 替换旧 `app.asar`
8. 把版本信息写进注册表（可选，仅用于安装器自身识别）

## 1. 前置准备 {#preparation}

**必要环境**

- 希沃管家（SeewoServiceAssistant）已安装
- 管理员 PowerShell
- **Node.js**（用于 asar 打包，推荐官方 `@electron/asar`）

```powershell
# 确认 Node 可用
node -v
npm i -g @electron/asar
```

**定位安装目录**（安装器用通配符匹配，多个匹配时取最后一个，即版本号最大的那个）

```powershell
$RES = (Get-Item "C:\Program Files (x86)\Seewo\SeewoService\SeewoService_*\SeewoServiceAssistant\resources").FullName
$RES
```

若报错说明未装希沃管家，或安装路径不在默认位置（那就手动找到 `...\SeewoServiceAssistant\resources` 目录并赋值给 `$RES`）。

## 2. 下载资源文件 {#download-assets}

到 [HugoAura-Enhanced Releases](https://github.com/blingbling-bow/HugoAura-Enhanced/releases) 下载对应 tag 的 **`core.zip`** 和 **`aura.zip`**。国内可套用当前项目已实测的镜像：

```powershell
$tag    = "v0.2.0-rc2"                                          # 按需替换
$mirror = "https://cdn.gh-proxy.org/https://github.com"          # 也可换 axisnow.gh-proxy.org / git.yylx.win
$base   = "$mirror/blingbling-bow/HugoAura-Enhanced/releases/download/$tag"

New-Item -ItemType Directory -Force C:\AuraManual | Out-Null
Invoke-WebRequest "$base/core.zip" -OutFile C:\AuraManual\core.zip
Invoke-WebRequest "$base/aura.zip" -OutFile C:\AuraManual\aura.zip
```

可选校验（安装器会做字节数 + SHA256 双重校验）：

```powershell
$api  = "https://api.github.com/repos/blingbling-bow/HugoAura-Enhanced/releases/tags/$tag"
$json = Invoke-RestMethod $api
$json.assets | Where-Object name -in 'core.zip','aura.zip' | Select-Object name, digest
Get-FileHash C:\AuraManual\core.zip, C:\AuraManual\aura.zip -Algorithm SHA256
```

## 3. 解压 {#extract}

```powershell
Expand-Archive C:\AuraManual\core.zip -DestinationPath C:\AuraManual\core -Force
Expand-Archive C:\AuraManual\aura.zip -DestinationPath C:\AuraManual\aura -Force
```

解压后的正确形态：

- `C:\AuraManual\core\` → 直接就是 `hook.js`、`preload.js`、`zeron.js`
- `C:\AuraManual\aura\` → 直接就是 `init\`、`jsRewrite\`、`mainProcess\` 等（**这一层内容整体就是最终的 `resources\aura`**，不要再嵌套一层 `aura`）

## 4. 卸载过滤驱动 + 结束希沃进程 {#unload-driver}

```powershell
fltmc unload SeewoKeLiteLady

taskkill /f /im SeewoServiceAssistant.exe
taskkill /f /im SeewoCore.exe
taskkill /f /im SeewoAbility.exe
```

- `fltmc unload` 失败通常说明驱动未加载，可继续；但若后续写入报「拒绝访问 / 被占用」，基本就是它或进程没清干净
- 安装器会在整个安装过程中**每 0.5 秒**循环结束这三个进程。手动操作时，建议在第 6 步替换文件前把上面三条 `taskkill` 再重复执行几次

## 5. 放置 aura 目录 {#place-aura}

```powershell
# 首次安装（$RES\aura 不存在）
robocopy C:\AuraManual\aura "$RES\aura" /E

# 升级（$RES\aura 已存在）：先清空再复制，/MIR 会自动删除多余文件
robocopy C:\AuraManual\aura "$RES\aura" /MIR
```

> **升级场景的关键区别**：安装器检测到 `aura` 目录已存在时，会改用 **`app.asar.bak`** 而不是 `app.asar` 作为打补丁的输入。原因是当前 `app.asar` 已经被 patch 过，补丁锚点已改变，再次打补丁会失败。所以第 6 步的输入路径要跟着换。

## 6. 打包并替换 app.asar {#patch-asar}

### 6.1 备份原始 ASAR（首次安装必做） {#patch-asar-backup}

```powershell
if (-not (Test-Path "$RES\app.asar.bak")) {
    Copy-Item "$RES\app.asar" "$RES\app.asar.bak" -Force
}
```

`app.asar.bak` 是「原版纯净包」，后续升级都靠它复原后再打补丁，**不要修改或删除它**。

### 6.2 解包 {#patch-asar-extract}

```powershell
# 升级场景用 bak，首次安装用 app.asar
$SRC = if (Test-Path "$RES\app.asar.bak") { "$RES\app.asar.bak" } else { "$RES\app.asar" }

Remove-Item C:\AuraManual\asar -Recurse -Force -ErrorAction SilentlyContinue
asar extract "$SRC" C:\AuraManual\asar
```

用编辑器打开 `C:\AuraManual\asar\main.js`，**精确**做以下 4 处修改（建议用支持精确查找的编辑器，改完逐个 `Ctrl+F` 确认）：

**① 文件最开头插入一行**

```javascript
const hook = require("./hook.js");
```

**② 注入 zeron（查找）**

```
o.l=!0,o.exports}n.m=e
```

替换为：

```
o.l=!0,o.exports};const zeron = require("./zeron.js");n = zeron(n);n.m=e
```

**③ 注入 hook 调用（查找）**

```
let f=new s(Object.assign({},{transparent:!0,
```

替换为（注意前面多一个分号）：

```
;hook({ central: n, windowName: this.wname, config: c });let f=new s(Object.assign({},{transparent:!0,
```

**④ 挂载 preload（查找）**

```
enableRemoteModule:!0,devTools:!!c.canOpenDevTool},parent:this.parentWindow||null
```

替换为（在原串末尾插入 `preload` 字段）：

```
enableRemoteModule:!0,devTools:!!c.canOpenDevTool,preload: __dirname + "\\preload.js"},parent:this.parentWindow||null
```

> 这 4 处哪一处没匹配上，最终都会导致 Aura 加载不出来，务必逐条核对（安装器在匹配失败时会直接报错中止，手动时没人帮你兜底）。

### 6.3 把 core 文件放进解包目录 {#patch-asar-copy-core}

```powershell
Copy-Item C:\AuraManual\core\hook.js, C:\AuraManual\core\preload.js, C:\AuraManual\core\zeron.js C:\AuraManual\asar\ -Force
```

这三个文件必须在 **asar 包内**（和 `main.js` 同级），因为 `main.js` 里是用 `require("./hook.js")` 相对引用的。

### 6.4 重新打包 {#patch-asar-pack}

```powershell
asar pack C:\AuraManual\asar C:\AuraManual\app-patched.asar
```

> 若 `resources` 下存在 `app.asar.unpacked` 目录，说明原包含未打包文件，打包时需保持同样的解包配置：
>
> ```powershell
> asar pack C:\AuraManual\asar C:\AuraManual\app-patched.asar --unpack-dir "对应的目录名"
> ```
>
> 安装器内部会自动处理这一点，手动时需要自己确认。

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

若删除被拒，说明进程或过滤驱动仍在占用，回到第 4 步重做。

## 7. 写入注册表（可选） {#registry}

仅用于安装器 / 其他工具识别当前安装版本，跳过不影响运行：

```powershell
$key = "HKCU:\SOFTWARE\HugoAura"
New-Item -Path $key -Force | Out-Null
Set-ItemProperty $key -Name Version     -Value $tag
Set-ItemProperty $key -Name InstallTime -Value (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
```

## 8. 验证 {#verify}

```powershell
Test-Path "$RES\aura"                    # True
Test-Path "$RES\app.asar"                # True
Test-Path "$RES\app.asar.bak"            # True（原版备份）
asar list "$RES\app.asar" | Select-String "hook.js|zeron.js|preload.js"   # 三个都在
```

之后启动希沃管家，Aura 的界面 / 注入即应生效。

## 9. 卸载 / 回滚 {#uninstall}

```powershell
fltmc unload SeewoKeLiteLady
taskkill /f /im SeewoServiceAssistant.exe
taskkill /f /im SeewoCore.exe
taskkill /f /im SeewoAbility.exe

Remove-Item "$RES\aura" -Recurse -Force
if (Test-Path "$RES\app.asar.bak") { Move-Item "$RES\app.asar.bak" "$RES\app.asar" -Force }
Remove-Item "HKCU:\SOFTWARE\HugoAura" -Recurse -Force
Remove-Item C:\AuraManual -Recurse -Force
```

## 10. 常见问题 {#faq}

| 现象 | 原因 / 处理 |
|---|---|
| 删除 `app.asar` 报拒绝访问 | 过滤驱动未卸载或进程未清干净，重做第 4 步 |
| 管家启动后无变化 | `main.js` 4 处补丁有漏改，或 `hook.js` / `zeron.js` / `preload.js` 没放进 asar 包内 |
| `asar extract` 报错 | 换用官方 `@electron/asar`；希沃这个包结构较特殊，安装器专门为它打过适配补丁 |
| 升级后失效 | 必须用 `app.asar.bak` 作为补丁输入，不能对已 patch 的 `app.asar` 二次打补丁 |
| 找不到 `Verify.json` | 正常，该文件在部分版本不存在，跳过即可 |
