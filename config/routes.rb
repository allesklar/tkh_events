Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    resources :events do
      member do
        post  :duplicate
        post  :publish
        post  :register
      end
    end

  end
end
