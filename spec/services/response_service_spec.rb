require 'rails_helper'

RSpec.describe ResponseService, type: :service do
  context 'construction' do
    describe 'pre-defined values' do
      it 'should have constants' do
        expect(described_class.constants).to include(:FACEBOOK_URI, :INSTAGRAM_URI, :TWITTER_URI)
      end
    end
  end

  context 'action' do
    let(:service) { described_class.new }

    let(:mocked_web_data) {
      { facebook_uri: "[{\"name\":\"Name0\",\"status\":\"Status0\"},{\"name\":\"Name1\",\"status\":\"Status1\"}]",
        instagram_uri: "404 page not found",
        twitter_uri: "[{\"username\":\"Name2\",\"tweet\":\"Tweet0\"},{\"username\":\"Name3\",\"tweet\":\"Tweet1\"}]"}
    }

    describe '#call' do
      before do
        allow(service).to receive(:collect_web_responses)
        service.instance_variable_set(:@web_data, mocked_web_data)
      end

      let(:formatted_data) { service.call }
      let(:response_keys) { %i[facebook instagram twitter] }

      it 'returns valid formatted mocked data' do
        expect(formatted_data).to be_a(Hash)
      end

      it 'provides required keys' do
        formatted_data.keys.each{ |key| expect(response_keys).to include(key) }
      end

      it 'returns valid facebook statuses' do
        expect(formatted_data[:facebook].length).to eq(2)
        expect(formatted_data[:facebook][0]).to eq('Status0')
      end

      it 'returns valid twitter tweets' do
        expect(formatted_data[:twitter].length).to eq(2)
        expect(formatted_data[:twitter][0]).to eq('Tweet0')
      end

      it 'successfully processes errors' do
        expect(formatted_data[:instagram]).to be_a(String)
        expect(formatted_data[:instagram]).to eq('page not found')
      end
    end
  end
end