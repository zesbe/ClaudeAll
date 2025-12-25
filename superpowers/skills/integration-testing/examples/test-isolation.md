# Test Isolation Best Practices

## 1. Database Isolation

### Using Test Containers
```javascript
// test-setup.js
const { setup, teardown } = require('jest-dev-server');

beforeAll(async () => {
  await setup({
    command: `docker run --name test-db -e POSTGRES_PASSWORD=test -p 5433:5432 -d postgres:13`,
    port: 5433,
    usedPortAction: 'ignore',
  });
});

afterAll(async () => {
  await teardown();
  await exec('docker rm -f test-db');
});
```

### Database Transactions
```javascript
// Each test runs in its own transaction
beforeEach(async () => {
  await db.query('BEGIN');
});

afterEach(async () => {
  await db.query('ROLLBACK');
});
```

## 2. Mock External Services

### Service Virtualization
```javascript
// jest.config.js
module.exports = {
  setupFilesAfterEnv: ['./test/setup/mocks.js'],
};

// test/setup/mocks.js
jest.mock('./services/payment', () => ({
  processPayment: jest.fn().mockResolvedValue({
    success: true,
    transactionId: 'tx_12345',
  }),
}));
```

## 3. Test Data Management

### Factory Pattern
```javascript
// factories/user-factory.js
class UserFactory {
  static create(overrides = {}) {
    return {
      id: faker.datatype.uuid(),
      name: faker.name.findName(),
      email: faker.internet.email(),
      createdAt: new Date(),
      ...overrides,
    };
  }

  static async createInDatabase(overrides = {}) {
    const user = this.create(overrides);
    return await UserModel.create(user);
  }
}
```

## 4. Parallel Test Execution

### Test Sharding
```bash
# Run tests in parallel
jest --runInBand=false --shard=1/3
jest --runInBand=false --shard=2/3
jest --runInBand=false --shard=3/3
```

### Unique Test Data
```javascript
// Ensure unique data for parallel tests
const uniqueId = `${process.env.JEST_WORKER_ID}-${Date.now()}`;
const testData = {
  email: `test-${uniqueId}@example.com`,
};
```