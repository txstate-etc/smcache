Rails.application.routes.draw do
  get 'instagram' => 'instagram_posts#index'
  get 'twitter' => 'tweets#index'
end
