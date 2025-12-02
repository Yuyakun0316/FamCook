class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    entered_code = resource.family_code&.strip

    # -------------------------
    # 家族を検索 or 新規作成
    # -------------------------
    if entered_code.present?
      family = Family.find_by(code: entered_code)

      unless family
        resource.errors.add(:family_code, 'が正しくありません')
        return render :new, status: :unprocessable_entity
      end

      new_family = false
    else
      family = Family.new(code: SecureRandom.hex(4))
      new_family = true
      family.save!  
    end

    resource.family = family

    if resource.save

      # 新規ファミリーなら owner を設定
      if new_family
        family.update!(owner: resource)
      end

      set_flash_message!(:notice, "登録が完了しました！（家族ID: #{family.code}）")
      sign_up(resource_name, resource)
      redirect_to root_path

    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :family_code)
  end
end