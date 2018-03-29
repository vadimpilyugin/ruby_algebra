import itertools
from functools import reduce
from excp import *
from printer import *

class Field:
  def __init__(self, modulus):
    self.modulus = modulus

  def __repr__(self):
    return f"GF({self.modulus})"

  def __eq__(self, other):
    return self.modulus == other.modulus

  def truncate(self, n):
    return n % self.modulus

  def inverse(self, n):
    if n > self.modulus:
      printer.warning(f"{n} is not in the field {self}")
    n = self.truncate(n)
    for i in range(1,self.modulus):
      if self.truncate(n * i) == 1:
        return i
    printer.debug(f"Inverse for {n} is not found in the field {self}")
    return None

  def divide(self, p, q):
    return self.truncate(self.inverse(q)*p)

  def mult(self, a, b):
    return self.truncate(a*b)

class Polynom:
  def __init__(self, coeffs, modulus):
    self.coeffs = coeffs
    self.gf = Field(modulus)

  def zero(self):
    return Polynom([0], self.gf.modulus)   

  def one(self):
    return Polynom([1], self.gf.modulus)

  def truncate(self):
    self.coeffs = list(map(lambda coeff: self.gf.truncate(coeff), self.coeffs))
    return self

  def __add_lists_iter(self, list1, list2):
    for a,b in itertools.zip_longest(list1, list2, fillvalue=0):
      yield(self.gf.truncate(a+b))

  def __add_lists(self, list1, list2):
    return list(self.__add_lists_iter(list1, list2))

  def __add__(self, other):
    if self.gf != other.gf:
      printer.error(f"Cannot add polynomials: different fields {self.gf} and {other.gf}")
      raise DifferentFieldsException()

    return Polynom(self.__add_lists(self.coeffs, other.coeffs), self.gf.modulus)

  # stores sum into self
  def plus(self, other):
    if self.gf != other.gf:
      printer.error(f"Cannot add polynomials: different fields {self.gf} and {other.gf}")
      raise DifferentFieldsException()

    if len(self.coeffs) != len(other.coeffs):
      self.coeffs = self.__add_lists(self.coeffs, other.coeffs)
    else:
      for i,coeff in enumerate(self.__add_lists_iter(self.coeffs, other.coeffs)):
        self.coeffs[i] = coeff
    return self

  def __neg__(self):
    p = Polynom(list(self.coeffs), self.gf.modulus)
    for i in range(0, len(p.coeffs)):
      p.coeffs[i] = -p.coeffs[i]
    p.truncate()
    return p

  def __sub__(self, other):
    if self.gf != other.gf:
      printer.error(f"Cannot subtract polynomials: different fields {self.gf} and {other.gf}")
      raise DifferentFieldsException()

    printer.debug(f"subtracting {other} from {self}")
    printer.debug(f" ==> adding {self} to {-other}")
    return self + (-other)

  def __pow__(self, exponent):
    if exponent > self.gf.modulus:
      printer.error("exponent is greater than the modulus")
      raise InvalidElementException()
    ans = self.one()
    for i in range(0,exponent):
      ans = ans * self
    return ans

  def scale(self, factor):
    return Polynom(
      list(
        map(
          lambda coeff: self.gf.truncate(coeff*factor), 
          self.coeffs
        )
      ), 
      self.gf.modulus
    )

  # Multiplies the polynomial by x^n in-place
  def shift(self, n):
    self.coeffs = [0]*n+self.coeffs
    return self

  def __mul__(self, other):
    result = self.zero()
    for i, coeff in enumerate(self.coeffs):
      result.plus(other.scale(coeff).shift(i))
    return result

  def truncate_zeroes(self):
    if len(self.coeffs) == 0:
      printer.note("Truncating empty polynomial")

    last_pop = 0
    while(self.coeffs and last_pop == 0):
      last_pop = self.coeffs.pop()
    self.coeffs.append(last_pop)
    return self

  def degree(self):
    self.truncate_zeroes()
    return len(self.coeffs)-1

  def substitute(self, other):
    if self.gf != other.gf:
      printer.error(f"Cannot substitute polynomials: different fields {self.gf} and {other.gf}")
      raise DifferentFieldsException()

    result = self.zero()
    for i, coeff in enumerate(self.coeffs):
      term = (other**i)*coef
      result.plus(term)
    return result

  def __eq__(self, other):
    self.truncate_zeroes()
    other.truncate_zeroes()
    return self.gf.modulus == other.gf.modulus and self.coeffs == other.coeffs

  def __truediv__(self, other):
    p1 = self.truncate_zeroes()
    p2 = other.truncate_zeroes()
    p3 = self.zero()
    zero = self.zero()

    while p1.degree() >= p2.degree() and p1 != zero:
      div = Polynom(
        [self.gf.divide(p1.coeffs[-1],p2.coeffs[-1])],
        self.gf.modulus
      ).shift(p1.degree() - p2.degree())
      mult = p2 * div
      sub = p1 - mult
      p1 = sub
      p3.plus(div)

    return (p3,p1)

  def __floordiv__(self,other):
    return (self/other)[0]

  def __mod__(self,other):
    return (self/other)[1]

  def __repr__(self):
    self.truncate_zeroes()
    simplify_coeff = lambda coeff: "" if abs(coeff) == 1 else str(abs(coeff))
    terms = []

    for i, coeff in enumerate(self.coeffs):
      if abs(coeff) > 0:
        if i == 0:
          term = str(abs(coeff))
        elif i == 1:
          term = simplify_coeff(coeff) + "x"
        else:
          term = simplify_coeff(coeff) + f"x^{i}"
        term = (" + " if coeff >= 0 else " - ") + term
        terms.append(term)
    if terms:
      terms = list(reversed(terms))
      # remove sign
      if terms[0][0:3] == " + ":
        terms[0] = terms[0][3:]
      else:
        terms[0] = "-"+terms[0][3:]
      return reduce(lambda accum, x: accum + x, terms)
    else:
      return "0"

  def __int__(self):
    if self.degree() > 0:
      printer.error("degree is not zero, so can't convert to int")
      raise InvalidElementException()

    return self.coeffs[0]

  def clone(self):
    return Polynom(list(self.coeffs), self.gf.modulus)

if __name__ == "__main__":
  gf = Field(23)
  for i in range(0,gf.modulus):
    print(i, gf.inverse(i))
  printer.debug("Finished!")