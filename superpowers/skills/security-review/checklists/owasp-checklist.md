# OWASP Security Checklist

## Input Validation
- [ ] All inputs are validated
- [ ] Whitelisting is used instead of blacklisting
- [ ] Length limits are enforced
- [ ] Special characters are escaped

## Authentication & Authorization
- [ ] Password requirements are enforced
- [ ] Multi-factor authentication is implemented
- [ ] Session management is secure
- [ ] Authorization checks are performed on all endpoints

## Injection Prevention
- [ ] Parameterized queries are used
- [ ] ORM is used with proper escaping
- [ ] Input encoding is performed
- [ ] Stored procedures are used when appropriate

## XSS Protection
- [ ] Output encoding is implemented
- [ ] Content Security Policy is set
- [ ] HttpOnly cookies are used
- [ ] Framework's XSS protection is enabled

## CSRF Protection
- [ ] Anti-CSRF tokens are implemented
- [ ] SameSite cookie attribute is set
- [ ] Referer checking is implemented
- [ ] Double submit cookies are used