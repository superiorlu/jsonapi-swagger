# JSONAPI Swagger

Generate JSONAPI Swagger Doc.

[![Gem Version](https://img.shields.io/gem/v/jsonapi-swagger.svg)](https://rubygems.org/gems/jsonapi-swagger)
[![GitHub license](https://img.shields.io/github/license/superiorlu/jsonapi-swagger.svg)](https://github.com/superiorlu/jsonapi-swagger/blob/master/LICENSE)

[![jsonapi-swagger-4-2-9.gif](https://i.loli.net/2019/05/05/5ccebf5e782b7.gif)](https://i.loli.net/2019/05/05/5ccebf5e782b7.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-swagger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi-swagger

## Usage

 1. config jsonapi swagger
```rb
# config/initializers/swagger.rb
Jsonapi::Swagger.config do |config|
  config.use_rswag = false
  config.version = '2.0'
  config.info = { title: 'API V1', version: 'V1'}
  config.file_path = 'v1/swagger.json'
end
```

2. generate swagger.json

```sh
# gen swagger/v1/swagger.json
bundle exec rails generate jsonapi:swagger User # UserResponse < JSONAPI::Resource
```

3. additional

 use `rswag`, have to run

```sh
# gen swagger/v1/swagger.json
 bundle exec rails rswag:specs:swaggerize
```

## RoadMap

- [x] immutable resources
- [x] filter/sort resources
- [x] mutable resources
- [x] generate swagger.json without rswag

## Resource

- [JSONAPI](https://jsonapi.org/)
- [JSONAPI::Resources](http://jsonapi-resources.com/)
- [Rswag](https://github.com/domaindrivendev/rswag)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/superiorlu/jsonapi-swagger.
