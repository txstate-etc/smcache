class ApplicationController < ActionController::API

  protected 
  def proxy(url)
    logger.debug "Proxying to #{url}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    proxy_request = Net::HTTP::Get.new(uri.request_uri)
    proxy_response = http.request(proxy_request)
    send_data proxy_response.body, 
      content_type: proxy_response['Content-Type'], 
      disposition: "inline",
      status: proxy_response.code
  end
end
