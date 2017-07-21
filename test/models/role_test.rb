# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_id   :integer
#  resource_type :string
#  created_at    :datetime
#  updated_at    :datetime
#

require "test_helper"

class RoleTest < ActiveSupport::TestCase
  def role
    @role ||= Role.new
  end

  def test_valid
    assert role.valid?
  end
end
