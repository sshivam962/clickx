module NetworkRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :network, path: :n do
        get :dashboard, to: 'dashboard#home'
        get :dashboard1, to: 'dashboard#home1'
        get 'change_start_tour', to: 'dashboard#change_start_tour', as: :change_start_tour
        get :signup, to: 'signups#new'

        resources :signups, only: %i[create]
        resources :projects, only: %i[index show] do
          member do
            get :details
            get :contract
            post :proposal
          end
        end
        resources :memberships, only: %i[index update]
        resources :branding, only: %i[index]
        resource :profile, only: [:show, :edit, :update] do
          member do
            patch :update_logo
            patch :update_background_image
            patch :upload_pdf
            get :download_cv
          end
        end
        resources :agreements, only: %i[create]
        get :sign_agreement, to: 'agreements#new'
        get :agreement, to: 'agreements#show'
        get :download_agreement, to: 'agreements#download'

        resources :settings, only: :index do
          collection do
            post :payout
            post :stripe_connect
            get :connect_with_stripe
            get :edit_stripe_account
            post :update_stripe_account
          end
        end

        resources :case_studies, only: %i[show new create edit update destroy]

        resources :case_study_images, only: [] do
          member do
            patch :update_position
          end
        end

        get 'industries/:industry_id/case_studies', to: 'case_studies#index', as: :industry_case_study
        
        resources :chats, path: :messages do
          collection do
            get :chat_history
            post :unread_messages
            post :update_message_read_status
          end
        end
      end
    end
  end
end
