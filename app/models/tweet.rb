class Tweet < ActiveRecord::Base
  scope :recent, -> { order('tweettime DESC').limit(3) }
  scope :nofav, -> { where(favorite: false) }
  scope :fav, -> { where(favorite: true) }

  # MySQL is barfing on emojis so we are storing text fields as binary.
  # Force the encoding to UTF8 here so that everything renders ok in the app.
  def text
    @text_utf8 ||= read_attribute(:text).dup.force_encoding(Encoding::UTF_8)
  end

  def display_name
    @display_name_utf8 ||= read_attribute(:display_name).dup.force_encoding(Encoding::UTF_8)
  end

  def self.fetch!
    fetchtweets!
    fetchfavorites!
  end

private 

  def self.fetchtweets!
    opts = {
      exclude_replies: true,
      include_rts: false
    }
    since_id = min_id(false)
    opts[:since_id] = since_id.first if since_id.present?

    fetch_and_save(false) { client.user_timeline("txst", opts) }
  end

  def self.fetchfavorites!
    opts = {}
    since_id = min_id(true)
    opts[:since_id] = since_id.first if since_id.present?
    fetch_and_save(true) { client.favorites("txst", opts) }    
  end

  def self.min_id(favorite)
    Tweet.where(favorite: favorite).order('tweettime DESC').limit(1).pluck(:tweetid)
  end
  
  def self.check_rate_limit(favorite)
    endpoint = favorite ? 'favorites' : 'user_timeline'
    r = TwitterRateLimit.find_by(endpoint: endpoint)
    return true if r.nil? || r.reset_at < Time.now
    
    logger.info("Not fetching #{endpoint}. Rate limited until #{r.reset_at}")
    return false
  end

  def self.save_rate_limit(favorite, rate_limit)
    endpoint = favorite ? 'favorites' : 'user_timeline'
    r = TwitterRateLimit.find_or_initialize_by(endpoint: endpoint)
    r.limit = rate_limit.limit
    r.remaining = rate_limit.remaining
    r.reset_at = rate_limit.reset_at
    r.reset_in = rate_limit.reset_in
    r.save!
  end

  def self.fetch_and_save(favorite)
    type = favorite ? "Favorite" : "Tweet"
    logger.debug("Fetching last 20 #{type}s")

    return unless check_rate_limit(favorite)

    begin
      results = yield
    rescue Twitter::Error::TooManyRequests => error
      save_rate_limit(favorite, error.rate_limit)
      raise
    end
    
    logger.debug("Twitter returned #{results.try(:length)} results")
    return 0 if results.empty?

    total = added = changed = unchanged = 0
    results.each_with_index do |r, idx|
      logger.debug("#{type} #{idx}: id: #{r.id}, time: #{r.created_at}")
      total += 1
      
      t = Tweet.find_or_initialize_by(tweetid: r.id)
      t.tweettime = r.created_at
      t.text = r.text
      t.screen_name = r.user.screen_name
      t.display_name = r.user.name
      t.profile_image = r.user.profile_image_url.to_s
      t.favorite = favorite

      if t.new_record?
        log_prefix = "added"
        added += 1
      elsif t.changed?
        log_prefix = "updated"
        changed += 1
      else
        log_prefix = nil
        unchanged += 1
      end

      t.save!

      logger.debug("#{type} #{log_prefix}: #{t}") if log_prefix

    end

    logger.debug("#{type} results: #{added} added, #{changed} updated, #{unchanged} unchanged")
    return total
  end

  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_key
      config.consumer_secret     = Rails.application.secrets.twitter_secret
    end
  end

end
