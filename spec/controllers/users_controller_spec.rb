require "spec_helper"

describe UsersController do
  let(:user) { create :user }

  render_views

  before do
    I18n.locale = :en
  end

  it "#index" do
    user
    get :index
    response.should be_success
    assigns(:users).should include user
  end
end
