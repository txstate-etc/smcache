class ApplicationController < ActionController::API

  protected 
  def proxy(url)
    logger.debug "Proxying to #{url}"

    proxy_response = HTTP.timeout(:per_operation, :connect => 4, :read => 3, :write => 3).get(url)

    send_data proxy_response.body, 
      content_type: proxy_response['Content-Type'], 
      disposition: "inline",
      status: proxy_response.code
  end
end
