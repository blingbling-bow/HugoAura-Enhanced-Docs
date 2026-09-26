<script setup>
import { useData } from "vitepress";

const { isDark } = useData();
</script>

<template>
  <div class="footer-area">
    <span :class="`footer-hr footer-hr-${isDark ? 'dark' : 'light'}`" />
    <p style="margin-top: 0.25rem">
      Powered by <a href="https://vitepress.dev/">VitePress</a>
    </p>
    <p>Copyright © 2025, HugoAura-Enhanced Developers</p>
    <p>
      HugoAura-Enhanced is licensed under
      <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL-v3.0</a>
    </p>
    <p>
      HugoAura-Enhanced Docs is licensed under
      <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>
    </p>
  </div>
</template>

<style lang="css" scoped>
.footer-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 1rem;
}

.footer-area p {
  opacity: 0.5;
  font-size: 14px;
  line-height: 24px;
}

.footer-area a {
  text-decoration-line: underline;
  text-underline-offset: 2px;
  transition: all 0.3s;
  opacity: 1;
}

.footer-area a:hover {
  opacity: 0.45;
}

.footer-hr {
  width: 100%;
  height: 1px;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.footer-hr-light {
  background-color: rgba(0, 0, 0, 0.12);
}

.footer-hr-dark {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>
