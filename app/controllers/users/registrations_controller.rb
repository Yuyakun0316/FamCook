class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # 🔍 家族IDが入力されている場合
    if resource.family_code.present?
      family = Family.find_by('LOWER(code) = ?', resource.family_code.downcase)
      family ||= Family.create!(code: resource.family_code)
    else
      # 🔰 空欄の場合 → 新規作成
      family = Family.create!(code: SecureRandom.hex(4))
    end

    resource.family = family

    # ユーザー保存
    if resource.save
      set_flash_message!(:notice, "登録が完了しました！（家族ID: #{family.code}）")
      sign_up(resource_name, resource)
      redirect_to root_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :family_code)
  end
end