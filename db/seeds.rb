# 5.times do
#   Article.create({
#       title: Faker::Book.title,
#       body: Faker::Lorem.sentence
#   })
# end

# 5.times do
#   Article.create({
#       name: Faker::Name.title,
#       email: "#{Faker::Internet.user_name}@micronetbd.org",
#       contact: Faker::PhoneNumber.cell_phone
#   })
# end

10.times do
  name = Faker::Name.first_name
  email = "#{name}@micronetbd.org"
  contact = Faker::PhoneNumber.cell_phone
  user = User.create!(name: name, email: email, contact: contact)

  rand(2..4).times do
    title = Faker::Book.title
    body = Faker::Lorem.paragraph(12)
    article = Article.new(title: title, body: body)
    article.user = user
    article.save!
  end
end