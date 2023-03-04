module GeneralRoutes
  def self.extended(router)
    router.instance_exec do
      root 'home#index'

      resource :feedback, only: %i[create]
    end
  end
end
