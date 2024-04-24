require 'swagger_helper'

RSpec.describe 'forecasts', type: :request do
  path '/forecasts/{city}' do
    parameter name: 'city', in: :path, type: :string, description: 'city'
    parameter name: 'state', in: :query, type: :string, description: 'state'
    parameter name: 'country', in: :query, type: :string, description: 'country'

    get('show forecast') do
      response(200, 'successful') do
        let(:city) { 'Chicago' }
        let(:state) { 'IL' }
        let(:country) { 'US' }

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
        let(:state) { 'Strongbad' }
        let(:country) { 'US' }

        run_test! vcr: true
      end
    end
  end
end
