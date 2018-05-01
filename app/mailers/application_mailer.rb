class ApplicationMailer < ActionMailer::Base
  #helper MountainView::ComponentHelper
  default from: 'info@placecal.org'
  layout 'mailer'
end
