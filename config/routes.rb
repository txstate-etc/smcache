Rails.application.routes.draw do
  get 'instagram' => 'instagram_posts#index'
  get 'facebook' => 'facebook_posts#index'
  get 'twitter' => 'tweets#index'
  get 'all' => 'all#index'

  get 'instagram/:id/img/:filename' => 'instagram_posts#img', as: 'instagram_img'
  get 'facebook/:id/img/:filename' => 'facebook_posts#img', as: 'facebook_img'
  get 'twitter/:id/img/:filename' => 'tweets#img', as: 'twitter_img'
end
