class FacebookJob < BaseJob

  def perform
    Rails.logger.debug('Fetching facebook posts...')
    FacebookPost.fetch!
    Rails.logger.debug('Done fetching facebook posts.')
  end

end
