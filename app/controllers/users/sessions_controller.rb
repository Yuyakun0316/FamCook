class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    # User.guest はUserモデルに定義したメソッドです
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end