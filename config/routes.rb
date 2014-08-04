Rails.application.routes.draw do
  root to: 'offers#search_form'
  post 'search', to: 'offers#search'

  # backdoor for ui testing. Only for dev environment
    get 'test',to: 'offers#test' if Rails.env.development?
end
