require 'oystercard'

describe Oystercard do
  let (:fake_entry_station) { double("Holborn") }
  let (:fake_exit_station) { double("Picadilly") }

  before(:each) do
    subject.top_up(1)
    subject.touch_in(fake_entry_station)
  end

  describe '#balance' do
    it 'returns a balance of 0 on a new card' do
      oystercard = Oystercard.new
      expect(oystercard.balance).to eq 0
    end
  end

  context 'checking for no journey history for new card' do
    it 'checks the history is empty on object instace' do
      expect(subject.history).to be_empty
    end
  end
  describe '#top_up' do
    it 'checks that top_up increases balance by 1' do
      expect(subject.balance).to eq 1
    end

    it 'raises an error if top up limit is exceeded' do
      expect { subject.top_up(90) }.to raise_error 'Balance limit is 90'
    end
  end

  describe '#in_journey' do
    it 'checks that a new card is not in use' do
      subject.touch_out(fake_exit_station)
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    it 'checks that a card is in use after touching in' do
      expect(subject.in_journey?).to eq true
    end

    it 'should be able to record entry station upon touching in' do
      expect(subject.entry_station).to eq fake_entry_station
    end
  end

  describe '#touch_out' do
    it 'checks that a card in no longer in use after touching out' do
      subject.touch_out(fake_exit_station)
      expect(subject).not_to be_in_journey
    end

    it 'raises error when trying to touch in with balance less than 1' do
      subject.touch_out(fake_exit_station)
      expect { subject.touch_in(fake_entry_station) }.to raise_error "Insufficient funds!"
    end

    it 'deducts minimum fare upon touch out' do
      expect { subject.touch_out(fake_entry_station) }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'should log exit station upon exit' do
      subject.touch_out(fake_exit_station)
      expect(subject.exit_station).to eq fake_exit_station
    end

    it 'updates journey history' do
      subject.touch_out(fake_exit_station)
      expect(subject.history).to eq [{ entry: fake_entry_station, exit: fake_exit_station }]
    end
  end
end
