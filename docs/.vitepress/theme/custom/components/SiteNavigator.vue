<script setup lang="ts">
import {
  DropdownGroupOption,
  DropdownOption,
  NDropdown,
  NTooltip,
} from "naive-ui";
import { ChevronDown24Filled } from "@vicons/fluent";
import { h, VNode } from "vue";

interface DropDownData {
  title: string;
  desc: string;
  isSelf: boolean;
  link: string;
  iconUrl: string;
}

const props = defineProps<{
  screenMenu?: boolean;
}>();

const renderDropDownOptions = ({
  node,
  option,
}: {
  node: VNode;
  option: DropdownOption | DropdownGroupOption;
}) => {
  return h(
    NTooltip,
    {
      trigger: option.disabled ? "hover" : "manual",
      keepAliveOnHover: false,
      style: { width: "max-content" },
      placement: props.screenMenu ? "top" : "left",
    },
    {
      trigger: () => [node],
      default: () => {
        return h("span", "此站点仍在建设中");
      },
    }
  );
};

const renderDropDownLabels = (option: DropdownOption) => {
  const data: DropDownData = JSON.parse(option.label as string);
  return h("div", { class: "dropdown-item-container" }, [
    h("img", { src: data.iconUrl }),
    h("div", { class: "dropdown-item-content-area" }, [
      h("p", { class: "dropdown-item-title" }, [
        data.title,
        h(
          "span",
          { class: "dropdown-item-is-self-notify" },
          data.isSelf ? "(当前浏览)" : ""
        ),
      ]),
      h("p", { class: "dropdown-item-desc", innerHTML: data.desc }),
    ]),
  ]);
};

const dropDownOptions = [
  {
    label: `{
        "title": "HugoAura-Enhanced-Main 文档站",
        "desc": "关于 HugoAura-Enhanced 主模块 (Electron 端注入) 的相关文档、使用方法。<br/>HugoAura-Enhanced-Main 主要负责管家前端逻辑篡改等业务, 实现绕过密码<br/>验证、自定义屏幕锁激活码等纯前端行为。",
        "isSelf": true,
        "link": "/userGuide/introduction",
        "iconUrl": "/static/img/nav/Main.png"
      }`,
    key: "HugoAura-Enhanced-Main",
    disabled: false,
  },
  {
    label: `{
        "title": "HugoAura-Aikari-Next 文档站",
        "desc": "关于 HugoAura-Enhanced Aikari-Next 的相关文档、使用方法。<br/>HugoAura-Aikari-Next 负责 MQTT 流量中继 (集控服务器消息篡改 / 拦<br/>截)、扩展冰点穿透、希沃账号自动登录等。",
        "isSelf": false,
        "link": "javascript:;",
        "iconUrl": "/static/img/nav/Aikari.png"
      }`,
    key: "HugoAura-Aikari-Next",
    disabled: true,
  },
  {
    label: `{
        "title": "Hugo IndeXed",
        "desc": "收集各类和希沃易 + 系列软件相关的技术细节与使用技巧。<br/>Hugo IndeXed 旨在帮助人们更透明地了解部分希沃易 + 应用的底<br/>层工作原理和技术细节, 类似 Wiki 性质。",
        "isSelf": false,
        "link": "javascript:;",
        "iconUrl": "/static/img/nav/IndeXed.png"
      }`,
    key: "HugoIndeXed",
    disabled: true,
  },
];
</script>

<template>
  <NDropdown
    :class="`custom-nav-dropdown${
      props.screenMenu ? ' custom-nav-dropdown-mobile' : ''
    }`"
    trigger="hover"
    :options="dropDownOptions"
    :render-label="renderDropDownLabels"
    :render-option="renderDropDownOptions"
  >
    <!--
    <NButton
      text
      tag="a"
      class="VPLink link VPNavBarMenuLink"
    >
      切换站点
    </NButton>
    -->
    <a
      :class="
        props.screenMenu ? 'custom-nav-screen-link' : 'custom-menubar-link'
      "
    >
      切换站点
      <ChevronDown24Filled class="custom-nav-icon" />
    </a>
  </NDropdown>
</template>

<style scoped>
.custom-menubar-link {
  display: flex;
  align-items: center;
  padding: 0 12px;
  line-height: var(--vp-nav-height);
  font-size: 14px;
  font-weight: 500;
  color: var(--vp-c-text-1);
  transition: color 0.25s;
}

.custom-nav-screen-link {
  display: flex;
  border-bottom: 1px solid var(--vp-c-divider);
  padding: 12px 0 11px;
  line-height: 24px;
  font-size: 14px;
  font-weight: 500;
  color: var(--vp-c-text-1);
  transition: border-color 0.25s, color 0.25s;
  align-items: center;
}

.custom-menubar-link:hover,
.custom-nav-screen-link:hover {
  color: var(--vp-c-brand-1);
}

.custom-nav-icon {
  width: 14px;
  height: 14px;
  margin-left: 0.25rem;
  opacity: 0.6;
}
</style>

<style>
.custom-nav-dropdown {
  --n-option-height: max-content !important;
  user-select: none;
}

.custom-nav-dropdown .n-dropdown-option {
  margin: 0.5rem;
}

.custom-nav-dropdown .dropdown-item-container {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  padding-left: 0.5rem;
  padding-right: 0.5rem;
  gap: 1.25rem;
}

.custom-nav-dropdown .dropdown-item-container img {
  max-height: 40px;
  border-radius: 5px;
}

.custom-nav-dropdown .dropdown-item-container .dropdown-item-content-area {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.custom-nav-dropdown
  .dropdown-item-container
  .dropdown-item-content-area
  .dropdown-item-title {
  font-size: 16px;
  font-weight: 500;
}

.custom-nav-dropdown
  .dropdown-item-container
  .dropdown-item-content-area
  .dropdown-item-desc {
  font-size: 14px;
  opacity: 0.75;
}

.custom-nav-dropdown
  .dropdown-item-container
  .dropdown-item-content-area
  .dropdown-item-is-self-notify {
  margin-left: 0.25rem;
  font-size: 13px;
  opacity: 0.65;
}

.custom-nav-dropdown-mobile .dropdown-item-container {
  padding-top: 1rem;
  padding-bottom: 1rem;
}

.custom-nav-dropdown-mobile .dropdown-item-desc {
  display: none;
}

.custom-nav-dropdown-mobile .n-dropdown-option {
  margin: 0.125rem;
}
</style>
