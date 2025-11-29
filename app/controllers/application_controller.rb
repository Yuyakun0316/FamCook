class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    root_path
  end

  private

  def configure_permitted_parameters
    # 新規登録時に :family_code を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :family_code])

    # アカウント更新時（プロフィール編集）は :name のみ許可（必要に応じて変更可）
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
