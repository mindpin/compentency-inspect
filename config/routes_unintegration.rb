Rails.application.routes.draw do
  # 视频组件
  get '/unintegration/video_player', to: 'unintegration#video_player'

  # 饼图
  get '/unintegration/pie_chart', to: 'unintegration#pie_chart'

  # 雷达图
  get '/unintegration/radar_chart', to: 'unintegration#radar_chart'

  # 折线图
  get '/unintegration/trend_chart', to: 'unintegration#trend_chart'

  # 聊天组件
  get '/unintegration/chat_box', to: 'unintegration#chat_box'
  post '/unintegration/return_message', to: 'unintegration#return_message'

  # 评分组件
  get '/unintegration/star_bar', to: 'unintegration#star_bar'
  post '/unintegration/star_bar_post_star_count', to: 'unintegration#star_bar_post_star_count'
end
