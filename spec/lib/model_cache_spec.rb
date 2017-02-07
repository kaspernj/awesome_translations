require "spec_helper"
require "model_cache"

describe ModelCache do
  let!(:translation_value) { create :translation_value }
  let(:key_caches) { model_cache.instance_variable_get(:@key_caches) }
  let(:model_cache) do
    ModelCache.new(
      attributes: [:id],
      by_keys: [
        [:translation_key_id, :locale, :file_path, :value]
      ],
      cache_keys: [
        [:translation_key_id, :locale, :file_path, :value]
      ],
      model: AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
    )
  end

  describe "#data_by_cache_key" do
    it "returns the right data" do
      model_cache.register(translation_value)

      result = model_cache.data_by_cache_key(
        [:translation_key_id, :locale, :file_path, :value],
        [translation_value.translation_key_id, translation_value.locale, translation_value.file_path, translation_value.value]
      )

      expect(result.fetch(:id)).to eq translation_value.id
    end
  end

  describe "#data_by_key" do
    it "returns the right data" do
      model_cache.register(translation_value)

      result = model_cache.data_by_key(
        [:translation_key_id, :locale, :file_path, :value],
        [translation_value.translation_key_id, translation_value.locale, translation_value.file_path, translation_value.value]
      )

      expect(result.fetch(:id)).to eq translation_value.id
    end
  end

  describe "#register_cache_keys" do
    it "generates the right key" do
      model_cache.register(translation_value)

      expect(key_caches.keys.first).to eq "translation_key_id____locale____file_path____value"
    end
  end
end
