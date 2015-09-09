Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    resources :events do
      member do
        delete  :remove_organizer
        delete  :unregister
        get     :admin_view
        patch   :add_organizer
        post    :duplicate
        post    :publish
        post    :register
      end
    end

  end
end
