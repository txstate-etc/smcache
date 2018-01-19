class FacebookSlide < ActiveRecord::Base
  belongs_to :post, class_name: 'FacebookPost', inverse_of: :slides
  validates :url, presence: true
end
