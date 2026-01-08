class Users::RegistrationsController < Devise::RegistrationsController
  # 更新と削除の前にゲストチェックを行う
  before_action :ensure_normal_user, only: [:update, :destroy]

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
      family.save!
      new_family = true
    end

    # ユーザーに家族をセット
    resource.family = family

    # ユーザー保存（ここで family_id が入る）
    if resource.save

      # 新規ファミリーなら owner を設定
      family.update!(owner: resource) if new_family

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

  # ゲストユーザーならトップへリダイレクトさせる
  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :family_code)
  end
end
