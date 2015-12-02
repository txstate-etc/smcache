class ApplicationController < ActionController::API

  protected 
  def proxy(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    send_data response.body, 
      content_type: response['Content-Type'], 
      disposition: "inline",
      status: response.code
  end
end
