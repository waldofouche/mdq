# frozen_string_literal: true

# lib/tasks/seed_redis.rake

namespace :redis do
  
  desc 'Seed Redis datastore with 50 entities'
  task seed_entities: :environment do
    require 'faker' # If you want to generate fake data

    # Service Providers
    50.times do
      entity_id = "https://#{Faker::Internet.domain_name}/idp/shibboleth"
      metadata = generate_sp_metadata(entity_id) # Implement your metadata generation logic

      $redis.set("metadata:#{CGI.escape(entity_id)}", metadata)
    end

    # Identity Providers
    50.times do
      entity_id = "https://app.#{Faker::Internet.domain_name}/shibboleth"
      metadata = generate_idp_metadata(entity_id) # Implement your metadata generation logic

      $redis.set("metadata:#{CGI.escape(entity_id)}", metadata)
    end

    puts 'Successfully seeded Redis with 50 Service Providers and 50 Identity Providers'
  end
  

  def generate_sp_metadata(entity_id)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.EntityDescriptor('xmlns': 'urn:oasis:names:tc:SAML:2.0:metadata', 'entityID': entity_id) {
        xml.Extensions {
          xml.RegistrationInfo('registrationAuthority': 'https://example.com', 'registrationInstant': '2017-11-29T06:59:30Z') {
            xml.RegistrationPolicy('lang': 'en', 'xml:space': 'preserve') {
              xml.text 'https://example.com/media/metadata/v1.1.pdf'
            }
          }
        }
        xml.SPSSODescriptor('protocolSupportEnumeration': 'urn:oasis:names:tc:SAML:2.0:protocol') {
          xml.Extensions {
            xml.UIInfo {
              xml.DisplayName('lang': 'en') {
                xml.text "#{Faker::Company.name}"
              }
              xml.Description('lang': 'en') {
                xml.text "#{Faker::Lorem.sentence}"
              }
            }
            xml.DiscoveryResponse('Binding': 'urn:oasis:names:tc:SAML:profiles:SSO:idp-discovery-protocol', 'Location': "#{entity_id}/Shibboleth.sso/Login", 'index': '0', 'isDefault': 'true')
          }
          xml.KeyDescriptor('use': 'encryption') {
            xml.KeyInfo {
              xml.X509Data {
                xml.X509SubjectName {
                  xml.text 'CN=example.com'
                }
                xml.X509Certificate {
                  xml.text "MIIEODC.... [certificate content]"
                }
              }
            }
          }
          xml.KeyDescriptor('use': 'signing') {
            xml.KeyInfo {
              xml.X509Data {
                xml.X509SubjectName {
                  xml.text 'CN=example.com'
                }
                xml.X509Certificate {
                  xml.text 'MIIEODCCAq... [certificate content]'
                }
              }
            }
          }
          xml.SingleLogoutService('Binding': 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST', 'Location': 'https://example.com/Shibboleth.sso/SLO/POST')
          xml.ManageNameIDService('Binding': 'urn:oasis:names:tc:SAML:2.0:bindings:SOAP', 'Location': 'https://example.com/Shibboleth.sso/NIM/SOAP')
          xml.NameIDFormat('urn:oasis:names:tc:SAML:2.0:nameid-format:transient')
          xml.AssertionConsumerService('Binding': 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST', 'Location': 'https://example.comShibboleth.sso/SAML2/POST', 'index': '1', 'isDefault': 'true')
          xml.AttributeConsumingService('index': '1', 'isDefault': 'true') {
            xml.ServiceName('lang': 'en') {
              xml.text "#{Faker::Company.name}"
            }
            xml.RequestedAttribute('FriendlyName': 'auEduPersonAffiliation', 'Name': 'urn:oid:1.3.6.1.4.1.27856.1.2.1', 'NameFormat': 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri', 'isRequired': 'false')
            xml.RequestedAttribute('FriendlyName': 'auEduPersonLegalName', 'Name': 'urn:oid:1.3.6.1.4.1.27856.1.2.2', 'NameFormat': 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri', 'isRequired': 'false')
          }
        }
        xml.Organization {
          xml.OrganizationName('lang': 'en') {
            xml.text 'example.com'
          }
          xml.OrganizationDisplayName('lang': 'en') {
            xml.text "#{Faker::Company.name}"
          }
          xml.OrganizationURL('lang': 'en') {
            xml.text 'https://www.example.com'
          }
        }
        xml.ContactPerson('contactType': 'technical') {
          xml.Company {
            xml.text "#{Faker::Company.name}"
          }
          xml.GivenName {
            xml.text 'James'
          }
          xml.SurName {
            xml.text "Bond"
          }
          xml.EmailAddress {
            xml.text "mailto:#{Faker::Internet.email}"
          }
        }
      }
    end
    builder.to_xml(indent: 2)
  end

  def generate_idp_metadata(entity_id)
  # Implement your metadata generation logic here
  # Example: Generating dummy XML metadata
  "<EntityDescriptor entityID=\"#{entity_id}\"><Organization/></EntityDescriptor>"
  end
end
