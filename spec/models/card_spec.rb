RSpec.describe Card do
  let(:card) { Card.new('A', 'H') }
  it 'has a rank' do
    expect(card).to respond_to :rank
  end

  it 'has a suit' do
    expect(card).to respond_to :suit
  end

  context 'when rank is invalid' do
    let(:card) { Card.new('14', 'H') }

    it 'throws error' do
      expect { card }.to raise_error StandardError
    end
  end

  context 'when suit is invalid' do
    let(:card) { Card.new('2', 'Y') }

    it 'throws error' do
      expect { card }.to raise_error StandardError
    end
  end
end
