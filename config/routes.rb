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

  get "/outline", to: 'outline#global'
  get "/tools/ques", to: 'tools#ques'

  # 测验DEMO
  get  "/test",                   to: "test/test#show"
  get  "/test_status",            to: "test/test_status#index"
  post "/test_status/start",      to: "test/test_status#start"
  get  "/test_wares/data",        to: "test/test_wares#data"
  post "/test_wares/save_answer", to: "test/test_wares#save_answer"
end
