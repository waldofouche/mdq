# SAML Metadata Query (MDQ) Service

This Rails application serves as a SAML Metadata Query (MDQ) service, allowing retrieval of metadata for entities based on their entity ID.

## Usage

### Prerequisites

- Ruby (version 2.7+ recommended)
- Rails (version 6.1+ recommended)
- Bundler gem (`gem install bundler` if not installed)

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd mdq_service

2. Install dependencies:

   ```bash
   bundle install
   ```
   
3. Start the server:

   ```bash
   rails server
   ```
   
4. Access the MDQ service in your browser or via curl:

   ```bash
   curl http://localhost:3000/entities/<entity-id>
   ```
   
    Replace `<entity-id>` with the entity ID for which you want to retrieve metadata.
   
