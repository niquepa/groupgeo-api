Rails.application.routes.draw do

  devise_for :users,
             path: '/v1',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
             },
             controllers: {
                 sessions: 'v1/sessions',
                 registrations: 'v1/registrations'
             }

  namespace :v1 do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end
