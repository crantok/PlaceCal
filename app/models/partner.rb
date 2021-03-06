# frozen_string_literal: true

# app/models/partner.rb
class Partner < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :users
  has_and_belongs_to_many :places
  has_and_belongs_to_many :turfs, validate: true
  has_many :calendars, dependent: :destroy
  has_many :events
  belongs_to :address, required: false

  accepts_nested_attributes_for :places, allow_destroy: true
  accepts_nested_attributes_for :calendars, allow_destroy: true

  accepts_nested_attributes_for :address, reject_if: ->(c) { c[:postcode].blank? && c[:street_address].blank? }

  validates_presence_of :name
  validates_uniqueness_of :name
  # validates_presence_of :turf_ids

  mount_uploader :image, ImageUploader

  after_save :update_users

  def to_s
    name
  end

  # def custom_validation_method_with_message
  #   errors.add(:_, "Select at least one Turf") if turf_ids.blank?
  # end

  def permalink
    "https://placecal.org/partners/#{id}"
  end

  private

  def update_users
    users.each(&:update_role)
  end
end
