Rails.application.routes.draw do
  mount FilePartUpload::Engine => '/file_part_upload', :as => 'file_part_upload'

  devise_for :users, skip: :all
  devise_scope :user do
    get    "/admin/sign_in",  to: "admin/sessions#new"
    post   "/admin/sign_in",  to: "admin/sessions#create"
    delete "/admin/sign_out", to: "admin/sessions#destroy"
  end

  devise_scope :user do
    get    "/sign_in",  to: "sessions#new"
    post   "/sign_in",  to: "sessions#create"
    delete "/sign_out", to: "sessions#destroy"
  end

  namespace :admin do
    get "/dashboard", to: "dashboard#index"
    resources :test_results do
      get :reviews, on: :member
      get :completed_index, on: :collection
    end
    resources :user_test_papers do
      put :review_complete, on: :member
    end
    resources :test_paper_result_question_reviews
    resources :test_paper_result_reviews do
      post :complete, on: :collection
    end
    resources :users
    resources :question_points
    resources :questions
  end

  get  "/test_status",       to: "test_status#index"
  post "/test_status/start", to: "test_status#start"
  get  "/test_wares/data",        to: "test_wares#data"
  post "/test_wares/save_answer", to: "test_wares#save_answer"

  get  "/test_wares",   to: "test_wares#index"

  get '/test', to: 'test#show'
  get '/test/result', to: 'test#result'
  get "/", to: "index#index"
end
