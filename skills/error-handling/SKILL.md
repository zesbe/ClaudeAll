
---
name: error-handling
description: Use when implementing error handling code to ensure all errors are properly caught, logged, and recovered from - includes try-catch patterns, error boundaries, graceful degradation, and user-friendly error messages

---

# Error Handling Skill

You are an Error Handling Expert specializing in making code robust and resilient through proper error management.

## When to Use

Trigger this skill when:
- Implementing error handling in code
- Fixing unhandled exceptions
- Adding logging to debug errors
- Making code more robust
- Improving error recovery mechanisms

## Core Principles

### 1. Try-Catch Patterns

#### JavaScript/TypeScript
```typescript
try {
  const result = riskyOperation();
  return result;
} catch (error) {
  console.error('Error in riskyOperation:', error);
  return defaultValue;
}
```

#### Python
```python
try:
    result = risky_operation()
    return result
except Exception as error:
    log_error(f"Error in risky_operation: {str(error)}")
    return default_value
```

### 2. Error Boundaries

Prevent errors from crashing the application:

```typescript
// Error boundary component (React)
class ErrorBoundary extends React.Component {
  componentDidCatch(error, errorInfo) {
    console.error('Error caught:', error, errorInfo);
    return (
      <div className="error-page">
        <h1> │→ Something went wrong</h1>
        <p>{error.toString()}</p>
      </div>
    );
  }
}
```

### 3. Structured Error Logging

Log errors dengan context:

```typescript
interface AppError extends Error {
  code: string;           // Unique error code
  timestamp: string;     // When error occurred
  user: string;         // User who experienced the error
  stack: string;          // Stack trace
  context?: {           // Additional context
    component?: string;
    action?: string;
    state?: object;
  };
```

### 4. Graceful Degradation

Fallback mechanisms when things fail:

```typescript
async function fetchUserData(userId: string) {
  try {
    return await fetch(\`/api/users/\${userId}\`);
  } catch (error) {
    console.error('Failed to fetch user data, using cache:', error);
    return getCachedUserData(userId); // Fallback ke cache
  }
}
```

## Error Categories

1. User Errors: Invalid inputs, wrong permissions, wrong file format
2. System Errors: Database connection, file not found, network timeout
3. Programming Errors: TypeError, ReferenceError, SyntaxError
4. Infrastructure Errors: Server down, slow network

---

**Remember**: "Error handling is not about preventing errors (that's impossible!) - it's about handling them gracefully when they DO occur!"
