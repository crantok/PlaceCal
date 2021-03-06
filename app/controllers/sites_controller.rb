# frozen_string_literal: true

# app/controllers/sites_controller.rb
class SitesController < ApplicationController
  before_action :get_home_turf, only: [:site]
  before_action :set_site, only: [:index]

  def index
    render template: 'sites/default.html.erb'
  end

  def robots
    robots = File.read(Rails.root.join("config/robots/robots.#{Rails.env}.txt"))
    render plain: robots
  end

  private

  def set_site
    @site = Site.find_by(slug: request.subdomain)
  end
end
