class Oystercard
  BALANCE_LIMIT = 90
  MINIMUM_FARE = 2
  attr_reader :balance
  def initialize
    @balance = 0
    @travel_status = false
  end

  def top_up(amount)
    fail 'Balance limit is 90' if exceeded?(amount)
    @balance += amount
  end

  def exceeded?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def in_journey?
    @travel_status == true
  end

  def touch_in
    @travel_status = true
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @travel_status = false
  end

  private
  def deduct(fare)
    @balance -= fare
  end
end
