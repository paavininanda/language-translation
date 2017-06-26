require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should upload audio" do
  	audio = build(:audio, audio: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')) )
    assert audio.save, "Saved the audio file"
  end

  context "associations" do
  	should belong_to(:article)
  end
end