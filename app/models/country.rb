# == Schema Information
#
# Table name: countries
#
#  id              :integer          not null, primary key
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#  organization_id :integer
#  user_id         :integer
#

class Country < ActiveRecord::Base
include PublicActivity::Model
tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  belongs_to :organization
  belongs_to :user
  has_many :sites, dependent: :destroy

  validates_presence_of :name, :organization_id
  validates_uniqueness_of :name, case_sensitive: false, scope: :organization_id
  # add search feature
    def self.search(search)
    where("name iLIKE ?", "%#{search}%")
  end

end
