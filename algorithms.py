from excp import *
from printer import *
from polynomial import Field
from polynomial import Polynom

class QuotientRing:
  def __init__(self, ring_modulus, field_modulus):
    self.gf = Field(field_modulus)
    self.ring_modulus = ring_modulus

  def inverse(self, pol):
    e = Algorithms.euclidian_algorithm(self.ring_modulus, pol)
    return e[1] * Polynom([self.gf.inverse(int(e[2]))], self.gf.modulus)

  def divide(self, p, q):
    return (self.inverse(q)*p) % self.ring_modulus

class Algorithms:

  @staticmethod
  def euclidian_algorithm(p1, p2):
    x = [p1.one(), p1.zero()]
    y = [p1.zero(), p1.one()]
    while p2.degree() > 0:
      d, p3 = p1 / p2
      x.append(x[-2] - d * x[-1])
      y.append(y[-2] - d * y[-1])
      p1,p2 = p2,p3
    return (x[-1], y[-1], p3, p1)

  @staticmethod
  def gcd(p1, p2):
    e = Algorithms.euclidian_algorithm(p1, p2)
    if int(e[2]) == 0:
      return e[3]
    else:
      return p1.one()