json.array!(@products) do |product|
  json.extract! product, :name, :description, :published, :price
  #json.url product_url(product, format: :json)
end
