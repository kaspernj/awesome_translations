require "spec_helper"

describe UsersController do
  let(:user) { create :user }

  render_views

  before do
    I18n.locale = :en
  end

  it "#update" do
    patch :update, id: user.id, user: {email: "newemail@example.com"}
    expect(response).to redirect_to user_url(user)

    # Ensure correct key
    expect(flash[:notice]).to eq "translation missing: en.users.user_was_updated"
  end
end
