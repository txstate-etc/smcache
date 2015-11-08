Rails.application.routes.draw do
  get 'instagram' => 'instagram_posts#index'
  get 'facebook' => 'facebook_posts#index'
  get 'twitter' => 'tweets#index'
  get 'all' => 'all#index'
end
