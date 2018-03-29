import unittest
import polynomial
from polynomial import Polynom
from polynomial import Field
from algorithms import QuotientRing
from algorithms import Algorithms
from interface import Interface as I

class TestFieldMethods(unittest.TestCase):

  def test_creation(self):
    gf = Field(5)
  def test_inverse_elements_in_simple_field(self):
    gf = Field(23)
    inversed_elems = [None,1,12,8,6,14,4,10,3,18,7,21,2,16,5,20,13,19,9,17,15,11,22]
    for i in range(0,gf.modulus):
      with self.subTest(i = i):
        self.assertEqual(inversed_elems[i], gf.inverse(i))

  def test_inverse_in_one_element_field(self):
    gf = Field(1)
    self.assertIsNone(gf.inverse(0))

  def test_inverse_in_two_element_field(self):
    gf = Field(2)
    self.assertEqual(gf.inverse(1), 1)

  def test_division(self):
    gf = Field(23)
    for i in range(0,gf.modulus):
      for j in range(1,gf.modulus):
        self.assertEqual(gf.mult(gf.divide(i,j), j), i)

  def test_inverse_in_non_prime_field(self):
    gf = Field(21)
    for i in range(0,gf.modulus):
      if i in [0,3,6,7,9,12,14,15,18]:
        self.assertIsNone(gf.inverse(i))
      else:
        self.assertIsNotNone(gf.inverse(i))

class TestPolynomMethods(unittest.TestCase):

  def test_creation(self):
    p = Polynom([1,2,3], 5)

  def test_repr(self):
    p = Polynom([0], 5)
    self.assertEqual(p.__repr__(), "0")
    p = Polynom([0,0,0,0], 5)
    self.assertEqual(p.__repr__(), "0")
    p = Polynom([0,0,0,0,1], 5)
    self.assertEqual(p.__repr__(), "x^4")
    p = Polynom([0,0,0,0,-1], 5)
    self.assertEqual(p.__repr__(), "-x^4")
    p = Polynom([0,-1], 5)
    self.assertEqual(p.__repr__(), "-x")
    p = Polynom([0,1], 5)
    self.assertEqual(p.__repr__(), "x")
    p = Polynom([3], 5)
    self.assertEqual(p.__repr__(), "3")
    p = Polynom([-3], 5)
    self.assertEqual(p.__repr__(), "-3")

    p = Polynom([1,2,-3,4,-5], 5)
    self.assertEqual(p.__repr__(), "-5x^4 + 4x^3 - 3x^2 + 2x + 1")
    p = Polynom([0,1,0,-1,0], 5)
    self.assertEqual(p.__repr__(), "-x^3 + x")

  def test_equal(self):
    p1 = Polynom([0,0,0,0], 5)
    p2 = Polynom([0,0,0], 5)
    self.assertEqual(p1, p2)
    p1 = Polynom([1,2,3], 5)
    p2 = Polynom([1,2,3,0,0,0], 5)
    self.assertEqual(p1, p2)
    p1 = Polynom([1], 5)
    p2 = Polynom([0, 1], 5)
    self.assertNotEqual(p1, p2)

  def test_sum(self):
    p1 = Polynom([1,2,3], 5)
    p2 = Polynom([2,3,4], 5)
    self.assertEqual(p1+p2, Polynom([3,0,2], 5))
    p1 = Polynom([0,0,0,1], 5)
    p2 = Polynom([0,1,1,0], 5)
    p3 = Polynom([3,0,0,0,7], 5)
    self.assertEqual(p1+p2+p3, Polynom([3,1,1,1,2], 5))
    self.assertEqual(p1+p2+p3, p3+p2+p1)

  def test_subtract(self):
    p1 = Polynom([1,2,3], 5)
    p2 = Polynom([7,7,7], 5)
    self.assertEqual(p1-p2, Polynom([4,0,1], 5))
    p1 = Polynom([0,0,1,1], 5)
    p2 = Polynom([1,1,0,0], 5)
    self.assertEqual(p1-p2, Polynom([4,4,1,1], 5))
    self.assertEqual(p2-p1, Polynom([1,1,4,4], 5))
    self.assertEqual(p1-p2, -(p2-p1))

  def test_negate(self):
    p = Polynom([4,4,1,1,4,4,1,1], 5)
    self.assertEqual(-p, Polynom([1,1,4,4,1,1,4,4], 5))
    self.assertEqual(p, -(-p))

  def test_scale(self):
    p = Polynom([1,2,3,4,0], 5)
    self.assertEqual(p.scale(2), Polynom([2,4,1,3,0], 5))

  def test_shift(self):
    p = Polynom([1,2,3,4], 5)
    self.assertEqual(p.shift(2), Polynom([0,0,1,2,3,4], 5))

  def test_multiply(self):

    p1 = Polynom([1], 5)
    p2 = Polynom([2], 5)
    self.assertEqual(p1*p2, Polynom([2], 5))

    p1 = Polynom([0,1,2,3,4], 5)
    p2 = Polynom([3], 5)
    self.assertEqual(p2*p1, p1*p2)
    self.assertEqual(p1*p2, Polynom([0,3,1,4,2], 5))

    p1 = Polynom([0,1], 5)
    p2 = Polynom([1,2,3,4], 5)
    self.assertEqual(p1*p2, Polynom([0,1,2,3,4], 5))

    p1 = Polynom([1,1], 5)
    p2 = Polynom([1,1,1,1], 5)
    self.assertEqual(p1*p2, Polynom([1,2,2,2,1], 5))
    
    p1 = Polynom([1,2,2,4], 5)
    p2 = Polynom([1,0,3], 5)
    self.assertEqual(p1*p2, p2*p1)
    self.assertEqual(p1*p2, Polynom([1,2,0,0,1,2], 5))

    self.assertEqual(Polynom([0,0,0,0,0], 5) * p1, p1.zero())

  def test_exponentiate(self):
    p = Polynom([0,1], 5)
    self.assertEqual(p**5, Polynom([0,0,0,0,0,1], 5))
    p = Polynom([1,1], 5)
    self.assertEqual(p**5, Polynom([1,5,10,10,5,1], 5).truncate())
    p = Polynom([1,2,-3], 5)
    self.assertEqual(p**5, Polynom([1,10,25,-40,-190,92,570,-360,-675,810,-243], 5).truncate())

  def test_division_residue(self):
    p = Polynom([1,1,1,1], 5)
    q = Polynom([4,0,1], 5)
    mod = p % q
    div = p // q
    self.assertEqual(q * div + mod, p)
    self.assertEqual(div, Polynom([1,1], 5))
    self.assertEqual(mod, Polynom([2,2], 5))

  def test_division(self):
    p1 = Polynom([1], 3)
    p2 = Polynom([2], 3)
    self.assertEqual(int(p1//p2), 2)

    p1 = Polynom([1,1],2)
    p2 = Polynom([1,1,1],2)
    self.assertEqual(p1//p2, p1.zero())

    p1 = Polynom([3,4,0,0,1,2], 5)
    p2 = Polynom([1,0,3], 5)
    self.assertEqual(p1//p2, Polynom([1,2,2,4], 5))
    self.assertEqual(p1%p2, Polynom([2,2], 5))

    p1 = Polynom([1,0,1,0,1,0,0,1], 2)
    p2 = Polynom([1,1,0,1], 2)
    self.assertEqual(p1//p2, Polynom([1,0,1,0,1], 2))
    self.assertEqual(p1%p2, Polynom([0,1], 2))

class TestQuotientRingMethods(unittest.TestCase):
  def test_inverse(self):
    p1 = Polynom([3,0,1,1,1], 7)
    p2 = Polynom([3,1,1], 7)
    self.assertEqual(QuotientRing(p1, 7).inverse(p2), Polynom([5,2,0,6], 7))

  def test_gcd(self):
    p1 = Polynom([1,1,1,1], 5)
    p2 = Polynom([4,0,1], 5)
    self.assertEqual(Algorithms.gcd(p1,p2), Polynom([2,2], 5))

    p1 = Polynom([3,0,1,1,1], 7)
    p2 = Polynom([3,1,1], 7)
    self.assertEqual(Algorithms.gcd(p1,p2), Polynom([1], 7))

class TestInterface(unittest.TestCase):
  def test_multiplication(self):
    p1 = Polynom([1,2,2,4], 5)
    p2 = Polynom([1,0,3], 5)
    ring = QuotientRing(Polynom([1,1], 5), 5)

if __name__ == '__main__':
  unittest.main()