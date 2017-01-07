require_relative 'tools'
require_relative 'maths'

def clone_list(list)
  newlist = []
  list.each do |elem|
    printf "Число #{elem}: #{elem.hash}\n"
    newlist.push(0)
  end
  return newlist
end

class Object
  def deep_clone
    return @deep_cloning_obj if @deep_cloning
    @deep_cloning_obj = clone
    @deep_cloning_obj.instance_variables.each do |var|
      val = @deep_cloning_obj.instance_variable_get(var)
      begin
        @deep_cloning = true
        val = val.deep_clone
      rescue TypeError
        next
      ensure
        @deep_cloning = false
      end
      @deep_cloning_obj.instance_variable_set(var, val)
    end
    deep_cloning_obj = @deep_cloning_obj
    @deep_cloning_obj = nil
    deep_cloning_obj
  end
end

class Field
  def initialize(maxval)
  	assert(maxval.class == Fixnum, "Not a number")
  	@maxval = maxval
  end

  attr_accessor :maxval

public
  def truncate(number)
  	assert(number.class == Fixnum, "Not a number")
  	return number % @maxval
  end
  def inverse(number)
  	assert(number.class == Fixnum, "Not a number")
  	number = truncate(number)
  	found_it = 0
  	(1..maxval-1).each do |element|
  	  if truncate(element * number) == 1
  	  	found_it = element
  	  end
  	end
  	assert(found_it != 0, "Hadn't found an inverse element for #{number} in F(#{maxval})")
  	return found_it
  end
  def divide(a,b)
    return truncate(inverse(b)*a)
  end
  def == other
    @maxval == other.maxval
  end
end

class Polynom
  @@format = nil

  def initialize(coeffs, maxval)
  	@coeffs = coeffs
  	@field = Field.new(maxval)
  end

  def zero
    return Polynom.new([0], @field.maxval)
  end

  def one
    return Polynom.new([1], @field.maxval)
  end

  attr_accessor :field, :coeffs
  def Polynom.format(format)
    @@format = format
  end

  def initialize_copy(orig)
    @coeffs = orig.coeffs.clone
  end

public

  def truncate
  	@coeffs.map! do |elem|
  	  @field.truncate(elem)
  	end
  	return self
  end

  # Adding two polynomials together
  def + other
  	assert(other.class == Polynom, "Not a polynom")
    assert(other.field.maxval == @field.maxval, "Polynoms from different fields: F(#{other.field.maxval}) and F(@field.maxval)")
    result = if @coeffs.count > other.coeffs.count
      Polynom.new(@coeffs.zip(other.coeffs).map{ |a| a.map(&:to_i).inject(&:+) }, @field.maxval)
    else
      Polynom.new(other.coeffs.zip(@coeffs).map{ |a| a.map(&:to_i).inject(&:+) }, @field.maxval)
    end
    return result.truncate
  end

  # + but persistent
  def plus! other
    assert(other.class == Polynom, "Not a polynom")
    assert(other.field.maxval == @field.maxval, "Polynoms from different fields: F(#{other.field.maxval}) and F(@field.maxval)")
    if @coeffs.count > other.coeffs.count
      @coeffs = @coeffs.zip(other.coeffs).map{ |a| a.map(&:to_i).inject(&:+) }
    else
      @coeffs = other.coeffs.zip(@coeffs).map{ |a| a.map(&:to_i).inject(&:+) }
    end
  end

  def - other
    return self + other*(-1)
  end

  def ** count
    assert(count.class == Fixnum, "Degree is not a number!")
    ans = one
    count.times do
      ans = ans * self
    end
    return ans
  end

  # Multiplying two polynomials together
  def * other
    if other.class == Fixnum
      @coeffs.map! {|elem| elem * other}
      return self.truncate
    end
    result = zero
    @coeffs.each_with_index do |c, i|
      result.plus! other.scale(c).shift(i)
    end
    return result.truncate
  end

  def == other
    degree
    @coeffs == other.coeffs && @field == other.field
  end

  def scale n
    Polynom.new(@coeffs.map { |c| c * n }, @field.maxval)
  end

  # Multiplies the polynomial by x^n
  def shift n
    Polynom.new(@coeffs.unshift(*([0]*n)), @field.maxval)
  end

  def deg n
    result = one
    n.times do
      result = result * self
    end
    return result
  end

  def to_i
    assert(degree == 0, "Unable to_i")
    return @coeffs[0]
  end

  def degree
    assert(!@coeffs.empty?, "Empty polynom")
    return 0 if @coeffs.size == 1
    return @coeffs.size-1 unless @coeffs.last == 0
    a = @coeffs.reverse
    while true 
      n = a.shift
      if n != 0
        a.unshift(n)
        break
      end
    end
    @coeffs = a.reverse
    @coeffs = [0] if @coeffs == [nil]
    return @coeffs.size-1
  end

  def varchange other
    result = zero
    assert(other.class == Polynom, "Not a polynom, so i can't change")
    coeffs.each_with_index do |coef, i|
      term = (other**i)*coef
      result = result + term
    end
    return result
  end

  # def euclid(pol1, pol2)

  def divide other
    p1 = self
    p2 = other
    p3 = zero
    while (p1.degree >= p2.degree) && (p1 != zero)
      divide = Polynom.new([@field.divide(p1.coeffs.last, p2.coeffs.last)], @field.maxval).shift(p1.degree - p2.degree)
      multiply = p2*divide
      subtract = p1-multiply
      p1 = subtract
      p3 = p3 + divide
    end
    return [p3, p1]
  end

  def % other
    return divide(other)[1]
  end

  def / other
    return divide(other)[0]
  end

  def pp()
    degree

    terms = []

    coef = -> (number) {
      if number == 1 or number == -1
        return ""
      else 
        return "#{Maths::abs(number)}"
      end
    }
    @coeffs.each_with_index do |elem, i|
      if i == 0
        term = "#{Maths::abs(elem)}"
      elsif i == 1
        term = "#{coef.call(elem)}x"
      else 
        term = "#{coef.call(elem)}x^#{i}"
      end
      sign = Maths::trunc(elem)
      terms << {term: term, sign: "#{sign < 0 ? "-" : "+"}"} unless sign == 0

      # printf "#{elem}x^#{i} + " if elem != 0 && elem != 1 && elem != -1
      # if elem == 1
      #   printf "x^#{i} + "
      # elsif elem == -1
      #   printf "-x^#{i} + "
      # end

    end
    s = ""
    if terms.empty? 
      s << "0"
    else
      terms.reverse.each_with_index do |term, i|
        if i == 0
          s << "#{term[:sign] unless term[:sign] == "+"}#{term[:term]}"
        else
          s << " #{term[:sign]} #{term[:term]}"
        end
      end
    end
    if @@format == "\n"
      puts s
    else
      return s
    end
  end
end