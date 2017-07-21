# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  has_many :users, dependent: :delete_all
  has_many :countries

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  # add search feature
  def self.search(search)
    where("name iLIKE ?", "%#{search}%")
  end
end