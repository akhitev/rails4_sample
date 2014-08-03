Rails.application.routes.draw do
  root to: 'offers#search_form'
  post 'search', to: 'offers#search'
end
