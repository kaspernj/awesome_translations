require "spec_helper"

describe UsersController do
  let(:user) { create :user }
  let(:erb_handler) { AwesomeTranslations::Handlers::ErbHandler.new }

  render_views

  before do
    I18n.locale = :da
  end

  it "#index" do
    user
    get :index
    response.should be_success
    assigns(:users).should include user
  end

  it "should find translations" do
    users_group = erb_handler.groups.select { |group| group.name == "users" }.first

    user_created_translation = users_group.translations.select { |translation| translation.key == "controllers.users_controller.user_was_created" }.first
    user_created_translation.should_not eq nil
  end
end
