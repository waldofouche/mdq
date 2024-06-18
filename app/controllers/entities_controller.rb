# app/controllers/entities_controller.rb

class EntitiesController < ApplicationController
  MAX_ENTITIES = 1000 # Example maximum number of entities

  def index
    entity_ids = fetch_entity_ids_from_redis

    render json: { entity_ids: entity_ids }
  end

  private

  def fetch_entity_ids_from_redis
    # Limit the number of keys fetched to MAX_ENTITIES
    keys = $redis.keys('metadata:*').first(MAX_ENTITIES)
    entity_ids = keys.map { |key| key.split(':').last }

    entity_ids
  end
end
