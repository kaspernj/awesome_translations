FactoryGirl.define do
  factory :user do
    email { Forgery::Internet.email_address }
    password { Forgery::LoremIpsum.words(2, random: true) }
    age { (0..10).to_a.sample }
  end
end
