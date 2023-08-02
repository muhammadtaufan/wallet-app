require 'net/http'
require 'uri'

class HttpClient
  def initialize(api_host, default_headers = {})
    @api_host = api_host
    @default_headers = default_headers
  end

  def get(path, params = {}, headers = {})
    uri = URI.parse("#{@api_host}#{path}")
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, merged_headers(headers))
    response = http.request(request)
    JSON.parse(response.body)
  end

  private

  def merged_headers(headers)
    @default_headers.merge(headers)
  end
end
