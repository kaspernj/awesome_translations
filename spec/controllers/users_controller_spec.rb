require "spec_helper"

describe UsersController do
  let(:user) { create :user }

  render_views

  around do |example|
    I18n.with_locale(:en) do
      example.call
    end
  end

  it "#update" do
    patch :update, params: {id: user.id, user: {email: "newemail@example.com"}}
    expect(response).to redirect_to user_url(user)

    # Ensure correct key
    expect(flash[:notice]).to eq "Translation missing: en.users.user_was_updated"
  end
end
