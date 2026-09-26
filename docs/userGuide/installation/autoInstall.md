---
title: 一键安装
editLink: true
---

<script setup>
import { ref } from 'vue';
import { Info24Regular, QuestionCircle24Regular, ErrorCircle24Regular, CheckmarkCircle24Regular } from '@vicons/fluent';
const imgPathBaseline = ref("/static/img/userGuide/installation/autoInstallation");
</script>

# 一键安装 {#title}

<DocProp>
  <template #last-edit>2025.11.23</template>
  <template #est-time>3 ~ 5 分钟</template>
  <template #difficulty>入门</template>
</DocProp>

<AutoDarkImage :zoom="false" :light="`${imgPathBaseline}/Banner_WithBg.png`" :dark="`${imgPathBaseline}/Banner_Transparent.png`" />

## 选择网络环境 {#choose-network-env}

- [联网安装](#with-network)
- [离线安装](#without-network)

## 联网安装 {#with-network}

### 网络可访问性检查 {#with-network-accessiblity-check}

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/CheckYourConnection_WithBg.png`" :dark="`${imgPathBaseline}/CheckYourConnection_Transparent.png`" />

<ClientOnlyNAlert title="请确保您的网络可访问以下站点" type="info">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  无需逐一手动测试, 仅当一键安装器在下载过程中失败时再诊断即可
  <ul>
    <li><a href="https://api.github.com">GitHub API (https://api.github.com)</a>, <b>以及</b></li>
    <li><a href="https://e.seewo.com">希沃易 + 软件下载站 (https://e.seewo.com)</a>, <b>以及</b></li>
    <li>
      以下下载源中的<b>任意一个</b>:
      <ol>
        <li><a href="https://git.yylx.win">git.yylx.win</a></li>
        <li><a href="https://github.chenc.dev">github.chenc.dev</a></li>
        <li><a href="https://gh.07150721.xyz">gh.07150721.xyz</a></li>
        <li><a href="https://cdn.gh-proxy.org">cdn.gh-proxy.org</a></li>
        <li><a href="https://axisnow.gh-proxy.org">axisnow.gh-proxy.org</a></li>
        <li><a href="https://gh-proxy.org">gh-proxy.org</a></li>
        <li><a href="https://githubdog.com">githubdog.com</a></li>
        <li><a href="https://js.jiangss.shop">js.jiangss.shop</a></li>
        <li><a href="https://gh.927223.xyz">gh.927223.xyz</a></li>
        <li><a href="https://ghproxy.felicity.land">ghproxy.felicity.land</a></li>
        <li><a href="https://github.tbap.top">github.tbap.top</a></li>
        <li><a href="https://github.com">github.com</a></li>
      </ol>
    </li>
  </ul>
</ClientOnlyNAlert>

### 更新至最新版希沃管家 {#with-network-update-to-latest-seewo-services}

请打开 [e.seewo.com](https://e.seewo.com), 接着按下图所示完成管家最新版下载。

<ClientOnlyNAlert title="点击可查看大图" type="info" :titleOnly="true">
  <template #icon>
    <Info24Regular />
  </template>
  单击图片即可放大查看
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/DownloadLatestSSA_Transparent_Black.png`" :dark="`${imgPathBaseline}/DownloadLatestSSA_Transparent_White.png`" />

<ClientOnlyNAlert title="请务必更新到 e.seewo.com 上的最新管家版本" type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  受注入技术限制, HugoAura-Main 始终仅对最新版本的希沃管家提供支持, 如果您尝试在旧版本管家上安装 HugoAura-Enhanced, 可能会引发崩溃或功能失效等问题。<br />
  我们不受理来自旧版管家的 Issues。
</ClientOnlyNAlert>

<ClientOnlyNAlert title="如果您能确定设备上运行的希沃管家即为最新版..." type="info">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  那么无需再次更新希沃管家, 直接进入下一步即可。<br />
  请留意, 希沃集控端一般实施灰度性版本推送。开启了管家自动更新的学校, 设备上的管家版本<b>依然不一定是最新的</b>。
</ClientOnlyNAlert>

1. 将鼠标置于顶栏 "软件下载" 处
2. 在展开的软件列表中选择 "希沃管家 (大板端)"
3. 在弹窗中默认的 "Windows" 选项卡中点击 "立即下载"

下载完成后, 运行安装包并根据提示操作即可。此过程可能需要 1 ~ 5 分钟 (取决于您的设备性能)。

### 下载安装器文件 {#with-network-download-installer-package}

如果网络情况允许, 推荐您通过 [GitHub Releases](https://github.com/blingbling-bow/HugoAura-Enhanced-Install/releases) 下载安装器文件。

一般选择最新的 Release 即可。

<ClientOnlyNAlert title="正在使用 Windows 7 ?" type="warning">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  在 Windows 7 设备上使用一键安装可能需要特殊处理。接下来的每个步骤, 文档都会提供针对 Windows 7 设备的操作方案。请留意。<br />
  <b>我们强烈建议您尽快更新 Windows 版本, Windows 7 是完全 EOL 的 Windows 发行, HugoAura-Enhanced 不对任何 Win 7 设备上遇到的特化 Bug 进行处理。</b>
  <br />
  <br />
  针对本步骤, 在下载文件时, <b>请下载带有 <code>py3-8</code> 字样的 EXE 包</b>。Windows 7 无法运行 Python 3.10 的构建产物。
</ClientOnlyNAlert>

如果您的网络在访问 GitHub 时存在困难, 也可通过以下渠道下载:

| 下载渠道 |                                下载链接                                |     最新版本     |
| :------: | :--------------------------------------------------------------------: | :--------------: |
|  GitHub  |     [链接](https://github.com/blingbling-bow/HugoAura-Enhanced-Install/releases)      |    `始终最新`    |
|  蓝奏云  |      [链接 (提取码: cmba)](https://openapi.lanzout.com/ivpbH44ce7he)      | `v0.0.4-beta-I` |

### 运行安装器 {#with-network-run-installer-package}

请选择安装器运行方式:

- [通过图形界面安装 (适用于 Windows 10 用户)](#with-network-using-installer-gui-start)
- [通过交互式 CLI 安装 (适用于 Windows 7 用户)](#with-network-using-installer-cli-interactive-start)
- [通过非交互式 CLI 安装 (适用于高级用户)](#with-network-using-installer-cli-start)

#### 通过图形界面安装 <Badge type="tip" text="Windows 10+" /> {#with-network-using-installer-gui-start}

请双击运行安装器。

##### 解决 SmartScreen 警告 {#with-network-using-installer-smart-screen}

如果您的设备开启了 Windows Defender SmartScreen, 可能会在运行时看到类似下图的警告框:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/BypassWindowsDefender_WithBg.png`" :dark="`${imgPathBaseline}/BypassWindowsDefender_Transparent.png`" />

这是因为安装器没有数字签名所致。如果您是从上方任一来源下载的, 那么可以完全信任此文件。

请:

1. 点击弹框中的 "了解更多信息"
2. 点击弹框底部靠左的 "仍要运行" 按钮

##### 使用 GUI 安装器 {#with-network-using-installer-gui-install}

针对 Windows 10+ 用户, HugoAura Install 提供了友好的图形化界面供您执行操作。

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/InstallerUI_WithBg.png`" :dark="`${imgPathBaseline}/InstallerUI_Transparent.png`" />

<p class="opacity-50 align-center" style="font-size: small;">请小心照骗</p>

请按如下步骤完成安装:

1. 在「版本类型选择区域」, 选择一个合适的版本类型 <span class="opacity-50">(一般推荐使用 CI 版, 与一般软件不同, HugoAura-Main 的稳定版 (发行版) 不一定能良好兼容最新版管家)</span>
2. 在「版本号选择区域」选择最新版本 <span class="opacity-50">(一般无需修改, 最顶上第一个即为最新版)</span>
3. 正常情况下, <b>无需</b>填写 "安装路径设置" 的信息。直接在底部操作按钮区域点击 "<b>开始安装</b>" 即可。

<ClientOnlyNAlert title="点击可查看大图" type="info" :titleOnly="true">
  <template #icon>
    <Info24Regular />
  </template>
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/InstallerSteps_WithBg_compressed.png`" :dark="`${imgPathBaseline}/InstallerSteps_Transparent_compressed.png`" />

完成上述步骤后, 等待安装器执行工作。在安装完成后, 您应该会看到:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/InstallerDone_WithBg.png`" :dark="`${imgPathBaseline}/InstallerDone_Transparent.png`" />

此时, 请手动双击桌面上的管家图标, 以打开希沃管家前端窗口。

接下来请跟随下图图示找到 HugoAura-Enhanced 设置入口:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/SSADone_WithBg.png`" :dark="`${imgPathBaseline}/SSADone_Transparent.png`" />

<ClientOnlyNAlert title="完成! 🎉" type="success">
  <template #icon>
    <CheckmarkCircle24Regular />
  </template>
  祝贺您完成了 <code>HugoAura-Main</code> 的安装流程。<br />
  如果您在前面的任一步骤中遇到了问题, 请参阅 <a href="#faq">FAQ</a>。
</ClientOnlyNAlert>

#### 通过交互式 CLI 安装 <Badge type="warning" text="Windows 7+" /> {#with-network-using-installer-cli-interactive-start}

<ClientOnlyNAlert title='本段教程的启动步骤仅适用于 Python 3.8 构建, 即文件名中带 "-py3-8" 的安装器' type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  如果您希望从 Python 3.10 构建启动命令行交互式安装, 您需要打开终端, 并在 EXE 启动参数中带上&nbsp;&nbsp; <code>--cli</code>。不能附带其他参数。
</ClientOnlyNAlert>

请双击运行安装器。

如果遇到安全警告弹窗, 请参考 [解决 SmartScreen 警告](#with-network-using-installer-smart-screen)。

如果看到 UAC 弹窗, 请点击 "是"。

##### 使用交互式 CLI 界面 {#with-network-using-installer-interactive-cli-install}

运行后, 您应该可以看到类似如图所示的命令行窗口:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/CLIInteractive_WithBg.png`" :dark="`${imgPathBaseline}/CLIInteractive_Transparent.png`" />

请根据下图所示进行操作:

<ClientOnlyNAlert title="点击可查看大图" type="info" :titleOnly="true">
  <template #icon>
    <Info24Regular />
  </template>
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/CLIInteractiveUsage_WithBg.png`" :dark="`${imgPathBaseline}/CLIInteractiveUsage_Transparent.png`" />

1. 选择您希望安装的版本号 <span class="opacity-50">(一般推荐使用 CI 版, 与一般软件不同, HugoAura-Main 的稳定版 (发行版) 不一定能良好兼容最新版管家)</span>
2. 在命令行中输入该版本号左侧的数字 **(注: 不要带 `[` 或 `]`, 仅输入纯阿拉伯数字)** <span class="opacity-50">(如果班级内没有键盘, 请使用软键盘, 聚焦到 CMD 窗口后, 点击软键盘上的相应按键) (如果您不知道如何开启软键盘, 请[上网搜索](https://www.bing.com/search?q=Windows+7+%E5%A6%82%E4%BD%95%E5%BC%80%E5%90%AF%E8%BD%AF%E9%94%AE%E7%9B%98&PC=U316&FORM=&rdr=1&rdrig=1))</span>
3. 按下键盘上的回车

回车提交后, HugoAura-Enhanced 将自动完成文件下载、ASAR 修补等操作。

当您看到下图输出时, 安装即为完成。

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/CLIInteractiveDone_WithBg.png`" :dark="`${imgPathBaseline}/CLIInteractiveDone_Transparent.png`" />

此时, 请手动双击桌面上的管家图标, 以打开希沃管家前端窗口。

接下来请跟随下图图示找到 HugoAura-Enhanced 设置入口:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/SSADone_WithBg.png`" :dark="`${imgPathBaseline}/SSADone_Transparent.png`" />

<ClientOnlyNAlert title="完成! 🎉" type="success">
  <template #icon>
    <CheckmarkCircle24Regular />
  </template>
  祝贺您完成了 <code>HugoAura-Main</code> 的安装流程。<br />
  如果您在前面的任一步骤中遇到了问题, 请参阅 <a href="#faq">FAQ</a>。
</ClientOnlyNAlert>

#### 通过非交互式 CLI 安装 <Badge type="tip" text="Any Version" /> {#with-network-using-installer-cli-start}

<ClientOnlyNAlert title="本段教程尚未完工" type="warning">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  这段教程正在编写进程中, 请您优先尝试其他安装方式, 或直接根据 <a href="https://github.com/blingbling-bow/HugoAura-Enhanced-Install">HugoAura-Install README</a> 中的命令提示进行操作。
</ClientOnlyNAlert>

## 离线安装 {#without-network}

本段教程适用于校园网完全屏蔽了 GitHub API 访问 & 各类镜像站的场景。

您需要一个可移动介质来完成全部安装流程。推荐设备存储空间大小 > 256MB。

### 下载各类资源 {#without-network-download-resources}

#### 下载最新版希沃管家安装包 {#without-network-download-res-ssa}

请跟随 [联网安装中的管家下载步骤](#with-network-update-to-latest-seewo-services) 下载希沃管家安装包, 然后将安装包 (`SeewoServiceSetup_vX.X.X.exe`) 复制到您的可移动介质中。

#### 下载 HugoAura Install 安装器 {#without-network-download-res-installer}

请跟随 [联网安装中安装器的下载步骤](#with-network-download-installer-package) 下载 HugoAura Install 安装器, 然后将文件 (`AuraInstaller-XXX.exe`) 复制到您的可移动介质中。

#### 下载 HugoAura-Enhanced Releases 源码包 {#without-network-download-res-src}

请前往 [HugoAura-Main Releases](https://github.com/blingbling-bow/HugoAura-Enhanced/releases) 下载您喜欢的版本所对应的源码包 (`aura.zip` 和 `core.zip`)。

我们优先建议您下载 [CI 版](https://github.com/blingbling-bow/HugoAura-Enhanced/releases/tag/vAutoBuild) 的源码包。与一般软件不同, HugoAura-Main 的稳定版不一定能非常良好地兼容最新版管家。具体请详见每个 Release Description 区域的「版本对齐信息」。

参见下图进行下载操作:

<ClientOnlyNAlert title="点击可查看大图" type="info" :titleOnly="true">
  <template #icon>
    <Info24Regular />
  </template>
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/OfflineInstall_GitHubReleases_WithBg.png`" :dark="`${imgPathBaseline}/OfflineInstall_GitHubReleases_Transparent.png`" />

请将源码包复制到您的可移动介质中。

### 进行安装 {#without-network-go-installation}

#### 更新希沃管家 {#without-network-go-inst-upg-ssa}

先将上一步下载的希沃管家安装包复制到设备上, 双击运行并根据提示更新希沃管家。

<ClientOnlyNAlert title="如果您能确定设备上运行的希沃管家即为最新版..." type="info">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  那么无需再次更新希沃管家, 直接进入下一步即可。<br />
  请留意, 希沃集控端一般实施灰度性版本推送。开启了管家自动更新的学校, 设备上的管家版本<b>依然不一定是最新的</b>。
</ClientOnlyNAlert>

#### 放置源码包和安装器 {#without-network-go-inst-move-files}

接下来请将安装器 EXE 文件、两个源码 ZIP 放置在您喜欢的位置 (例如 "下载" 文件夹等位置)。在此段教程中, 我们假设您将安装器 EXE 和两个 ZIP 都放在了完全相同的文件夹 `C:\Users\seewo\Downloads\` 下。

那么目录结构类似:

```
C:\Users\seewo\Downloads
  |
  |-- aura.zip
  |-- core.zip
  |-- AuraInstaller-XXXXXX.exe
```

#### 运行安装器 {#without-network-go-inst-run-installer}

请按照您的操作系统选择接下来的步骤:

- [Windows 10 (Python 3.10)](#without-network-go-inst-run-installer-with-gui)
- [Windows 7 (Python 3.8)](#without-network-go-inst-run-installer-with-cli)

##### 使用图形界面进行离线安装 <Badge type="tip" text="Windows 10+" /> {#without-network-go-inst-run-installer-with-gui}

双击启动 HugoAura Install 安装器的 EXE。如果您遇到了 SmartScreen 警告弹窗, 请参见 [解决 SmartScreen 警告](#with-network-using-installer-smart-screen)。如果您遇到了 UAC 提示框, 请点击 "是"。

接下来, 如下图所示:

<ClientOnlyNAlert title="点击可查看大图" type="info" :titleOnly="true">
  <template #icon>
    <Info24Regular />
  </template>
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/Offline_InstallerSteps_WithBg_compressed.png`" :dark="`${imgPathBaseline}/Offline_InstallerSteps_Transparent_compressed.png`" />

1. 点击 "版本选择" 中的 "本地文件"。
2. 点击 "浏览..."
3. 在弹出窗口中导航到刚刚保存两个 ZIP 源码包的目录 (例如在文档的例子中, 就是 `C:\Users\seewo\Downlaods`)。
4. 单击 "选择文件夹"

选择完成后, 请点击安装器底部的 "开始安装" 操作按钮。

在安装完成后, 您应该会看到:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/InstallerDone_WithBg.png`" :dark="`${imgPathBaseline}/InstallerDone_Transparent.png`" />

等待安装器完成安装后, 手动双击桌面上的管家图标, 以打开希沃管家前端窗口。

接下来请跟随下图图示找到 HugoAura-Enhanced 设置入口:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/SSADone_WithBg.png`" :dark="`${imgPathBaseline}/SSADone_Transparent.png`" />

<ClientOnlyNAlert title="完成! 🎉" type="success">
  <template #icon>
    <CheckmarkCircle24Regular />
  </template>
  祝贺您完成了 <code>HugoAura-Main</code> 的安装流程。<br />
  如果您在前面的任一步骤中遇到了问题, 请参阅 <a href="#faq">FAQ</a>。
</ClientOnlyNAlert>

##### 使用 CLI 进行离线安装 <Badge type="warning" text="Windows 7" /> {#without-network-go-inst-run-installer-with-cli}

<ClientOnlyNAlert title="本段教程尚未完工" type="warning">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  这段教程正在编写进程中, 如果您因此发生安装受阻情况, 请直接从文档站右上角前往论坛 / QQ 交流群寻求帮助。
</ClientOnlyNAlert>

## 一键安装 FAQ {#faq}

<ClientOnlyNAlert title="本段教程尚未完工" type="warning">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  这段教程正在编写进程中, 如果您有急需开发者解答的安装问题, 可前往 <a href="https://github.com/blingbling-bow/HugoAura-Enhanced-Install/issues">HugoAura-Install Issues</a> 进行反馈。您的案例会被添加到本区域。
</ClientOnlyNAlert>
