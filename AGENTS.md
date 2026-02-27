# AGENTS.md - Development Guidelines

## Project Overview
- **Language**: Chinese for communication, English for code comments
- **Backend**: Laravel 10.x (PHP 8.1+)
- **Frontend**: Vue 3.5.x (Composition API) + TypeScript
- **Database**: SQLite 3

---

## Build / Lint / Test Commands

### Backend (Laravel)
```bash
cd backend
composer install
php artisan test                           # All tests
php artisan test --filter=TestClassName    # Single test class
php artisan test --filter=testMethodName   # Single test method
./vendor/bin/pint              # Fix style
./vendor/bin/pint --test       # Check only
php artisan optimize:clear     # Cache
```

### Frontend (Vue3)
```bash
cd frontend
npm install
npm run dev        # Dev server
npm run build      # Production build
npm run typecheck  # TypeScript check
npm run lint       # Lint & fix
```

---

## Code Style - PHP (Laravel)

**Strict Types**: `<?php declare(strict_types=1);`

**Imports**: Grouped by type, alphabetical
```php
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Models\User;
```

**Naming**: Classes `StudlyCaps`, methods `camelCase`, constants `UPPER_SNAKE`, tables `snake_case` plural

**Type Declarations** (required): `public function getUser(int $id): ?User`

**Early Returns**:
```php
public function getUser(int $id): ?User
{
    if ($id <= 0) return null;
    return User::find($id);
}
```

---

## Code Style - Vue 3 / TypeScript

**Composition API with `<script setup>`**
```typescript
<script setup lang="ts">
import { ref, computed } from 'vue'
import type { User } from '@/types'

const props = defineProps<{ userId: number }>()
const emit = defineEmits<{ (e: 'update', value: User): void }>()
</script>
```

**Imports Order**: Vue core → External libs → Internal modules → Components

**Naming**: Components `PascalCase`, Composables `useXxx`, Types `PascalCase`

**Prettier**: `semi: false`, `singleQuote: true`, `printWidth: 100`

---

## Error Handling

### Laravel
```php
try {
    $payment = PaymentService::process($data);
    return response()->json(['success' => true, 'data' => $payment]);
} catch (PaymentException $e) {
    return response()->json([
        'success' => false,
        'error' => ['code' => 'PAYMENT_FAILED', 'message' => $e->getMessage()]
    ], 422);
}
```

### Vue 3
```typescript
const error = ref<string | null>(null)
const fetchData = async () => {
  try {
    error.value = null
    const response = await api.getData()
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Unknown error'
  }
}
```

---

## API Response Format
```json
{ "success": true, "data": {}, "meta": {} }
{ "success": false, "error": { "code": "ERROR_CODE", "message": "..." } }
```

---

## Database (SQLite)
Use eager loading: `User::with(['posts'])->get()`, add indexes for foreign keys
```php
$table->foreignId('user_id')->constrained()->onDelete('cascade');
$table->index(['status', 'created_at']);
```

---

## Deployment (Aliyun)
```bash
git clone git@github.com:jwqdjs/aliyun_demo1.git /var/www/html
cd /var/www/html
touch database/database.sqlite
bash deploy.sh
```

---

## General Principles
1. Always use `declare(strict_types=1)` in PHP
2. Prefer early returns to reduce nesting
3. Use dependency injection in controllers
4. Follow PSR standards
5. Keep functions small (single responsibility)
