# lib/tasks/seed_redis.rake

namespace :redis do
  desc "Seed Redis datastore with 50 entities"
  task seed_entities: :environment do
    require 'faker' # If you want to generate fake data

    # Service Providers
    50.times do 
      entity_id = "https://#{Faker::Internet.domain_name}/idp/shibboleth"
      metadata = generate_metadata(entity_id) # Implement your metadata generation logic

      $redis.set("metadata:#{entity_id}", metadata)
    end

    # Identity Providers
    50.times do
      entity_id = "https://app.#{Faker::Internet.domain_name}/shibboleth"
      metadata = generate_metadata(entity_id) # Implement your metadata generation logic

      $redis.set("metadata:#{entity_id}", metadata)
    end

    puts "Successfully seeded Redis with 50 Service Providers and 50 Identity Providers"
  end
end

def generate_metadata(entity_id)
  # Implement your metadata generation logic here
  # Example: Generating dummy XML metadata
  metadata = "<EntityDescriptor entityID=\"#{entity_id}\"><Organization/></EntityDescriptor>"
  metadata
end
