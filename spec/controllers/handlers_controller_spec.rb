require "spec_helper"
require "fileutils"

describe AwesomeTranslations::HandlersController do
  render_views

  it "#index" do
    get :index, use_route: "awesome_translations"
    response.should be_success
  end

  it "#show" do
    get :show, id: "model_handler", use_route: "awesome_translations"
    response.should be_success
  end
end
