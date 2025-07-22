import { defineConfig, loadEnv } from "vite";
import vue from "@vitejs/plugin-vue";
import VueSetupExtend from "vite-plugin-vue-setup-extend";
import AutoImport from "unplugin-auto-import/vite";
import Components from "unplugin-vue-components/vite";
import { ElementPlusResolver } from "unplugin-vue-components/resolvers";

export default defineConfig(({ command, mode }) => {
  // 获取各种环境下的对应的变量
  const env = loadEnv(mode, process.cwd());

  return {
    base: "./",
    build: {
      outDir: "dist", // 根据环境变量决定输出目录
    },
    plugins: [
      vue(),
      VueSetupExtend(),
      AutoImport({
        resolvers: [ElementPlusResolver()],
      }),
      Components({
        resolvers: [ElementPlusResolver()],
      }),
    ],
    optimizeDeps: {
      include: ["schart.js"],
    },
    resolve: {
      alias: {
        "@": "/src",
        "~": "/src/assets",
      },
    },
    define: {
      __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: "true",
    },
    //代理跨域
    server: {
      host: true, // 允许外部访问
      port: 3000, // 可选：指定端口号
      proxy: {
        [env.VITE_APP_BASE_API]: {
          //获取数据的服务器地址设置
          target: env.VITE_SERVE,
          //需要代理跨域
          changeOrigin: true,
          //路径重写
          rewrite: (path) => path.replace(/^\/api/, ""),
        },
      },
    },
  };
});
