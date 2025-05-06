import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: () => import("../views/LandingView.vue"),
    },
    {
      path: "/auth",
      name: "auth",
      component: () => import("../views/AuthView.vue"),
    },
    {
      path: "/delete",
      name: "delete",
      component: () => import("../views/DeleteView.vue"),
    },
    {
      path: "/group/:id",
      name: "group-redirect",
      component: () => import("../views/GroupRedirectView.vue"),
    },
  ],
});

export default router;
