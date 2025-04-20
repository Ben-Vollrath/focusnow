<script setup lang="ts">
import { useAuthStore } from '@/stores/AuthStore'
import { useRoute, useRouter } from 'vue-router'
import { watch, onMounted } from 'vue'
import { supabase } from '@/utils/supabase'

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()

const handleLogout = () => {
  supabase.auth.signOut()
}

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
  <Button @click="handleLogout" class="absolute top-4 right-4"> Logout </Button>
</template>
