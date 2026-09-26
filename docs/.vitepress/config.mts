import { defineConfig } from "vitepress";
import { fileURLToPath, URL } from "node:url";
import importedSocialLinksData from "./subconfig/socialLink";
import importedSidebarArr from "./subconfig/sideBar";
import importedLocalSearchOptions from "./subconfig/searchOpt";

const fileAndStyles: Record<string, string> = {};

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "HugoAura-Enhanced Docs",
  description: "Next era of Seewo Hugo tricking",
  cleanUrls: true,
  // ▽ Begin of config for Vitepress Default Theme
  themeConfig: {
    nav: [
      { text: "首页", link: "/" },
      { text: "用户教程", link: "/userGuide/introduction" },
      { text: "开发者文档", link: "/developerGuide/wip" },
      { component: "CustomThemeSiteNavigator" },
    ],
    sidebar: importedSidebarArr,
    socialLinks: importedSocialLinksData,
    search: {
      provider: "local",
      options: importedLocalSearchOptions,
    },
    outline: {
      level: [2, 5]
    }
  },
  // △ End of config for Vitepress Default Theme
  markdown: {
    image: {
      lazyLoading: true,
    },
  },
  vite: {
    resolve: {
      alias: [
        {
          find: "@",
          replacement: fileURLToPath(new URL("./", import.meta.url)),
        },
      ],
    },
    ssr: {
      noExternal: ["naive-ui", "date-fns", "vueuc"],
    },
  },
  // ▽ Begin of config for Naive UI specified settings
  postRender(context) {
    const styleRegex = /<css-render-style>((.|\s)+)<\/css-render-style>/;
    const vitepressPathRegex = /<vitepress-path>(.+)<\/vitepress-path>/;
    const style = styleRegex.exec(context.content)?.[1];
    const vitepressPath = vitepressPathRegex.exec(context.content)?.[1];
    if (vitepressPath && style) {
      fileAndStyles[vitepressPath] = style;
    }
    context.content = context.content.replace(styleRegex, "");
    context.content = context.content.replace(vitepressPathRegex, "");
  },
  transformHtml(code, id) {
    const html = id.split("/").pop();
    if (!html) return;
    const style = fileAndStyles[`/${html}`];
    if (style) {
      return code.replace(/<\/head>/, `${style}</head>`);
    }
  },
  // △ End of config for Naive UI specified settings
});
