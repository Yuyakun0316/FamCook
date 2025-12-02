class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # ユーザーが入力した family_code
    entered_code = resource.family_code&.strip

    # 家族を検索 or 新規作成
    if entered_code.present?
      family = Family.find_by(code: entered_code)

      unless family
        resource.errors.add(:family_code, 'が正しくありません')
        return render :new, status: :unprocessable_entity
      end

    else
      # 🔥 新規ファミリー作成（ownerはこのユーザーになる）
      family = Family.new(code: SecureRandom.hex(4))
    end

    resource.family = family

    # ユーザー保存
    if resource.save
      # 🔥 family.owner を設定（新規作成の場合）
      if family.owner.nil?
        family.owner = resource
        family.save!   # ここで owner_id NOT NULL が満たされる
      end

      set_flash_message!(:notice, "登録が完了しました！（家族ID: #{family.code}）")
      sign_up(resource_name, resource)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :family_code)
  end
end
