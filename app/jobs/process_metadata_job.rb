# frozen_string_literal: true

# app/jobs/process_metadata_job.rb

require 'httparty'
require 'nokogiri'
require 'cgi' # Required for URL encoding

class ProcessMetadataJob < ApplicationJob
  queue_as :default

  def perform(url)
    response = HTTParty.get(url)

    if response.success?
      xml_data = response.body
      process_xml_data(xml_data)
    else
      puts "Failed to fetch XML data from #{url}: #{response.code} - #{response.message}"
    end
  rescue StandardError => e
    puts "Error processing metadata: #{e.message}"
  end

  private

  def process_xml_data(xml_data)
    doc = Nokogiri::XML(xml_data)
    doc.remove_namespaces! # Remove namespaces to simplify XPath queries

    entities = doc.xpath('//EntityDescriptor')
    entities.each do |entity|
      entity_id = entity.attr('entityID')
      encoded_entity_id = url_safe_encode(entity_id) # Encode entityID
      metadata = entity.to_xml

      existing_metadata = $redis.get("metadata:#{encoded_entity_id}")

      if existing_metadata.present?
        # Append or update existing metadata
        updated_metadata = merge_metadata(existing_metadata, metadata)
        $redis.set("metadata:#{encoded_entity_id}", updated_metadata)
        puts "Updated metadata for key metadata:#{encoded_entity_id}"
      else
        # If no existing metadata, set it directly
        $redis.set("metadata:#{encoded_entity_id}", metadata)
        puts "New metadata added for key metadata:#{encoded_entity_id}"
      end
    end
  end

  def merge_metadata(existing_metadata, new_metadata)
    # Implement your merge logic here if needed
    # Example: Concatenate or merge XML strings
    existing_metadata + new_metadata
  end

  def url_safe_encode(entity_id)
    CGI.escape(entity_id)
  end
end
