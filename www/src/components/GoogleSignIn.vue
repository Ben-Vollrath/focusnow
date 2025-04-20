<template>
  <div class="google-login">
    <!-- Google Sign-In Button placeholder -->
    <div
      id="g_id_onload"
      :data-client_id="clientId"
      data-context="signin"
      data-ux_mode="popup"
      data-callback="handleCredentialResponse"
      data-auto_prompt="false"
    ></div>
    <div
      class="g_id_signin"
      data-type="standard"
      data-shape="rectangular"
      data-theme="filled_black"
      data-text="continue_with"
      data-size="large"
      data-logo_alignment="left"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { supabase } from '@/utils/supabase'

const clientId = import.meta.env.VITE_GOOGLE_CLIENT_ID

onMounted(() => {
  // Inject the Google script if not already present
  if (!document.getElementById('google-gsi-script')) {
    const script = document.createElement('script')
    script.src = 'https://accounts.google.com/gsi/client'
    script.async = true
    script.defer = true
    script.id = 'google-gsi-script'
    document.head.appendChild(script)
  }

  // Define the global callback for Google One Tap
  window.handleCredentialResponse = async ({ credential }) => {
    console.log('Handle Credential response:', credential)
    try {
      const { data, error } = await supabase.auth.signInWithIdToken({
        provider: 'google',
        token: credential,
      })
      console.log('Google login data:', data)

      if (error) throw error
    } catch (err) {
      console.error('Google login failed:', err)
    }
  }
})
</script>

<style scoped>
.google-login {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}
</style>

<!-- Typescript fix -->
<script lang="ts">
declare global {
  interface Window {
    handleCredentialResponse: (response: { credential: string }) => void
  }
}
</script>
