class Site < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one :sites_turf
  has_one :primary_turf, -> { where(sites_turfs: {relation_type: 'Primary'})}, source: :turf, through: :sites_turf

  has_many :sites_turfs
  has_many :secondary_turfs, -> { where(sites_turfs: {relation_type: 'Secondary'})}, source: :turf, through: :sites_turfs

  accepts_nested_attributes_for :sites_turf
  accepts_nested_attributes_for :sites_turfs, :reject_if => lambda { |c| c[:turf_id].blank? } 

  validates :name, :slug, :domain, presence: true
end

