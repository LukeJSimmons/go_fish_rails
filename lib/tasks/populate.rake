desc "Create 100 Users and Games for Each"
task populate: :environment do
  30.times.each_with_index do |i|
    User.create(
      email: "user#{i}@example.com",
      username: "Test",
      password: "password",
      password_confirmation: "password"
    )
  end
  user_count = User.count
  30.times.each_with_index do |i|
    offset = rand(user_count)
    users = User.offset(offset).first((2..5).to_a.sample)
    game = Game.create!(users: users, name: "Game #{i}", players_count: users.count, bots_count: 0, bot_difficulty: 0)
    game.start_if_possible!
    # play random number of rounds or all the way through
  end
end
