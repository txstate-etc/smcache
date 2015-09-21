class InstagramJob < BaseJob

  def perform
    Rails.logger.debug('Fetching instagram posts...')
    InstagramPost.fetch!
    Rails.logger.debug('Done fetching instagram posts.')
  end

end
