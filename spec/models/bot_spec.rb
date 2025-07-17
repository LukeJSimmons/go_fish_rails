RSpec.describe Bot do
  let(:bot) { Bot.new(Bot.generate_name, 0) }

  it 'has a difficulty' do
    expect(bot).to respond_to :difficulty
  end

  describe '#request' do
    let(:bot_hand) { [ Card.new('A', 'H') ] }

    before do
      bot.hand = bot_hand
    end

    context 'when difficulty is 0' do
      it 'returns a card from hand' do
        expect(bot.hand.map(&:rank)).to include bot.request
      end
    end

    context 'when difficulty is 2' do
      let(:bot) { Bot.new(Bot.generate_name, 2) }
      let(:bot_hand) { [ Card.new('A', 'H'), Card.new('10', 'H') ] }

      context 'when opponent has matching cards' do
        let(:target_hand) { [ Card.new('A', 'C') ] }
        let(:target) { Player.new('Player 1', 1, target_hand) }

        it 'returns rank of matching cards' do
          expect(target_hand.map(&:rank)).to include bot.request(target)
        end
      end

      context 'when opponent does not have matching cards' do
        let(:target_hand) { [ Card.new('9', 'C') ] }
        let(:target) { Player.new('Player 1', 1, target_hand) }

        it 'returns rank of card in hand' do
          expect(bot.hand.map(&:rank)).to include bot.request(target)
        end
      end
    end
  end

  describe '#generate_name' do
    let(:second_bot) { Bot.new(Bot.generate_name, 0) }

    before(:all) {
      Bot.reset_number_of_bots
    }

    it 'returns name with unique index' do
      expect(bot.name).to eq "Bot 1"
      expect(second_bot.name).to eq "Bot 2"
    end
  end
end
