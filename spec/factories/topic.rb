FactoryGirl.define  do
  factory :topic, class: Topic do
    name {Faker::Name.name}
    description {Faker::Lorem.paragraph}
    icon {Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support",
      "images", "download.jpg"))}
    slug {Faker::Name.name}
  end

  factory :invalid_topic, class: Topic do
    name {""}
    description {Faker::Lorem.paragraph}
    icon {Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support",
      "images", "download.jpg"))}
    slug {Faker::Name.name}
  end
end
