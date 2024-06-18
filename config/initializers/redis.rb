# frozen_string_literal: true

# config/initializers/redis.rb

# Establish a Redis connection based on Rails environment
$redis = if Rails.env.production? || Rails.env.staging?
           Redis.new(url: ENV['REDIS_URL'])
         else
           Redis.new(host: 'localhost', port: 6379, db: 0)
         end

# Create a Redis namespace for better key management (optional)
# redis_namespace = Redis::Namespace.new(:mdq_service, redis: $redis)
# To use with a namespace, replace $redis with redis_namespace in your application

# Optionally, define a helper method to access Redis
# def redis
#   $redis
# end
