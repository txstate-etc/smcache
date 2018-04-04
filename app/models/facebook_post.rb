class FacebookPost < ActiveRecord::Base
  scope :recent, -> { includes(:slides).order('last_seen DESC, posttime DESC').limit(3) }
  scope :photoOrLink, -> { where(mediatype: ['album', 'photo', 'link', 'video']).where.not(image_url: nil).where.not(caption: nil) }

  has_many :slides, class_name: 'FacebookSlide', dependent: :destroy, inverse_of: :post

  # MySQL is barfing on emojis so we are storing text fields as binary.
  # Force the encoding to UTF8 here so that everything renders ok in the app.
  def caption
    @caption_utf8 ||= read_attribute(:caption).dup.force_encoding(Encoding::UTF_8) rescue ''
  end

  def image_filename
    # make sure filename is unique so it can be used as a cache buster
    fname = File.basename(URI.parse(image_url).path) rescue 'image'
    h = Base64.urlsafe_encode64(Digest::MD5.digest(image_url)).gsub(%r{=},'')
    "#{h}_#{fname}"
  end

  def as_json(opts={})
    super(opts.merge({methods: ((opts[:methods] || []) | [:image_filename])}))
  end

  # User ID for txst facebook account
  TXST_ID = 'txstateu'

  # Max number of results to return
  COUNT = 20

  def self.fetch!
    logger.debug("Fetching last #{COUNT} Facebook posts")

    results = client.get_connections(TXST_ID, "posts", {limit: COUNT, fields: ['message', 'description', 'name', 'id', 'type','full_picture', 'link', 'created_time', 'source', 'attachments']})
    logger.debug("Facebook returned #{results.try(:length)} results")

    last_seen = Time.now
    added = changed = unchanged = 0
    results.each_with_index do |r, idx|
      posttime = r['created_time'].to_datetime
      logger.debug("Facebook result #{idx}: #{r['type']}, id: #{r['id']}, time: #{posttime}")

      i = FacebookPost.find_or_initialize_by(postid: r['id'])
      i.posttime = posttime
      i.link = fmt_link(r)
      i.caption = r['message']# || r['description'] || r['name']
      i.mediatype = r['type']

      i.image_url = r['full_picture']
      # i.image_width = r.images.standard_resolution.width
      # i.image_height = r.images.standard_resolution.height

      if r['attachments'] && r['attachments']['data'][0]['subattachments'] && subattachments = r['attachments']['data'][0]['subattachments']['data']
        currentslides = []
        subattachments.each do |suba|
          media = suba['media']
          s = FacebookSlide.find_or_initialize_by(facebook_post_id: i.id, url: media['image']['src'])
          s.width = media['image']['width']
          s.height = media['image']['height']
          s.mediatype = suba['type']
          currentslides.push(s)
        end
        i.slides = i.slides & currentslides
        i.slides << currentslides - i.slides
        i.mediatype = "album"
      elsif r['attachments'] && r['attachments']['data'][0] && attmedia = r['attachments']['data'][0]['media']
        i.image_width = attmedia['image']['width']
        i.image_height = attmedia['image']['height']
      end

      if r['type'] == 'video'
        i.video_url = r['source']
        if i.video_embed_html.blank?
          video_id = r['attachments']['data'][0]['target']['id']
          if video_id.blank?
            video_url = r['attachments']['data'][0]['target']['url']
            i.video_embed_html = '<div style="padding-top: 56.25%"><iframe style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;" src="'+r['source']+'"></iframe></div>'
          else
            caption_result = client.get_object(video_id, { fields: ['embed_html'] })
            i.video_embed_html = caption_result['embed_html']
          end
        end
        # i.video_width = r.videos.standard_resolution.width
        # i.video_height = r.videos.standard_resolution.height
      else
        i.video_embed_html = ''
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

      i.last_seen = last_seen
      i.save!

      logger.debug("Facebook post #{log_prefix}: #{i}") if log_prefix
    end

    logger.debug("Facebook results: #{added} added, #{changed} updated, #{unchanged} unchanged")

  end

private

  def self.fmt_link(r)
    return r['link'] unless r['type'] == 'link'
    "//www.facebook.com/#{TXST_ID}/posts/#{r['id'].gsub(/^[^_]*_/, '')}"
  end

  def self.client
    @@client ||= Koala::Facebook::API.new("#{Rails.application.secrets.facebook_key}|#{Rails.application.secrets.facebook_secret}")
  end
end
