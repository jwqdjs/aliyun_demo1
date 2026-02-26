<script setup lang="ts">
import { ref, onMounted } from 'vue'

const backendData = ref<{ success: boolean; message: string; version: string } | null>(null)
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    const response = await fetch('http://localhost:8000')
    backendData.value = await response.json()
  } catch (e) {
    error.value = e instanceof Error ? e.message : '连接后端失败'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="container">
    <h1>Vue3 + Laravel 演示项目</h1>
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else-if="backendData" class="success">
      <h2>后端连接成功!</h2>
      <pre>{{ JSON.stringify(backendData, null, 2) }}</pre>
    </div>
  </div>
</template>

<style scoped>
.container { max-width: 600px; margin: 50px auto; padding: 20px; font-family: Arial, sans-serif; }
h1 { text-align: center; color: #42b883; margin-bottom: 30px; }
.loading { text-align: center; font-size: 18px; color: #666; }
.error { text-align: center; padding: 20px; background: #ffe6e6; border-radius: 8px; color: #cc0000; }
.success { text-align: center; }
.success h2 { color: #42b883; margin-bottom: 20px; }
pre { background: #f5f5f5; padding: 20px; border-radius: 8px; text-align: left; overflow-x: auto; }
</style>
