# frozen_string_literal: true

Rails.application.routes.draw do
  get "thanks/list", to: "thanks#index"
  post "thanks/stats", to: "thanks#stats"
  post "thanks", to: "thanks#create"
  post "thanks/react", to: "thanks#update"
end
