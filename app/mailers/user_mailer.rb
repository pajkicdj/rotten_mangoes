class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def termination_email(user)
    @user = user
    @url  = user.email
    mail(to: @user.email, subject: 'BYE BYE!!!!')
  end
end
