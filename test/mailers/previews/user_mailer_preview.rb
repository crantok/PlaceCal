# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def next_week
        UserMailer.with(user: User.first).next_week
    end

end
