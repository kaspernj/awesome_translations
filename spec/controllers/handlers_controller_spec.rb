require "spec_helper"
require "fileutils"

describe AwesomeTranslations::HandlersController do
  let!(:group) { create :group }
  let!(:handler_translation) { create :handler_translation, group: group }

  routes { AwesomeTranslations::Engine.routes }

  render_views

  describe "#index" do
    it "renders the page" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "renders the page" do
      AwesomeTranslations::CacheDatabaseGenerator.current.cache_translations
      get :show, id: "model_handler"
      expect(response).to be_success
    end

    it "filters with missing translations" do
      AwesomeTranslations::CacheDatabaseGenerator.current.cache_translations
      get :show, id: "model_handler", with_missing_translations: "only_with"

      all_groups = AwesomeTranslations::CacheDatabaseGenerator::Group.all
      groups = assigns(:groups)

      expect(all_groups.length).to be > groups.length
      expect(groups.length).to eq 4
      expect(response).to be_success
    end
  end

  it "#update_cache" do
    request.env["HTTP_REFERER"] = handlers_path
    post :update_cache
    expect(response).to redirect_to :handlers
  end

  it "#update_groups_cache" do
    AwesomeTranslations::CacheDatabaseGenerator.current.cache_translations
    request.env["HTTP_REFERER"] = handler_path("rails_handler")
    post :update_groups_cache, id: "rails_handler"
    expect(response).to redirect_to handler_path("rails_handler")
  end
end
