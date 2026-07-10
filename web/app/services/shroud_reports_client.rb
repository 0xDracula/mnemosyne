require "net/http"
require "json"
require "uri"

class ShroudReportsClient
  class Error < StandardError; end

  def initialize(base_url: ENV.fetch("SHROUD_API_URL"), token: ENV.fetch("SHROUD_API_TOKEN"))
    @base_url = base_url
    @token = token
  end

  def list(limit: 50, unresolved: false)
    request(:get, "/api/v1/reports", params: { limit: limit, unresolved: unresolved })
  end

  def find(id)
    request(:get, "/api/v1/reports/#{id}")
  end

  def create(content:, blocks: nil)
    request(:post, "/api/v1/reports", body: { content: content, blocks: blocks }.compact)
  end

  def update(id, fields)
    request(:patch, "/api/v1/reports/#{id}", body: fields)
  end

  private

  def request(method, path, params: nil, body: nil)
    uri = URI.join(@base_url, path)
    uri.query = URI.encode_www_form(params) if params

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    req = build_request(method, uri, body)
    req["Authorization"] = "Bearer #{@token}"
    req["Content-Type"] = "application/json" if body

    handle_response(http.request(req))
  end

  def build_request(method, uri, body)
    klass = { get: Net::HTTP::Get, post: Net::HTTP::Post, patch: Net::HTTP::Patch }.fetch(method)
    req = klass.new(uri)
    req.body = body.to_json if body
    req
  end

  def handle_response(response)
    case response
    when Net::HTTPNotFound
      nil
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise Error, "Shroud API error #{response.code}: #{response.body}"
    end
  end
end
