Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'

  # 视频组件
  get '/video_player', to: 'index#video_player'
  get '/pie_chart', to: 'index#pie_chart'
  get '/radar_chart', to: 'index#radar_chart'
  get '/trend_chart', to: 'index#trend_chart'
  # 聊天组件
  get '/chat_box', to: 'index#chat_box'
  post '/return_message', to: 'index#return_message'
  # 搜索组件
  post '/search_box_post_search', to: 'index#search_box_post_search'
  # 评分组件
  get '/star_bar', to: 'index#star_bar'
  post '/star_bar_post_star_count', to: 'index#star_bar_post_star_count'

  # ----------
  get "/views/:name", to: 'index#views'
  get "/parser/ques-yaml", to: 'parser#ques_yaml'
end
