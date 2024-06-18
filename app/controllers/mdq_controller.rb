# frozen_string_literal: true

class MdqController < ApplicationController
  def index
    entity_id = params[:entity_id]
    key = url_safe_encode(entity_id)
    metadata = $redis.get("metadata:#{key}")

    if metadata
      render xml: metadata
    else
      render plain: 'Not Found', status: :not_found
    end
  end

  private

  def url_safe_encode(entity_id)
    CGI.escape(entity_id)
  end
end
