class FacebookPost < ActiveRecord::Base
  scope :recent, -> { order('posttime DESC').limit(3) }

  # MySQL is barfing on emojis so we are storing text fields as binary.
  # Force the encoding to UTF8 here so that everything renders ok in the app.
  def caption
    @caption_utf8 ||= read_attribute(:caption).dup.force_encoding(Encoding::UTF_8) rescue ''
  end

  # User ID for txst facebook account
  TXST_ID = 'txstateu'

  # Max number of results to return
  COUNT = 20

  def self.min_id
    @min_id ||= FacebookPost.order('posttime DESC').limit(1).pluck(:postid).first
  end

  def self.fetch!
    logger.debug("Fetching last #{COUNT} Facebook posts newer than #{min_id}")

    # results = client.user_recent_media TXST_ID, min_id: min_id, count: COUNT
    results = client.get_connections(TXST_ID, "posts", {fields: ['message', 'description', 'name', 'id', 'type','full_picture', 'link', 'created_time', 'source']})
    logger.debug("Facebook returned #{results.try(:length)} results")

    added = changed = unchanged = 0
    results.each_with_index do |r, idx|
      posttime = r['created_time'].to_datetime
      logger.debug("Facebook result #{idx}: #{r['type']}, id: #{r['id']}, time: #{posttime}")

      i = FacebookPost.find_or_initialize_by(postid: r['id'])
      i.posttime = posttime
      i.caption = r['message'] || r['description'] || r['name']
      i.mediatype = r['type']

      i.url = r['full_picture']
      # i.width = r.images.standard_resolution.width
      # i.height = r.images.standard_resolution.height
      
      if r['type'] == 'video'
        i.video_url = r['source']
        # i.video_width = r.videos.standard_resolution.width
        # i.video_height = r.videos.standard_resolution.height
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

      logger.debug("Facebook post #{log_prefix}: #{i}") if log_prefix
    end

    logger.debug("Facebook results: #{added} added, #{changed} updated, #{unchanged} unchanged")

  end

private
  def self.client
    @@client ||= Koala::Facebook::API.new("#{Rails.application.secrets.facebook_key}|#{Rails.application.secrets.facebook_secret}")
  end
end
