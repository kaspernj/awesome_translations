require "spec_helper"
require "fileutils"

describe AwesomeTranslations::HandlersController do
  routes { AwesomeTranslations::Engine.routes }

  render_views

  it "#index" do
    get :index
    expect(response).to be_success
  end

  it "#show" do
    get :show, id: "model_handler"
    expect(response).to be_success
  end
end
