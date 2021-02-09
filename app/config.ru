# frozen_string_literal: true

require 'rack'
require 'json'
require './app/controllers/api/health_api_controller'

# じゃんけんのウェブアプリケーション
class JankenWebApplication
  HEADER = {
    'Content-Type' => 'text/plain'
  }.freeze

  def initialize
    @health_api_controller = HealthApiController.new
  end

  def call(env)
    request = Rack::Request.new(env)

    response =
      if request.path == '/api/health'
        body = @health_api_controller.index
        Rack::Response.new(body.to_json, 200, HEADER)
      else
        body = { status: 404 }
        Rack::Response.new(body.to_json, 404, HEADER)
      end

    response.finish
  end
end

run JankenWebApplication.new
