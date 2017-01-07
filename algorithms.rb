require_relative 'polynom'
require_relative 'tools'

module Algorithms

  class QuotientRing
    def initialize(gf, f)
      @f = f
      @field = Field.new(gf)
    end
    attr_accessor :field, :f
  public
    def inverse(pol)
      e = Algorithms::euclid(@f, pol)
      d1 = e[1] * @field.inverse(e[2].to_i)
      assert((pol*d1)%(@f) == pol.one, "This is not inverse")
      return d1
    end
    def divide(d1, d2)
      return (inverse(d2)*d1)%(@f)
    end
  end



  def Algorithms::euclid(p1, p2)
    x = [p1.one, p1.zero]
    y = [p1.zero, p1.one]
    # p1.pp
    # p2.pp
    while p2.degree > 0
      result = p1.divide p2
      p3 = result[1]
      d = result[0]
      # p3.pp

      x << x[-2] - d * x[-1]
      y << y[-2] - d * y[-1]
      p1 = p2
      p2 = p3
    end
    return [x.last, y.last, p3, p1]
  end

  def Algorithms::gcd(p1, p2)
    e = Algorithms::euclid(p1,p2)
    if e[2].to_i == 0
      return e[3]
    else
      return Polynom.new([1], p1.field.maxval)
    end
  end


  # def Algorithms::polynomials_n(n, field)
  #   list = []
  #   start = Polynom.new([0,1], field)
  #   finish = []
  #   (n+1).times do
  #     finish.push(field-1)
  #   end
  #   finish = Polynom.new(finish, field)
  #   one = start.one
  #   while start != finish
  #     list << start
  #     start += one
  #   end
  #   list << finish
  #   return list
  # end

  # def Algorithms::irreducible_polynomials(deg, field)
  #   # list of all polynomials of degree <= deg/2
  #   d = deg
  #   result = Algorithms::polynomials_n(d, field)
  #   puts "Polynomials of degree #{d} over F(#{field})"
  #   result.each do |pol|
  #     pol.pp
  #   end
  # end
end