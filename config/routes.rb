Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'
  
  get '/video_player', to: 'index#video_player'
  get '/pie_chart', to: 'index#pie_chart'
  get '/radar_chart', to: 'index#radar_chart'
  get '/trend_chart', to: 'index#trend_chart'
  post '/search_box_post_search', to: 'index#search_box_post_search'

  get '/star_bar', to: 'index#star_bar'
  post '/star_bar_post_star_count', to: 'index#star_bar_post_star_count'

  # ----------
  get "/views/:name", to: 'index#views'
  get "/parser/ques-yaml", to: 'parser#ques_yaml'
end