Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'
  get '/pie_graph', to: 'index#pie_graph'

  post '/search_box_post_search', to: 'index#search_box_post_search'
end
