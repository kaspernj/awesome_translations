class AwesomeTranslations::Handlers::DeviseHandler < AwesomeTranslations::Handlers::BaseHandler
  def enabled?
    ::Object.const_defined?(:Devise)
  end

  def groups
    ArrayEnumerator.new do |yielder|
      groups = ["devise"]

      groups.each do |group|
        yielder << AwesomeTranslations::Group.new(
          id: group,
          handler: self,
          data: {
            name: group.humanize
          }
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      dir = Rails.root.join("config", "locales", "awesome_translations", group.id).to_s
      __send__("translations_for_#{group.id}", dir, group, yielder)
    end
  end

private

  def translations_for_devise(dir, group, yielder)
    add_translations_for_hash(dir, group, yielder, translations: {
                                devise: {
                                  confirmations: {
                                    confirmed: "Your email address has been successfully confirmed.",
                                    send_instructions: "You will receive an email with instructions for how to confirm your email address in a few minutes.",
                                    send_paranoid_instructions: "If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes."
                                  },
                                  failure: {
                                    already_authenticated: "You are already signed in.",
                                    inactive: "Your account is not activated yet.",
                                    invalid: "Invalid %{authentication_keys} or password.",
                                    locked: "Your account is locked.",
                                    last_attempt: "You have one more attempt before your account is locked.",
                                    not_found_in_database: "Invalid %{authentication_keys} or password.",
                                    timeout: "Your session expired. Please sign in again to continue.",
                                    unauthenticated: "You need to sign in or sign up before continuing.",
                                    unconfirmed: "You have to confirm your email address before continuing."
                                  },
                                  mailer: {
                                    confirmation_instructions: {
                                      subject: "Confirmation instructions"
                                    },
                                    reset_password_instructions: {
                                      subject: "Reset password instructions"
                                    },
                                    unlock_instructions: {
                                      subject: "Unlock instructions"
                                    }
                                  },
                                  omniauth_callbacks: {
                                    failure: "Could not authenticate you from %{kind} because \"%{reason}\".",
                                    success: "Successfully authenticated from %{kind} account."
                                  },
                                  passwords: {
                                    no_token: "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.",
                                    send_instructions: "You will receive an email with instructions on how to reset your password in a few minutes.",
                                    send_paranoid_instructions: "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.",
                                    updated: "Your password has been changed successfully. You are now signed in.",
                                    updated_not_active: "Your password has been changed successfully."
                                  },
                                  registrations: {
                                    destroyed: "Bye! Your account has been successfully cancelled. We hope to see you again soon.",
                                    signed_up: "Welcome! You have signed up successfully.",
                                    signed_up_but_inactive: "You have signed up successfully. However, we could not sign you in because your account is not yet activated.",
                                    signed_up_but_locked: "You have signed up successfully. However, we could not sign you in because your account is locked.",
                                    signed_up_but_unconfirmed: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.",
                                    update_needs_confirmation: "You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.",
                                    updated: "Your account has been updated successfully."
                                  },
                                  sessions: {
                                    signed_in: "Signed in successfully.",
                                    signed_out: "Signed out successfully.",
                                    already_signed_out: "Signed out successfully."
                                  },
                                  unlocks: {
                                    send_instructions: "You will receive an email with instructions for how to unlock your account in a few minutes.",
                                    send_paranoid_instructions: "If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.",
                                    unlocked: "Your account has been unlocked successfully. Please sign in to continue."
                                  }
                                },
                                errors: {
                                  messages: {
                                    already_confirmed: "was already confirmed, please try signing in",
                                    confirmation_period_expired: "needs to be confirmed within %{period}, please request a new one",
                                    expired: "has expired, please request a new one",
                                    not_found: "not found",
                                    not_locked: "was not locked",
                                    not_saved: {
                                      one: "1 error prohibited this %{resource} from being saved:",
                                      other: "%{count} errors prohibited this %{resource} from being saved:"
                                    }
                                  }
                                }
                              })
  end
end
