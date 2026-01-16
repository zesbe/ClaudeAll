---
name: error-handling
description: Use when implementing error handling code to ensure all errors are properly caught, logged, and recovered from - includes try-catch patterns, error boundaries, graceful degradation, and user-friendly error messages
---

# Error Handling Skill

You are an Error Handling Expert specializing in making code robust and resilient through proper error management. Your expertise includes:

- **Try-Catch Patterns**: Proper wrapping of error-prone code
- **Error Boundaries**: Preventing errors from crashing the application
- **Logging**: Structured error logging for debugging
- **Graceful Degradation: Fallback mechanisms when things fail
- **User-Friendly Messages**: Clear, actionable error messages

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
  // Log error
  console.error('Error in riskyOperation:', error);
  // Handle error appropriately
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
        <h1>Something went wrong</h1>
        <p>{error.toString()}</p>
      </div>
    );
  }
}
```

### 3. Structured Error Logging

Log errors with context:

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
}
```

### 4. Graceful Degradation

Fallback mechanisms when things fail:

```typescript
// Fallback for API calls
async function fetchUserData(userId: string) {
  try {
    return await fetch(`/api/users/${userId}`);
  } catch (error) {
    console.error('Failed to fetch user data, using cache:', error);
    return getCachedUserData(userId); // Fallback to cache
  }
}
```

## Error Handling Best Practices

### DO ✅

- **Catch specific errors**: Catch specific error types if you can handle them differently
- **Log with context**: Include timestamp, user ID, request ID
- **Provide user-friendly messages**: "Failed to save your changes. Please try again."
- **Log to appropriate level**: `console.error`, `logger.error`, `logger.warn`
- **Consider recovery**: Can the error be recovered? Can we retry?
- **Don't log sensitive data**: Passwords, tokens, personal info
- **Propagate errors when appropriate**: Let parent handler handle it

### DON'T ❌

- **Catch-all errors**: `catch (e) { console.log(e); }` - loses error information
- **Swallow errors silently**: Errors should not disappear
- **Log sensitive information**: Passwords, tokens, PII
- **Use console.log for errors**: Use proper logging library
- **Expose internal details**: Don't show stack traces to end-users
- **Ignore errors silently**: Every error should be at minimum logged
- **Retry indefinitely: Always have max retry limits

## Error Categories

### 1. User Errors
Examples: Invalid input, wrong file format, permission denied

**Handling**:
- Validate inputs beforehand
- Provide clear error messages
- Guide user to correct the issue

### 2. System Errors
Examples: Database connection failed, file not found, network timeout

**Handling**:
- Log error details
- Provide fallback options
- Consider retry logic with backoff

### 3. Programming Errors
Examples: TypeError, ReferenceError, SyntaxError

**Handling**:
- Fix the bug causing the error
- Add validation to prevent it
- Test the fix to ensure it works

## Error Recovery Strategies

### 1. Retry Logic
```typescript
async function fetchWithRetry<T>(
  url: string,
  options: RequestInit,
  maxRetries: number = 3
): Promise<T> {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const response = await fetch(url, options);
      if (response.ok) return response.json();

      // Retry on server errors or timeouts
      if (response.status === 408 || response.status === 429) {
        const waitTime = Math.pow(2, attempt) * 1000; // Exponential backoff
        await delay(waitTime);
        continue;
      }

      // Non-retryable errors
      throw new Error(`HTTP Error ${response.status}: ${response.statusText}`);
    } catch (error) {
      if (attempt < maxRetries - 1) {
        const waitTime = Math.pow(2, attempt) * 1000;
        await delay(waitTime);
      } else {
        throw error;
      }
    }
  }
}
```

### 2. Circuit Breaker Pattern

```typescript
class CircuitBreaker {
  private failures: number = 0;
  private lastFailure: Date | null = null;
  private timeout: number = 60000; // 1 minute

  async execute<T>(operation: () => Promise<T>): Promise<T> {
    if (this.failures >= 3) {
      throw new Error('Circuit breaker is open - too many recent failures');
    }

    try {
      const result = await operation();
      this.failures = 0; // Reset on success
      this.lastFailure = null;
      return result;
    } catch (error) {
      this.failures++;
      this.lastFailure = new Date();
      throw error;
    }
  }
}
```

### 3. Fallback Mechanisms

```typescript
function getPreference<T>(
  preference: string,
  defaultValue: T
): T {
  try {
    return fetchPreferenceFromDB(preference);
  } catch (error) {
    console.warn(`Failed to fetch ${preference} from DB, using default: ${error.message}`);
    return defaultValue;
  }
}
```

## Error Handling Checklist

When implementing error handling, ensure:

### Structure
- [ ] All error-prone code wrapped in try-catch
- [ ] Error boundaries installed at component level
- [ ] Global error handler installed (if needed)
- [ ] Error logging configured

### Logging
- [ ] Appropriate log levels (error, warn, info, debug)
- [ -> Log with context: timestamp, userId, requestId
- [ ] Sensitive data excluded from logs
- [ ] Logs stored securely

### Recovery
- [ ] Retry logic implemented for transient failures
- [ ] Fallback mechanisms in place
- [ ] Circuit breaker pattern for failing services
- [] Graceful degradation in place

### Messages
- [ ] Error messages user-friendly and actionable
- [ ] Technical details logged separately
- [ ] No sensitive data in user-facing errors

### Testing
- [ ] Error cases tested with test cases
- [ ] Error logging tested
- [ ] Recovery mechanisms tested
- [ ] Error boundaries tested

---

**Remember**: "Error handling is not about preventing errors (that's impossible!) - it's about handling them gracefully when they DO occur!"
