# frozen_string_literal: true

Rails.application.routes.draw do
  get "thanks/list", to: "thanks#index"
  post "thanks/stats", to: "thanks#stats"
  post "thanks", to: "thanks#create"

  get "posts", to: "posts#index"
  post "posts", to: "posts#slack_index"

  post "posts/list", to: "posts#list"
  post "posts/new", to: "posts#create"

  post "callbacks", to: "callbacks#exec"
end
