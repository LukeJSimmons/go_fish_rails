namespace "data" do
  desc "Create 100 Users and Games for Each"
  task populate: :environment do |t, args|
    user_count = args.extras[0].to_i
    user_count.times.each_with_index do |i|
      User.create(
        email: "user#{i}@example.com",
        username: "Test #{i}",
        password: "password",
        password_confirmation: "password"
      )
      puts "Created User #{i}"
    end
    user_count = User.count
    user_count.times.each_with_index do |i|
      offset = rand(user_count)
      users = User.offset(offset).first((2..5).to_a.sample)
      game = Game.create!(users: users, name: "Game #{i}", players_count: users.count, bots_count: 0, bot_difficulty: 0, winner_id: users.first.id, end_time: Time.now + 10.minutes)
      game.start_if_possible!
      puts "Created Game #{i}"
      # play random number of rounds or all the way through
    end
  end
end
