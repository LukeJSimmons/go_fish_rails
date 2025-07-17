RSpec.describe Bot do
  let(:bot) { Bot.new(Bot.generate_name) }

  describe '#request' do
    let(:bot_hand) { [ Card.new('A', 'H') ] }

    before do
      bot.hand = bot_hand
    end

    it 'returns a card from hand' do
      expect(bot.hand.map(&:rank)).to include bot.request
    end
  end

  describe '#generate_name' do
    it 'returns name with unique index' do
      Bot.number_of_bots = 0
      expect(Bot.generate_name).to eq "Bot 1"
    end
  end
end
