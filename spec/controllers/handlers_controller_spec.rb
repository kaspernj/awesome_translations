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

  it "#update_cache" do
    request.env["HTTP_REFERER"] = handlers_path
    post :update_cache
    expect(response).to redirect_to :handlers
  end

  it "#update_groups_cache" do
    request.env["HTTP_REFERER"] = handler_path("rails_handler")
    post :update_groups_cache, id: "rails_handler"
    expect(response).to redirect_to handler_path("rails_handler")
  end
end
