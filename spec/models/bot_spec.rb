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
    let(:second_bot) { Bot.new(Bot.generate_name) }

    before(:all) {
      Bot.reset_number_of_bots
    }

    it 'returns name with unique index' do
      expect(bot.name).to eq "Bot 1"
      expect(second_bot.name).to eq "Bot 2"
    end
  end
end
