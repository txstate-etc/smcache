class InstagramSlide < ActiveRecord::Base
  belongs_to :post, class_name: 'InstagramPost', inverse_of: :slides
  validates :url, presence: true
end
