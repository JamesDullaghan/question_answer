Rails.application.routes.draw do
  root to: 'question_receiver#index'

  post '/question' => 'question_receiver#index', as: :great_question
end
