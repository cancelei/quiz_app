Rails.application.routes.draw do
  # Authentication routes
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]

  # Identity routes (for managing email and password reset)
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  # Root path
  root "quizzes#index"

  # Quiz resources
  resources :quizzes do
    resources :questions, only: [:new, :create, :edit, :update, :destroy] do
      resources :answers, only: [:new, :create, :edit, :update, :destroy]
    end
    
    resources :user_quiz_attempts, only: [:create] do
      resources :questions, only: [:show], controller: 'quiz_questions'
      resources :user_answers, only: [:create]
      resource :results, only: [:show]
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
