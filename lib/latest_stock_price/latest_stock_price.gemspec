require_relative "lib/latest_stock_price/version"

Gem::Specification.new do |spec|
  spec.name          = "latest_stock_price"
  spec.version       = LatestStockPrice::VERSION
  spec.authors       = [ "Ajeng" ]
  spec.email         = [ "ajeng.dev@gmail.com" ]

  spec.summary       = "A brief summary of latest_stock_price"
  spec.description   = "A more detailed description of latest_stock_price"
  spec.homepage      = "https://example.com/latest_stock_price"
  spec.license       = "MIT"

  # Specify the dependencies
  spec.add_dependency "httparty", "~> 0.18"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"

  # Files to be included in the gem
  spec.files         = Dir["lib/**/*", "README.md"]

  # Executables, if any
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  # Test files, if you include tests
  spec.test_files    = Dir["spec/**/*"]

  # Add other metadata as needed
end
