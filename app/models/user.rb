# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  username               :string
#  location               :string
#  contact                :string
#  gender                 :string
#  lang                   :string
#  tsv_data               :tsvector
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  authentication_token   :string
#  login_approval_at      :datetime
#  organization_id        :integer
#


class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  def self.search(search)
    where("location iLIKE ?", "%#{search}%")
  end

  attr_accessor :no_invitation
  mount_uploader :avatar, AvatarUploader
  GENGER={male: "Male", female: "Female"}

  rolify
  include PgSearch

  belongs_to :organization

  # DEVISE: Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :recoverable, :rememberable, :trackable, :token_authenticatable, :invitable
  
  # User Avatar Validation
  validates_integrity_of  :avatar
  validates_processing_of :avatar

  def avatar_url(user)
    if user.avatar_url.present?
      user.avatar_url
    end
  end
    
  default_scope -> { order('created_at DESC') }

  validates_uniqueness_of :username
  validates_presence_of :username, :first_name, :last_name, :organization_id
  validates :username, :length => { :maximum => 10 }
  validates :username, format: {with: /\A(?=.*[a-z])[a-z\d]+\Z/i, message: ' : Only alphaumeric characters allowed, but not purely numeric.'}

  validates :contact, numericality: { only_integer: true, message: ' : Supports only Digits' }, :allow_blank => true

  validates :first_name, :length => { :maximum => 10 }
  validates :first_name, format: {with: /\A(?=.*[a-z])[a-z\d]+\Z/i, message: ' : Only alphaumeric characters allowed, but not purely numeric.'}

  validates :last_name, :length => { :maximum => 10 }
  validates :last_name, format: {with: /\A(?=.*[a-z])[a-z\d]+\Z/i, message: ' : Only alphaumeric characters allowed, but not purely numeric.'}

  validates :avatar, file_size: { less_than: 0.5.megabytes }

  # default order when calling the User model
  default_scope -> { order('created_at DESC') }

  after_create  :send_invitation
  before_save   :ensure_authentication_token

  private
  def send_invitation
    invite! if no_invitation=="0"
  end
end