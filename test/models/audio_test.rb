require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should upload audio" do
    audio = build(:audio, audio: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')), content: "Test Content" )
    assert audio.save, "Unable to save the audio file."
  end

  test "should validate presence of content" do
    audio = build(:audio, audio: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')), content: nil )
    assert_not audio.save, "Saved the audio file without content."
  end

  context "associations" do
  	should belong_to(:article)
  end

  context "validations" do
    should validate_presence_of(:content)
  end
end