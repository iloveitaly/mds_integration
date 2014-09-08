def sample_credentials
  {
    "client_code"=>"TESTING_CODE_HERE",
    "client_signature"=>"TESTING_SIGNATURE_HERE",
    "test_mode"=>"true"
  }.with_indifferent_access
end

def sample_order(order_number = "R#{rand(999999)}")
  {
    "id"=>order_number,
    "status"=>"complete",
    "channel"=>"spree",
    "email"=>"spree@example.com",
    "currency"=>"USD",
    "placed_on"=>"2014-02-03T17:29:15.219Z",
    "totals"=>
    {"item"=>200,
      "adjustment"=>20,
      "tax"=>10,
      "shipping"=>10,
      "payment"=>220,
      "order"=>220},
      "line_items"=>
    [{"product_id"=>"QTRZIM03",
      "name"=>"QTRZIM03",
      "quantity"=>2,
      "price"=>100}],
      "adjustments"=>
    [{"name"=>"Tax", "value"=>10},
      {"name"=>"Shipping", "value"=>5},
      {"name"=>"Shipping", "value"=>5}],
      "shipping_address"=>
    {"firstname"=>"Joe",
      "lastname"=>"Smith",
      "address1"=>"1234 Awesome Street",
      "address2"=>"",
      "zipcode"=>"90210",
      "city"=>"Hollywood",
      "state"=>"California",
      "country"=>"US",
      "phone"=>"0000000000"},
      "billing_address"=>
    {"firstname"=>"Joe",
      "lastname"=>"Smith",
      "address1"=>"1234 Awesome Street",
      "address2"=>"",
      "zipcode"=>"90210",
      "state"=>"California",
      "country"=>"US",
      "phone"=>"0000000000"},
      "payments"=>
    [{"number"=>63,
      "status"=>"completed",
      "amount"=>220,
      "payment_method"=>"Credit Card"}]
  }.merge(order_extra_fields).with_indifferent_access
end

def order_extra_fields
  {
    "shipping_method" => "US UPS Two Day"
  }
end
