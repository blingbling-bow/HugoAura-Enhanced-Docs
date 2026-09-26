---
title: 选择安装方式
editLink: true
---

<script setup>
import { ref } from 'vue';
import { Info24Regular, QuestionCircle24Regular } from '@vicons/fluent';
const imgPathBaseline = ref("/static/img/userGuide/installation");
</script>

# 选择安装方式 {#choose-inst-method}

<DocProp>
  <template #last-edit>2025.11.22</template>
  <template #est-time>1 分钟</template>
  <template #difficulty>引导</template>
</DocProp>

<AutoDarkImage :zoom="false" :light="`${imgPathBaseline}/Banner_WithBg.png`" :dark="`${imgPathBaseline}/Banner_Transparent.png`" />

## 即将开始... {#we-re-starting}

HugoAura-Enhanced-Main 支持多种安装方式, 请选择一种您偏好的方式:

- [一键安装](/userGuide/installation/autoInstall)

<ClientOnlyNAlert title="对于新手更稳妥的选择" type="success">
  <template #icon>
    <Info24Regular />
  </template>
  一键安装需要以下条件:
  <ul class="less-margin">
    <li>最基本的常识 (从浏览器下载文件, 双击运行)</li>
    <li><b>在线安装</b>需要网络连接, <b>离线安装</b>需要文件传输介质 (如 U 盘)</li>
    <li>大约 1 ~ 3 分钟时间</li>
  </ul>
</ClientOnlyNAlert>

- [手动安装](/userGuide/installation/manualInstall)

<ClientOnlyNAlert title="如果您平常装软件都喜欢 Build from source" type="info">
  <template #icon>
    <QuestionCircle24Regular />
  </template>
  手动安装需要以下条件:
  <ul class="less-margin">
    <li>一些技术方面的常识 (从 GitHub 下载源码或 <code>git clone</code>、使用 NPM、使用 VSCode、使用命令提示符)</li>
    <li><b>在线安装</b>需要网络连接, <b>离线安装</b>需要文件传输介质 (如 U 盘)</li>
    <li>大约 5 ~ 15 分钟时间</li>
  </ul>
</ClientOnlyNAlert>
