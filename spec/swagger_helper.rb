require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'

  # TODO: extract to separate files if it grows
  scheme_offer = {
    type: 'object',
    properties: {
      id: { type: 'number' },
      title: { type: 'string' },
      description: { type: 'string' },
      price: { type: 'number' },
      picture: {
        type: 'object',
        nullable: true,
        properties: {
          thumb: { type: 'string' },
          original: { type: 'string' }
        }
      },
      created_at: { type: 'string', format: 'datetime' },
      updated_at: { type: 'string', format: 'datetime' }
    }
  }
  scheme_user = {
    type: 'object',
    properties: {
      id: { type: 'integer' },
      name: { type: 'string' },
      email: { type: 'string' },
      is_active: { type: 'boolean' },
      created_at: { type: 'string', format: 'datetime' },
      updated_at: { type: 'string', format: 'datetime' }
    }
  }

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: { title: 'API V1', version: 'v1' },
      paths: {},
      servers: [{ url: 'http://localhost:3000' }],
      security: [
        bearerAuth: []
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        },
      },
      definitions: {
        offer: scheme_offer,
        user: scheme_user
      }
    },
    'v2/swagger.yaml' => {
      swagger: '2.0',
      info: { title: 'API V2', version: 'v2' },
      paths: {},
      servers: [{ url: 'http://localhost:3000' }],
      security: [
        bearerAuth: []
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        },
      },
      definitions: {
        offer: scheme_offer,
        user: scheme_user
      }
    }
  }
end
