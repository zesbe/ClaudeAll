# Common Code Smells

## 1. Long Parameter List
```javascript
// Bad
function createUser(name, email, age, address, phone, role, department, startDate, endDate, salary) {
  // ...
}

// Good
function createUser({ name, email, age, address, phone, role, department, startDate, endDate, salary }) {
  // ...
}
```

## 2. Duplicate Code
```javascript
// Bad
function processOrderA(order) {
  if (order.total > 100) {
    order.discount = 0.1;
  }
}

function processOrderB(order) {
  if (order.total > 100) {
    order.discount = 0.1;
  }
}

// Good
function applyDiscount(order) {
  if (order.total > 100) {
    order.discount = 0.1;
  }
}

function processOrderA(order) {
  applyDiscount(order);
}

function processOrderB(order) {
  applyDiscount(order);
}
```

## 3. Magic Numbers
```javascript
// Bad
if (status === 1) {
  // active
}

if (timeout > 30000) {
  // error
}

// Good
const STATUS = {
  ACTIVE: 1,
  INACTIVE: 2
};

const TIMEOUT = 30000;

if (status === STATUS.ACTIVE) {
  // active
}

if (timeout > TIMEOUT) {
  // error
}
```

## 4. Large Classes/Methods
```javascript
// Bad
class User {
  // 500 lines of code doing everything
}

// Good
class User {
  constructor() {
    this.profile = new UserProfile();
    this.auth = new UserAuth();
    this.notifications = new UserNotifications();
  }
}
```

## 5. Feature Envy
```javascript
// Bad
class User {
  constructor() {
    this.name = name;
    this.email = email;
    this.saveToDatabase(); // Non-database concerns
    this.sendEmail();       // Notification concerns
  }
}

// Good
class User {
  constructor() {
    this.name = name;
    this.email = email;
  }

  async save() {
    await this.repository.save(this);
    this.eventEmitter.emit('user-saved', this);
  }
}