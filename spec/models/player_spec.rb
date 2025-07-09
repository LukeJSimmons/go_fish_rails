RSpec.describe Player do
  let(:player) { Player.new(1, 'Player 1') }
  it 'has a user_id' do
    expect(player).to respond_to :user_id
  end

  it 'has a name' do
    expect(player).to respond_to :name
  end
end
