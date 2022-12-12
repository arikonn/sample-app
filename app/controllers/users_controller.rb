class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #sessions　helperで定義したlog_inメソッド
      log_in @user
      flash[:success] = t('.welcome_message')
      redirect_to @user
    else
      render 'new'
    end
  end
  
  #ユーザーのeditアクション
  def edit
  end
  
  def update
    #指定された属性の検証がすべて成功した場合@userの更新と保存を続けて同時に行う
    if @user.update_attributes(user_params)
      # 更新に成功した場合の処理が入る。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      #更新失敗時はeditアクションに対応したviewが返る
      render 'edit'
    end
  end
  
  # 外部に公開されないメソッド
  private
 
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end