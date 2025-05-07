class ApplicationController < ActionController::Base

  include Pagy::Backend # この行を追加
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])

    # アカウント情報更新時(account_update)に nickname の変更を許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end
