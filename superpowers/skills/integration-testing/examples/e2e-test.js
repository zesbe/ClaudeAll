// End-to-End Test Example
// Tests the complete user journey from registration to purchase

const { test, expect } = require('@playwright/test');

test.describe('E2E User Journey', () => {
  test.beforeEach(async ({ page }) => {
    // Set up test data
    await setupTestData();
  });

  test('user can register, login, and make a purchase', async ({ page }) => {
    // 1. Registration
    await page.goto('/register');

    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'SecurePass123!');
    await page.fill('[data-testid="confirmPassword"]', 'SecurePass123!');

    await page.click('[data-testid="register-button"]');

    // Verify successful registration
    await expect(page.locator('[data-testid="success-message"]'))
      .toContainText('Registration successful');

    // 2. Login
    await page.goto('/login');

    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'SecurePass123!');

    await page.click('[data-testid="login-button"]');

    // Verify logged in
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();

    // 3. Browse products
    await page.goto('/products');
    await page.click('[data-testid="product-card"]:first-child');

    // 4. Add to cart
    await page.click('[data-testid="add-to-cart"]');
    await expect(page.locator('[data-testid="cart-count"]'))
      .toContainText('1');

    // 5. Checkout
    await page.click('[data-testid="cart-icon"]');
    await page.click('[data-testid="checkout-button"]');

    // Fill shipping info
    await page.fill('[data-testid="shipping-address"]', '123 Test St');
    await page.fill('[data-testid="shipping-city"]', 'Test City');
    await page.fill('[data-testid="shipping-zip"]', '12345');

    // Add payment info
    await page.fill('[data-testid="card-number"]', '4242424242424242');
    await page.fill('[data-testid="card-expiry"]', '12/25');
    await page.fill('[data-testid="card-cvc"]', '123');

    await page.click('[data-testid="place-order"]');

    // Verify order confirmation
    await expect(page.locator('[data-testid="order-confirmation"]'))
      .toContainText('Order placed successfully');
    await expect(page.locator('[data-testid="order-number"]'))
      .toMatch(/ORD-\d+/);

    // 6. Verify order in user dashboard
    await page.goto('/dashboard/orders');
    await expect(page.locator('[data-testid="order-item"]'))
      .toContainText('ORD-');
  });

  test('handles errors gracefully', async ({ page }) => {
    // Test network error handling
    await page.route('/api/products', route => route.abort());

    await page.goto('/products');
    await expect(page.locator('[data-testid="error-message"]'))
      .toContainText('Failed to load products');

    // Test retry mechanism
    await page.unroute('/api/products');
    await page.click('[data-testid="retry-button"]');

    await expect(page.locator('[data-testid="product-list"]'))
      .toBeVisible();
  });

  test('maintains session across pages', async ({ page }) => {
    // Login
    await loginAsTestUser(page);

    // Navigate through different pages
    await page.goto('/products');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();

    await page.goto('/profile');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();

    await page.goto('/support');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();

    // Verify session persistence after refresh
    await page.reload();
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
  });

  test('real-time updates work correctly', async ({ page }) => {
    // Open two pages to test real-time features
    const context = page.context();
    const page2 = await context.newPage();

    // Login as user
    await loginAsTestUser(page);
    await loginAsTestUser(page2);

    // Start chat on first page
    await page.goto('/chat');
    await page.fill('[data-testid="message-input"]', 'Hello, world!');
    await page.click('[data-testid="send-button"]');

    // Verify message appears on second page
    await page2.goto('/chat');
    await expect(page2.locator('[data-testid="message-list"]'))
      .toContainText('Hello, world!');

    // Test typing indicators
    await page2.fill('[data-testid="message-input"]', 'Typing...');
    await expect(page.locator('[data-testid="typing-indicator"]'))
      .toContainText('User is typing...');
  });
});

// Helper functions
async function setupTestData() {
  // Initialize test database with required data
  // This could involve API calls or direct database operations
}

async function loginAsTestUser(page) {
  await page.goto('/login');
  await page.fill('[data-testid="email"]', 'test@example.com');
  await page.fill('[data-testid="password"]', 'SecurePass123!');
  await page.click('[data-testid="login-button"]');
  await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
}