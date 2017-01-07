gem "minitest"     # ensures you"re using the gem, and not the built-in MT
require "minitest/autorun"

require_relative "../polynom.rb"
require_relative "../algorithms.rb"

class TestPolynom < Minitest::Test
  def setup

  end

  def test_division
  	p1 = Polynom.new([1], 3)
  	p2 = Polynom.new([2], 3)
  	assert (p1 / p2).to_i == 2

  	p1 = Polynom.new([1,1],2)
  	p2 = Polynom.new([1,1,1],2)
  	assert(p1/p2 == p1.zero, "Not zero!")
  	assert(p2/p1 == Polynom.new([0,1], 2), "Wrong!")

  	# 2x^5 + x^4 + 4x + 3 over 3x^2 + 1 equals 4x^3 + 2x^2 + 2x + 1, 2x+2
  	p1 = Polynom.new([3,4,0,0,1,2], 5)
  	p2 = Polynom.new([1,0,3], 5)
  	assert(p1/p2 == Polynom.new([1,2,2,4], 5), "Wrong...")
  	assert(p1%p2 == Polynom.new([2,2], 5), "^^^")

  	p1 = Polynom.new([1,0,1,0,1,0,0,1], 2)
  	p2 = Polynom.new([1,1,0,1], 2)
  	assert(p1/p2 == Polynom.new([1,0,1,0,1], 2), "Wrong...")
  	assert(p1%p2 == Polynom.new([0,1], 2), "^^^")
  end

  def test_multiplication
  	p1 = Polynom.new([1,2,2,4], 5)
  	p2 = Polynom.new([1,0,3], 5)
  	p3 = Polynom.new([2,2], 5)
  	assert(p1*p2+p3 == Polynom.new([3,4,0,0,1,2], 5), "Я съем свои ботинки")

  	assert(Polynom.new([0], 7)*Polynom.new([1,1,1,1], 7) == Polynom.new([0], 7), "Not zero!!")
  end

  def test_gcd
  	p1 = Polynom.new([1,1,1,1], 5)
  	p2 = Polynom.new([4,0,1], 5)
  	assert(Algorithms::gcd(p1,p2) == Polynom.new([2,2], 5), "True")

  	p1 = Polynom.new([3,0,1,1,1], 7)
  	p2 = Polynom.new([3,1,1], 7)
  	assert(Algorithms::gcd(p1,p2) == Polynom.new([1], 7), "True")
  end

  def test_inverse
  	p1 = Polynom.new([3,0,1,1,1], 7)
  	p2 = Polynom.new([3,1,1], 7)
  	assert Algorithms::QuotientRing.new(7, p1).inverse(p2) == Polynom.new([5,2,0,6], 7), "Not true"
  end

end