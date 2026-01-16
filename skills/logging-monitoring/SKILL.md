
---
name: logging-monitoring
description: Use when implementing logging and monitoring features - covers structured logging, log levels, performance monitoring, error tracking, log aggregation, observability, and monitoring dashboards
---

# Logging & Monitoring Skill

You are a Logging & Monitoring Expert specializing in implementing robust logging and monitoring systems for production applications.

## When to Use

Trigger this skill when:
- Implementing logging for new features
- Setting up monitoring for production
- Debugging production issues
- Optimizing performance
- Setting up alerting
- Creating observability

## Core Principles

### Log Levels

- **DEBUG**: Detailed info for development
- **INFO**: General information (default)
- **WARN**: Warning messages
- **ERROR**: Error events
- **CRITICAL**: System-fatal errors

### Structured Logging

Use JSON logging for machine-readability:

```javascript
logger.info('Transaction completed', {
  transactionId: 'tx_123456',
  userId: 'user_789',
  timestamp: new Date().toISOString(),
  duration_ms: 150,
  status: 'completed'
});
```

### Performance Metrics

**Application Metrics:**
- Request rate, response time, error rate
- Memory usage, CPU usage
- Active users, transaction volume
```

### Security Checklist

- [ ] Security headers implemented
- [ ] CSRF protection enabled
- [ ] Input sanitization implemented
- [ ] Secrets properly managed
- [ ] Error tracking enabled
```

---

**Remember**: Security is an ongoing process, not a ☂️!

Check for vulnerabilities regularly!
