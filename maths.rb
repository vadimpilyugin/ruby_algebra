module Maths
  def Maths::abs(number)
    if number < 0
      return -number
    else
      return number
    end
  end

  def Maths::trunc(number)
    if number == 0
      return 0
    elsif number > 0
      return 1
    else
      return -1
    end
  end
end