# app/controllers/mdq_controller.rb

class MdqController < ApplicationController
  before_action :set_metadata_store

  def index
    entity_id = params[:entity_id]
    metadata = @metadata_store[entity_id]

    if metadata
      render xml: metadata
    else
      render plain: "Metadata not found", status: :not_found
    end
  end

  private

  # TODO: Replace this with a real metadata store, redis?
  
  def set_metadata_store
    @metadata_store = {
      "entity_id_1" => "<EntityDescriptor>...</EntityDescriptor>",
      "entity_id_2" => "<EntityDescriptor>...</EntityDescriptor>"
      # Add more metadata here
    }
  end
end
