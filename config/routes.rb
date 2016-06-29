Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'

  post '/search_box_post_search', to: 'index#search_box_post_search'

  get '/star_bar', to: 'index#star_bar'
  post '/star_bar_post_star_count', to: 'index#star_bar_post_star_count'
end
