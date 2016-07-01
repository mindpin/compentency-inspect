def routes_draw(routes_name)
  instance_eval(File.read(Rails.root.join('config', "routes_#{routes_name}.rb")))
end
routes_draw :unintegration

Rails.application.routes.draw do
  get "/", to: "index#index"
  get '/sample', to: 'index#sample'
  get '/getmd',  to: 'index#getmd'
  get '/getimgs', to: 'index#getimgs'

  # 搜索组件
  post '/search_box_post_search', to: 'index#search_box_post_search'

  # ----------
  get "/views/:name", to: 'index#views'
  get "/parser/ques-yaml", to: 'parser#ques_yaml'
end
