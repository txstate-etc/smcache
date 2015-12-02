class InstagramPost < ActiveRecord::Base
  scope :recent, -> { order('posttime DESC').limit(3) }
  scope :images, -> { where(mediatype: 'image') }

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

  def self.fetch!
    logger.debug("Fetching last #{COUNT} Instagram posts")

    results = client.user_recent_media TXST_ID, count: COUNT

    logger.debug("Instagram returned #{results.try(:length)} results")

    added = changed = unchanged = 0
    results.each_with_index do |r, idx|
      posttime = Time.at(r.created_time.to_i)
      logger.debug("Instagram result #{idx}: #{r.type}, id: #{r.id}, time: #{posttime}")

      i = InstagramPost.find_or_initialize_by(postid: r.id)
      i.posttime = posttime
      i.link = r.link
      i.caption = r.caption.try(:text)
      i.mediatype = r.type

      i.image_url = r.images.standard_resolution.url
      i.image_width = r.images.standard_resolution.width
      i.image_height = r.images.standard_resolution.height
      
      if r.videos
        i.video_url = r.videos.standard_resolution.url
        i.video_width = r.videos.standard_resolution.width
        i.video_height = r.videos.standard_resolution.height
      end

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
    @@client ||= Instagram.client(client_id: Rails.application.secrets.instagram_client_id)
  end
end
