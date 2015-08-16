Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    resources :events do
      member do
        get   :admin_view
        patch :add_organizer
        post  :duplicate
        post  :publish
        post  :register
      end
    end

  end
end
