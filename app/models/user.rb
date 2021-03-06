# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  extend Enumerize
  enumerize :role, in: %i[root turf_admin partner_admin]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :partners
  has_and_belongs_to_many :turfs
  has_many :sites, foreign_key: :site_admin

  validates_presence_of :email
  validates_uniqueness_of :email

  before_save :update_role

  def full_name
    (first_name || '') + ' ' + (last_name || '')
  end

  def admin_name
    "#{last_name}, #{first_name} <#{email}>"
  end

  # Protects from unnecessary database queries
  def update_role
    return if role == 'root'
    self.role =
      if turfs.any?
        'turf_admin'
      elsif partners.any?
        'partner_admin'
      end
  end
end
