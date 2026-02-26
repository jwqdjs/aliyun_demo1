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

# Tests: php artisan test [--filter=TestClassName|--filter=testMethodName]
php artisan test                           # All tests
php artisan test --filter=TestClassName    # Single test class
php artisan test --filter=testMethodName   # Single test method

# Code style: ./vendor/bin/pint [--test]
./vendor/bin/pint              # Fix
./vendor/bin/pint --test       # Check only
./vendor/bin/phpstan analyse   # Static analysis

php artisan optimize:clear     # Cache
```

### Frontend (Vue3)
```bash
cd frontend
npm install
npm run dev        # Dev server
npm run preview    # Preview build
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
use App\Services\PaymentService;
```

**Naming**: Classes `StudlyCaps`, methods/variables `camelCase`, constants `UPPER_SNAKE_CASE`, tables `snake_case` plural

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

const props = defineProps<{ userId: number; showDetails?: boolean }>()

const emit = defineEmits<{
  (e: 'update', value: User): void
  (e: 'delete', id: number): void
}>()
</script>
```

**Imports Order**: Vue core → External libs → Internal modules → Components

**Naming**: Components `PascalCase`, Composables `useXxx`, Stores `camelCase`, Types `PascalCase`

**Prettier**: `semi: false`, `singleQuote: true`, `printWidth: 100`

---

## Error Handling

### Laravel
```php
public function processPayment(array $data): JsonResponse
{
    try {
        $payment = PaymentService::process($data);
        return response()->json(['success' => true, 'data' => $payment]);
    } catch (PaymentException $e) {
        Log::error('Payment failed: ' . $e->getMessage());
        return response()->json([
            'success' => false,
            'error' => ['code' => 'PAYMENT_FAILED', 'message' => $e->getMessage()]
        ], 422);
    }
}

public function store(Request $request): JsonResponse
{
    $validated = $request->validate([
        'email' => 'required|email',
        'amount' => 'required|numeric|min:1',
    ]);
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
Use eager loading, select specific columns, add indexes for foreign keys
```php
Schema::create('orders', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->onDelete('cascade');
    $table->index(['status', 'created_at']);
});
```

---

## General Principles
1. Always use `declare(strict_types=1)` in PHP
2. Prefer early returns to reduce nesting
3. Use dependency injection in controllers
4. Follow PSR standards
5. Keep functions small (single responsibility)
