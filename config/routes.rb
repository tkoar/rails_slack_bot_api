Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/messages', to: 'messages#show'
  get '/edits', to: 'edit_histories#show'
end
