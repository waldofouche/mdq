# lib/tasks/seed_redis.rake

namespace :redis do
  desc "Seed Redis datastore with 50 entities"
  task seed_entities: :environment do
    require 'faker' # If you want to generate fake data

    50.times do |index|
      entity_id = "entity_#{index + 1}"
      metadata = generate_metadata(entity_id) # Implement your metadata generation logic

      $redis.set("metadata:#{entity_id}", metadata)
    end

    puts "Successfully seeded Redis with 50 entities"
  end
end

def generate_metadata(entity_id)
  # Implement your metadata generation logic here
  # Example: Generating dummy XML metadata
  metadata = "<EntityDescriptor entityID=\"#{entity_id}\"><Organization/></EntityDescriptor>"
  metadata
end
