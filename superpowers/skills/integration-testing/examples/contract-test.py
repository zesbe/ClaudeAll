# Provider Contract Test Example
# Verifies API contract between frontend and backend services

import pytest
import json
from pact import Consumer, Provider
from utils.api_client import APIClient
from utils.test_data import generate_test_order

# Define contract
pact = Consumer('WebApp').has_pact_with(Provider('OrderService'))

def test_create_order_contract():
  """Test contract for creating an order"""

  expected_order = {
    "id": 12345,
    "customer_id": "CUST-001",
    "items": [
      {
        "product_id": "PROD-001",
        "quantity": 2,
        "price": 29.99
      }
    ],
    "total": 59.98,
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }

  (pact
   .given('customer CUST-001 exists')
   .upon_receiving('a request to create an order')
   .with_request(
       method='POST',
       path='/api/orders',
       headers={
           'Content-Type': 'application/json',
           'Authorization': pact.term('Bearer .*', 'Bearer token123')
       },
       body={
           'customer_id': 'CUST-001',
           'items': [
               {
                   'product_id': 'PROD-001',
                   'quantity': 2
               }
           ]
       }
   )
   .will_respond_with(
       status=201,
       headers={
           'Content-Type': 'application/json'
       },
       body=expected_order
   ))

  with pact:
    # Make actual request against mock server
    client = APIClient(base_url=pact.uri)
    response = client.create_order({
      'customer_id': 'CUST-001',
      'items': [
        {
          'product_id': 'PROD-001',
          'quantity': 2
        }
      ]
    }, headers={
      'Authorization': 'Bearer token123'
    })

    # Verify response
    assert response.status_code == 201
    assert response.json() == expected_order

def test_get_products_contract():
  """Test contract for fetching products"""

  expected_products = {
    "products": [
      {
        "id": "PROD-001",
        "name": "Test Product",
        "price": 29.99,
        "stock": 100,
        "category": "electronics"
      }
    ],
    "pagination": {
      "page": 1,
      "per_page": 10,
      "total": 1,
      "total_pages": 1
    }
  }

  (pact
   .given('products exist in the database')
   .upon_receiving('a request to get products list')
   .with_request(
       method='GET',
       path='/api/products',
       query={
           'page': '1',
           'per_page': '10',
           'category': 'electronics'
       }
   )
   .will_respond_with(
       status=200,
       headers={
           'Content-Type': 'application/json'
       },
       body=expected_products
   ))

  with pact:
    client = APIClient(base_url=pact.uri)
    response = client.get_products(
      page=1,
      per_page=10,
      category='electronics'
    )

    assert response.status_code == 200
    assert response.json() == expected_products

def test_error_response_contract():
  """Test contract for error scenarios"""

  error_response = {
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Invalid input data",
      "details": [
        {
          "field": "email",
          "message": "Invalid email format"
        }
      ]
    }
  }

  (pact
   .upon_receiving('a request with invalid data')
   .with_request(
       method='POST',
       path='/api/users',
       headers={'Content-Type': 'application/json'},
       body={
         'email': 'invalid-email',
         'name': ''
       }
   )
   .will_respond_with(
       status=400,
       headers={'Content-Type': 'application/json'},
       body=error_response
   ))

  with pact:
    client = APIClient(base_url=pact.uri)
    response = client.create_user({
      'email': 'invalid-email',
      'name': ''
    })

    assert response.status_code == 400
    assert response.json() == error_response

@pytest.fixture
def pact_setup(request):
  """Setup Pact contract testing"""

  # Start mock service
  pact.start_service()

  # Ensure pact is verified after each test
  request.addfinalizer(lambda: pact.verify())
  request.addfinalizer(lambda: pact.stop_service())

class TestAPIIntegration:
  """Integration tests with real API service"""

  @pytest.mark.integration
  def test_full_order_flow(self):
    """Test complete order processing flow"""

    # 1. Create customer
    customer = APIClient().create_customer({
      'name': 'Test Customer',
      'email': 'test@example.com',
      'address': '123 Test St'
    })
    assert customer.status_code == 201
    customer_id = customer.json()['id']

    # 2. Create order
    order_data = generate_test_order(customer_id)
    order = APIClient().create_order(order_data)
    assert order.status_code == 201
    order_id = order.json()['id']

    # 3. Process payment
    payment = APIClient().process_payment({
      'order_id': order_id,
      'amount': order.json()['total'],
      'payment_method': 'credit_card'
    })
    assert payment.status_code == 200

    # 4. Verify order status updated
    updated_order = APIClient().get_order(order_id)
    assert updated_order.status_code == 200
    assert updated_order.json()['status'] == 'paid'

    # 5. Trigger shipping
    shipment = APIClient().create_shipment({
      'order_id': order_id,
      'carrier': 'ups',
      'tracking_number': '1Z9999W99999999999'
    })
    assert shipment.status_code == 201

    # 6. Verify final order status
    final_order = APIClient().get_order(order_id)
    assert final_order.json()['status'] == 'shipped'
    assert 'tracking_number' in final_order.json()['shipment']

  @pytest.mark.integration
  def test_database_transaction_consistency(self):
    """Test that database transactions are consistent across services"""

    # This test would check that related microservices maintain consistency
    # Example: When an order is cancelled, inventory is restored and payment is refunded

    # Create order with items
    order_data = generate_test_order()
    response = APIClient().create_order(order_data)
    order_id = response.json()['id']

    # Check inventory reduced
    for item in order_data['items']:
      inventory = APIClient().get_inventory(item['product_id'])
      assert inventory.json()['available'] < 100

    # Cancel order
    cancel_response = APIClient().cancel_order(order_id)
    assert cancel_response.status_code == 200

    # Verify inventory restored
    for item in order_data['items']:
      inventory = APIClient().get_inventory(item['product_id'])
      assert inventory.json()['available'] == 100

    # Verify refund processed
    refund = APIClient().get_refund(order_id)
    assert refund.json()['status'] == 'processed'

@pytest.mark.contract
class TestMessageContract:
  """Test message contracts between services"""

  def test_user_event_contract(self):
    """Test user event message structure"""

    expected_message = {
      'event_type': 'user_created',
      'user_id': 'USR-12345',
      'timestamp': pact.term(
        matcher=r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z',
        generator='2024-01-15T10:30:00Z'
      ),
      'data': {
        'email': 'test@example.com',
        'name': 'Test User'
      }
    }

    (pact
     .upon_receiving('user created event')
     .with_request(
         method='POST',
         path='/api/events',
         headers={'Content-Type': 'application/json'},
         body=expected_message
     )
     .will_respond_with(status=202))

  def test_order_status_update_contract(self):
    """Test order status update message"""

    (pact
     .given('order 12345 exists')
     .upon_receiving('order status update')
     .with_request(
         method='PATCH',
         path='/api/orders/12345/status',
         body={
           'status': 'shipped',
           'tracking_number': '1Z9999W99999999999'
         }
     )
     .will_respond_with(
         status=200,
         body={
           'order_id': 12345,
           'status': 'shipped',
           'tracking_number': '1Z9999W99999999999',
           'updated_at': pact.term(
             matcher=r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z',
             generator='2024-01-15T11:00:00Z'
           )
         }
     ))