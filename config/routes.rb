Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'

  post '/search_box_post_search', to: 'index#search_box_post_search'

  # ----------
  get "/views/:name", to: 'index#views'

  get "/parser/ques-yaml", to: 'parser#ques_yaml'
end
