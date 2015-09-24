class InstagramPost < ActiveRecord::Base
  scope :recent, -> { order('posttime DESC').limit(3) }

  # MySQL is barfing on emojis so we are storing text fields as binary.
  # Force the encoding to UTF8 here so that everything renders ok in the app.
  def caption
    @caption_utf8 ||= read_attribute(:caption).dup.force_encoding(Encoding::UTF_8) rescue ''
  end

  # User ID for txst instagram account
  # Use https://instagram.com/developer/endpoints/users/#get_users_search endpoint to find userids from usernames.
  TXST_ID = '146165265'

  # Max number of results to return
  COUNT = 20

  def self.min_id
    @min_id ||= InstagramPost.order('posttime DESC').limit(1).pluck(:postid).first
  end

  def self.fetch!
    logger.debug("Fetching last #{COUNT} Instagram posts newer than #{min_id}")

    results = client.user_recent_media TXST_ID, min_id: min_id, count: COUNT

    logger.debug("Instagram returned #{results.try(:length)} results")

    added = changed = unchanged = 0
    results.each_with_index do |r, idx|
      posttime = Time.at(r.created_time.to_i)
      logger.debug("Instagram result #{idx}: #{r.type}, id: #{r.id}, time: #{posttime}")

      i = InstagramPost.find_or_initialize_by(postid: r.id)
      i.posttime = posttime
      i.caption = r.caption.try(:text)
      i.mediatype = r.type

      media = r.type == "video" ? r.videos : r.images 
      i.url = media.standard_resolution.url
      i.width = media.standard_resolution.width
      i.height = media.standard_resolution.height
        
      if i.new_record?
        log_prefix = "added"
        added += 1
      elsif i.changed?
        log_prefix = "updated"
        changed += 1
      else
        log_prefix = nil
        unchanged += 1
      end

      i.save!

      logger.debug("Instagram post #{log_prefix}: #{i}") if log_prefix
    end

    logger.debug("Instagram results: #{added} added, #{changed} updated, #{unchanged} unchanged")

  end

private
  def self.client
    @@client ||= Instagram.client(access_token: Rails.application.secrets.instagram_key)
  end
end
