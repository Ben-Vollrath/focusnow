<template>
  <div>
    <p>Redirecting to FocusNow app...</p>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

onMounted(() => {
  const groupId = route.params.id
  if (groupId) {
    // Redirect to app link
    window.location.href = `io.vollrath.focusnow://group/${groupId}`

    // Optional fallback after a delay
    setTimeout(() => {
      window.location.href = 'https://play.google.com/store/apps/details?id=io.vollrath.focusnow'
    }, 2000)
  }
})
</script>
