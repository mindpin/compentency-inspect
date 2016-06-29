Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'
  get '/video_player', to: 'index#video_player'

  post '/search_box_post_search', to: 'index#search_box_post_search'
end
