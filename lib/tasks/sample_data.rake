namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "stepofchange",
                         email: "stepofchange.vlad@gmail.com",
                         password: "3131567e",
                         password_confirmation: "3131567e",
                         admin: true)
    end
end                         