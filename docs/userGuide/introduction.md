---
title: 前言
editLink: true
---

<script setup>
import { ref } from 'vue';
import { Info24Regular, CheckmarkCircle24Regular, DismissCircle24Regular, ErrorCircle24Regular } from '@vicons/fluent';
const imgPathBaseline = ref("/static/img/userGuide/introduction");
</script>

# 所以... 启航吧 {#getting-started}

<DocProp>
  <template #last-edit>2025.11.22</template>
  <template #est-time>3 分钟</template>
  <template #difficulty>入门</template>
</DocProp>

<AutoDarkImage :light="`${imgPathBaseline}/Banner_WithBg.jpeg`" :dark="`${imgPathBaseline}/Banner_Transparent.png`" />

## 写在前面 {#before-all}

厌倦了每次重启后都被还原如初的桌面? 苦恼于连个课表软件都没有办法持久化安装? 感叹于身为 "电教委" 却毫无实权?

自从希沃官方的设备集控平台「[希沃集控](/misc/seewo-hugo-intro-video)」在全国各校推广以来, 学生们对班内大屏的自由正一点一滴地被剥削:

- **冰点还原** | 软件安装再也无法被持久化, 即使把应用安装到未冻结盘符, 依然无法调整开机自启等。设备磁盘的写入寿命也被显著损耗。
- **设备巡视** | 「教室是公共空间, 在这里你没有隐私!」, 班主任、任课老师想随时随地偷窥都不会有任何限制, 1984 的时代已然到来。
- **弹窗拦截** | 流氓软件并没有被得到根治, 正常软件却被频频误杀。想放个音乐? 客户端的窗口给你拦截。想装个批注软件? 悬浮窗也给你拦了。
- **网址拦截** | 私自在设备上安装自签 CA, 上报所有访问的网址到集控服务器。堪比企业网络 AC 的监控程度, 附带着自签 CA 被用作 MITM 的风险。

不可否认, 一些同学随意在大屏上刷短视频、下载游戏, 这类行为的确应当谴责。但真的有必要通过上述这些形式来实现「管理」吗?

这不是我想象中, 教育信息化应有的样子。

**那就让我们来打破它。**

## HugoAura-Enhanced 是什么? {#whats-this}

**HugoAura-Enhanced** (中文名: `雨光之环增强版`), 全称 **Project HugoAura-Enhanced**, 是一个专门寻找各类技术方案与希沃集控进行对抗的组织。

目前 Project HugoAura-Enhanced 主要有以下两个产品线正处于积极维护状态:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/ProductLine_WithBg.png`" :dark="`${imgPathBaseline}/ProductLine_Transparent.png`" />

- **HugoAura-Enhanced-Main** | 希沃管家的 Electron 前端侧 Hook。简而言之, 它负责篡改你从桌面双击 "希沃管家" 快捷方式之后, 弹出的那个窗口的行为。
- **HugoAura-Aikari-Next** | 希沃易 + 的全面体验调整工具。其主要模块 PLS 专注于篡改集控端服务器与本地管家后台服务的通信数据, 从而实现更全面的活动监控与欺骗。其余模块可帮助用户提升其他希沃软件的使用时体验。

<ClientOnlyNAlert title="关于二者的关系" type="info">
  <template #icon>
    <Info24Regular />
  </template>
  根据计划, <code>-Main</code> 与 <code>-Aikari-Next</code> 应当可以互相完全独立地使用。但由于目前的开发进度所限, Aikari-Next 的大部分功能需在 Main 中进行管理。
  <br/>
  请等待后续 HugoAura-Enhanced 更新。
</ClientOnlyNAlert>

## HugoAura-Enhanced 能帮我做什么? {#what-can-it-does}

在您继续前, 首先需要明确 HugoAura-Enhanced 系列产品的能力范围。

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/HugoAura_Ability_Positive_WithBg.png`" :dark="`${imgPathBaseline}/HugoAura_Ability_Positive_Transparent.png`" />

<ClientOnlyNAlert title="如上图所示, Project HugoAura-Enhanced 的各类产品能力范围包括:" type="success">
  <template #icon>
    <CheckmarkCircle24Regular />
  </template>
  <ul>
    <li>协助您解除希沃管家系列产品的各类限制或阻止各类管控, 例如修改管理密码、解除屏幕锁、<s>禁用弹窗拦截</s>(WIP) 等</li>
    <li>自定义或客制化您的希沃易 + 应用, 例如<s>自动登录希沃账号</s>(WIP)、<s>增强冰点穿透能力</s>(WIP) 等</li>
    <li>使您的设备可以避开电教中心或教师的审查, 例如上报数据伪造、<s>集控端窥屏提醒</s>(WIP) 等</li>
    <li>其他类似上述举例的能力</li>
  </ul>
</ClientOnlyNAlert>

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/HugoAura_Ability_Negative_WithBg.png`" :dark="`${imgPathBaseline}/HugoAura_Ability_Negative_Transparent.png`" />

<ClientOnlyNAlert title="但是, Project HugoAura-Enhanced:" type="error">
  <template #icon>
    <DismissCircle24Regular />
  </template>
  <ul>
    <li>不能帮助您<b>取得全校的集控权限</b>, 从而实现您的最终幻想</li>
    <li>不能从<b>直接层面</b>提高您设备的性能, 也无法将您设备的 i5 8 代 CPU 变成 i7 13 代</li>
    <li>不是一个集控平台, 其无法替代其他集控商业产品</li>
    <li><b>永远不会</b>支持某些极度敏感的功能, 例如直接获取学校明文管理员密码等 (即使这从技术上可行, 如果您想实现此需求, 请自行 Fork 项目并修改)</li>
  </ul>
</ClientOnlyNAlert>

如果您发现 HugoAura-Enhanced 无法实现某个您梦想中的需求, 请勿使用 HugoAura-Enhanced。

针对合理范围内的需求, 我们依然欢迎您前往项目 Issues 区提交 Feature Request。

## 我应该使用 HugoAura-Enhanced 吗? {#should-i-use-this}

这是一个复杂的问题...

首先, 回忆一下自己来到这里的原因吧...

同学推荐? 因为受不了冰点而在 GitHub 上搜索关键词? 抑或是偶然间看到了宣传贴?

无论具体原因如何, 我想, 既然您已经读到了这里, 那么大概或多或少已经对希沃管家有了一些意见了。

但是, 继续也代表着风险。

<ClientOnlyNAlert title="继续操作, 您可能会面临:" type="warning">
  <template #icon>
    <ErrorCircle24Regular />
  </template>
  <ul>
    <li>在配置 HugoAura-Enhanced 的过程中被老师发现, 从而需要解释自己的行为</li>
    <li>可能因某个不稳定的 HugoAura-Enhanced 更新, 导致集控端出现设备掉线等异常, 从而遭责问 (尽管 HugoAura-Enhanced 开发者会<b>尽一切努力</b>避免此类问题, 但由于测试环境严重受限, 仍有极小概率会发生此类问题)</li>
    <li>可能因错误的篡改设置 (例如将被冰冻盘上报为某些明显不合理的值) 而导致被发现</li>
    <li>其他类似的风险</li>
  </ul>
</ClientOnlyNAlert>

选择自由, 意味着承担责任。如果您可以接受上述风险, 另请检查自身资质:

<AutoDarkImage :zoom="true" :light="`${imgPathBaseline}/SelfCheck_WithBg.png`" :dark="`${imgPathBaseline}/SelfCheck_Transparent.png`" />

- **请确保自身拥有基本的操作系统常识**: 例如, 知道并了解 "Windows"、"移动"、"复制"、"CMD"、"下载"、"浏览器" 等名词的基本含义。同时可无障碍地在设备上执行各类基本操作。<br />如果您缺乏此类常识, 请勿使用 HugoAura-Enhanced。我们不为此类用户解决 Issue。
- **请确认自己是否有基本的信息查找能力**: 例如, 遇到意外问题时, 先行查阅互联网、已有 GitHub Issues、文档 FAQ 等。而非直接发上来一个无日志的错误截图, 附文 "这个怎么办"。<br />我们不处理这类 Issue。
- **我们希望你能富有责任心和热爱**: 解除限制意味着需要承担更多的维护责任。以冰点还原的解除为例, 您<b>不应当</b>在解除冰点还原之后就置设备于不管不顾, 任由桌面文档乱飞、P2P 下崽器肆意运行。
  <br />使用 HugoAura-Enhanced 即代表您愿意负责设备的维护工作。<br />我们不会受理来自用户的「HugoAura-Enhanced 解冰点之后我设备硬盘撑爆了!!! 黑心软件!!!」的言论。同时我们强烈建议这类用户立即按下键盘上的 <code>Ctrl + W</code>。

除了上述因素以外, 自身是否为班级正式电教委员、班主任 / 学校信息中心对设备看管的严格程度、自身与其他同学的人际关系等因素也需要被斟酌。例如, 部分学校的信息中心负责人可能会定期线下检查设备, 又或者解除冰点之后班上同学就沉迷于天天刷视频 / 打云游戏。
本文无法涵盖所有分支可能性, 如果您对所需人格 / 品质的议题感兴趣, 另请参阅 [一名合格电教委的心理特质 | CNEL](https://cnel.smart-teach.cn/guide/Chapter0/0-1-before-starting.html)。

## 准备好了吗? {#getting-ready}

[我们出发吧](/userGuide/installation/summary)。
