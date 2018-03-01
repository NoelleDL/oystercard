class Oystercard
  BALANCE_LIMIT = 90
  MINIMUM_FARE = 2
  MINIMUM_BALANCE = 1
  attr_reader :balance, :history, :entry_station, :exit_station

  def initialize
    @balance = 0
    @history = []
    @entry_station = nil
    @exit_station = nil
  end

  def top_up(amount)
    fail 'Balance limit is 90' if exceeded?(amount)
    @balance += amount
  end

  def exceeded?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def in_journey?
    @entry_station != nil
  end

  def touch_in(station)
    fail "Insufficient funds!" unless balance >= MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @exit_station = exit_station
    @history << { entry: @entry_station, exit: @exit_station }
    @entry_station = nil
  end

  private
  def deduct(fare)
    @balance -= fare
  end
end
