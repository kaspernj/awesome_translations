require 'spec_helper'

describe AwesomeTranslations::Translation do
  let(:day_names_monday_translation) do
    AwesomeTranslations::Translation.new(
      dir: Rails.root.join('config', 'locales', 'awesome_translations', 'date_time'),
      key: 'date.day_names[1]'
    )
  end

  let(:am_translation) do
    AwesomeTranslations::Translation.new(
      dir: Rails.root.join('config', 'locales', 'awesome_translations', 'date_time'),
      key: 'time.am'
    )
  end

  it '#array_key' do
    expect(day_names_monday_translation.array_key).to eq 'date.day_names'
  end

  it '#array_translation?' do
    expect(day_names_monday_translation.array_translation?).to eq true
  end

  it '#array_no' do
    expect(day_names_monday_translation.array_no).to eq 1
  end

  describe '#value' do
    it 'returns correct value when it is an array translation' do
      expect(day_names_monday_translation.value(locale: 'en')).to eq 'Monday'
    end

    it 'returns correct value for normal translations' do
      expect(am_translation.value(locale: 'en')).to eq 'am'
    end
  end

  describe '#value_for?' do
    it 'returns correct value when it is an array translation' do
      expect(day_names_monday_translation.value_for?('en')).to eq true
    end

    it 'returns correct value for normal translations' do
      expect(am_translation.value_for?('en')).to eq true
    end
  end
end
