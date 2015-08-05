require "spec_helper"

describe UsersController do
  let(:user) { create :user }

  render_views

  before do
    require "jquery-rails"

    I18n.locale = :en
  end

  it "#index" do
    user
    get :index
    response.should be_success
    assigns(:users).should include user
  end

  it "#update" do
    patch :update, id: user.id, user: {email: "newemail@example.com"}
    expect(response).to redirect_to user_url(user)

    # Ensure correct key
    expect(flash[:notice]).to eq 'translation missing: en.spec.dummy.app.controllers.users_controller.user_was_updated'
  end
end
