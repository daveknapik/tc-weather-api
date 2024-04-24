require 'swagger_helper'

RSpec.describe 'forecasts', type: :request do

  path '/forecasts/{city}' do
    # You'll want to customize the parameter types...
    parameter name: 'city', in: :path, type: :string, description: 'city'

    get('show forecast') do
      response(200, 'successful') do
        let(:city) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
