require 'swagger_helper'

RSpec.describe 'forecasts', type: :request do
  path '/forecasts/{city}' do
    # You'll want to customize the parameter types...
    parameter name: 'city', in: :path, type: :string, description: 'city'
    parameter name: 'state', in: :query, type: :string, description: 'state'
    parameter name: 'country', in: :query, type: :string, description: 'country'

    get('show forecast') do
      response(200, 'successful') do
        let(:city) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test! vcr: true
      end

      response(404, 'location not found') do
        let(:city) { 'fhgwagads' }
        run_test! vcr: true
      end
    end
  end
end
