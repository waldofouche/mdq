# SAML Metadata Query (MDQ) Service

This Rails application serves as a SAML Metadata Query (MDQ) service, allowing retrieval of metadata for entities based on their entity ID.

## Usage

### Prerequisites

- Ruby (version 2.7+ recommended)
- Rails (version 6.1+ recommended)
- Bundler gem (`gem install bundler` if not installed)

### Installation

1. Install dependencies:

   ```bash
   bundle install
   ```
   
2. Start the server:

   ```bash
   rails server
   ```
   
3. Access the MDQ service in your browser or via curl:

   ```bash
   curl http://localhost:3000/entities/<entity-id>
   ```
   
    Replace `<entity-id>` with the entity ID for which you want to retrieve metadata.

## Routes

- Retrieve Metadata: Use /entities/:entity_id to retrieve metadata for a specific entity.

- List All Entities: Use /entities to list all entities stored in the service.

## Seed Data

To seed the Redis datastore with sample entities, run the following rake task:

   ```bash
   rails redis:seed_entities
   ```

    This task will populate Redis with 50 sample Service Providers and 50 Identity Providers

## Background Job
ProcessMetadataJob

This application includes a background job ProcessMetadataJob that processes metadata from an external source and stores it in Redis for retrieval. This job is responsible for fetching metadata from a specified URL, processing it to extract individual entities, and storing them securely.
To enqueue this job, you can call it within your application or through scheduled tasks to keep your metadata updated and readily available for querying.
