Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'
  get '/video_player', to: 'index#video_player'
  get '/chat_box', to: 'index#chat_box'

  post '/return_message', to: 'index#return_message'
  post '/search_box_post_search', to: 'index#search_box_post_search'
end
