FactoryGirl.define  do
  factory :user, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {"123456"}
    avatar {Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support",
      "images", "download.jpg"))}
    story {Faker::Lorem.sentence}
    role {1}
    slug {Faker::Name.name}
  end

  factory :invalid_user, class: User do
    name {""}
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    avatar {Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support",
      "images", "download.jpg"))}
    story {Faker::Lorem.sentence}
    role {1}
    slug {Faker::Name.name}
  end
end
