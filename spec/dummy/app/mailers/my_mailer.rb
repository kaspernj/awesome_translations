class MyMailer < ActionMailer::Base # rubocop:disable Rails/ApplicationMailer
  def mailer_action(_user_id)
    mail(subject: t(".custom_subject"))
  end
end
