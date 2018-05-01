class UserMailer < ApplicationMailer
    default from: 'noreply@placecal.org'
    helper MountainView::ComponentHelper

    def next_week
        @user = params[:user]
        @partners = Partner.of_user(@user)
        @url = 'https://placecal.org/' # replace with verification link
        @events = Event.by_partner(@partner)
        mail(to: @user.email, subject: 'Please verify events for next week')

    end

end
