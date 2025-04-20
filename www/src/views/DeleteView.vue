<script setup lang="ts">
import { useAuthStore } from '@/stores/AuthStore'
import { useRoute, useRouter } from 'vue-router'
import { watch, onMounted } from 'vue'

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()

watch(
  () => authStore.id,
  () => {
    if (!authStore.id) {
      router.push('/auth')
    }
  },
)

onMounted(() => {
  if (!authStore.id) {
    router.push('/auth')
  }
})
</script>

<template>
  <DashboardContent />
</template>
