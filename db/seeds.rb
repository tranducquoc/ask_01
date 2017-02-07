path = Rails.root.join("app", "assets", "images", "no_image.jpg").to_s

votes = [1,2,3,4,5,6,7,8,9,10]
views = [1,2,3,4,5,6,7,8,9,10]

user_ids = []
topic_ids = []
question_ids = []
answer_ids = []
comment_ids = []

10.times do
  name = Faker::Name.name
  user = User.new
  user.name = name
  user.email = Faker::Internet.email
  user.encrypted_password = "$2a$11$gHWhyOjpXvNJWzqKnwbdTesD87G0MSZV8UH0FRKeByvEz5xjIwSfC"

  File.open(path) do |f|
    user.avatar = f
  end
  user.save!
  user_ids.push user.id
end

topic_list = [
  [ "Scientic", "Day la chuyen muc scientic"],
  [ "E commerce", "Day la chuyen muc e commerce"],
  [ "Trending", "Day la chuyen muc trending"],
  [ "Architect", "Day la chuyen muc architect"]
]
topic_list.each do |name, description, icon|
  topic = Topic.new
  topic.name = name
  topic.description = description
  File.open(path) do |f|
    topic.icon = f
  end

  topic.save!
  topic_ids.push topic.id
end

10.times do
  question = Question.new
  question.title = Faker::Lorem.sentence
  question.content = Faker::Lorem.paragraph
  question.up_vote = votes.sample
  question.down_vote = votes.sample
  question.views = views.sample
  question.user_id = user_ids.sample
  question.save!

  question_ids.push question.id
end

10.times do
  answer = Answer.new
  answer.content = Faker::Lorem.paragraph
  answer.reply_to = question_ids.sample
  answer.up_vote = votes.sample
  answer.down_vote = votes.sample
  answer.user_id = user_ids.sample
  answer.save!
	
  answer_ids.push answer.id
end

10.times do
  comment = Comment.new
  comment.content = Faker::Lorem.paragraph

  isQuestion = [true, false].sample

  if isQuestion	
    comment.commentable_id = question_ids.sample
    comment.commentable_type = "Question"
  else
    comment.commentable_id = answer_ids.sample
    comment.commentable_type = "Answer"
  end
	    	    
  comment.up_vote = votes.sample
  comment.user_id = user_ids.sample
  comment.save!
	
  comment_ids.push comment.id
end
