class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.assign_attributes(user_params)
    
    # check if email was updated
    if @user.email_changed?
      extra_info = " A confirmation email was sent to \"" +
        params[:user][:email] +
        "\". Please follow the email instructions to confirm your new email."
    else
      extra_info = ''
    end
    
    if @user.save
      flash[:notice] = "Account settings updated successfully.#{extra_info}"
      redirect_to edit_user_registration_path
    else
      flash.now[:error] = "There was a problem updating your account"
      render :edit
    end
  end
  
  def password_reset
    current_user.send_reset_password_instructions
    
    if !successfully_sent?(current_user)
      flash[:error] = "There was a prolem sending your reset password email. Please try again."
    end
    
    redirect_to edit_user_registration_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :username)
  end
end