# == Schema Information
#
# Table name: audios
#
#  id         :integer          not null, primary key
#  content    :text
#  audio      :string
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Audio < ActiveRecord::Base
  belongs_to :article

  mount_uploader :audio, AudioUploader
end
