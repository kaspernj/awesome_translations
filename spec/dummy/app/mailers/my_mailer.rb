class MyMailer < ActionMailer::Base
  def mailer_action(user_id)
    mail(subject: t(".custom_subject"))
  end
end
