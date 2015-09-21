class TwitterJob < BaseJob

  def perform
    Rails.logger.debug('Fetching twitter posts...')
    Tweet.fetch!
    Rails.logger.debug('Done fetching twitter posts.')
  end

end
