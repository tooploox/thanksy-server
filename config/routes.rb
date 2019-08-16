# frozen_string_literal: true

Rails.application.routes.draw do
  get "thanks/list", to: "thanks#index"
  post "thanks/stats", to: "thanks#stats"
  post "thanks", to: "thanks#create"

  get "posts", to: "posts#index"
  post "posts", to: "posts#index_for_slack"

  post "callbacks", to: "callbacks#exec"
end
