# frozen_string_literal: true

Rails.application.routes.draw do
  get "thanks/list", to: "thanks#index"
  post "thanks/stats", to: "thanks#stats"
  post "thanks", to: "thanks#create"

  get "posts/list", to: "posts#index"
  post "post", to: "posts#create"

  post "callbacks", to: "callbacks#process"
end
