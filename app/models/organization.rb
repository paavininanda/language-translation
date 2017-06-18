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

  validates :name, presence: true
  # add search feature
    def self.search(search)
    where("name iLIKE ?", "%#{search}%")
  end

end
