# app/controllers/mdq_controller.rb

class MdqController < ApplicationController
  def index
    entity_id = params[:entity_id]
    metadata = $redis.get("metadata:#{entity_id}")

    if metadata
      render xml: metadata
    else
      render plain: "Not Found", status: :not_found
    end
  end

  def update_metadata
    entity_id = params[:entity_id]
    metadata = params[:metadata]

    $redis.set("metadata:#{entity_id}", metadata)

    render plain: "Metadata updated successfully"
  end
end
