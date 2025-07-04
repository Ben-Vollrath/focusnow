<script setup lang="ts">
import { useAuthStore } from '@/stores/AuthStore'
import { useRoute, useRouter } from 'vue-router'
import { ref, watch, onMounted } from 'vue'
import { supabase } from '@/utils/supabase'

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()

const confirmationText = ref('')
const isDeleting = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

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

const deleteAccount = async () => {
  if (confirmationText.value !== 'delete') {
    errorMessage.value = 'You must type "delete" to confirm.'
    return
  }

  isDeleting.value = true
  errorMessage.value = ''
  successMessage.value = ''

  const { error } = await supabase.rpc('delete_account')

  if (error) {
    errorMessage.value = error.message
  } else {
    successMessage.value = 'Your account has been deleted.'
    authStore.id = null
    authStore.email = null
    router.push('/auth')
  }

  isDeleting.value = false
}

const logout = async () => {
  await supabase.auth.signOut()
  authStore.id = null
  authStore.email = null
  router.push('/auth')
}
</script>

<template>
  <div class="max-w-xl mx-auto mt-10 p-6 bg-surfaceContainerHigh rounded-xl shadow-md">
    <h2 class="text-xl font-semibold mb-4">Delete Your Account</h2>
    <p class="mb-4 text-sm text-red-400">
      This action <strong>cannot be undone</strong>. Please type <code>delete</code> below to
      confirm.
    </p>

    <input
      v-model="confirmationText"
      type="text"
      placeholder="Type 'delete'"
      class="w-full p-2 rounded bg-background text-foreground border border-border mb-4"
    />

    <button
      @click="deleteAccount"
      :disabled="confirmationText !== 'delete' || isDeleting"
      class="bg-red-600 text-white px-4 py-2 rounded disabled:opacity-50 mb-4"
    >
      {{ isDeleting ? 'Deleting...' : 'Delete Account' }}
    </button>

    <p v-if="errorMessage" class="text-red-400 mt-2">{{ errorMessage }}</p>
    <p v-if="successMessage" class="text-green-400 mt-2">{{ successMessage }}</p>

    <hr class="my-6 border-border" />

    <div class="text-center">
      <button @click="logout" class="text-sm text-foreground underline hover:text-red-400">
        Log out instead
      </button>
    </div>
  </div>
</template>
