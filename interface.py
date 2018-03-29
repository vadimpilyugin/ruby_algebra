from polynomial import Polynom
from polynomial import Field
from algorithms import QuotientRing
from algorithms import Algorithms
from excp import *
from printer import *

class Interface:

  @staticmethod
  def exponentiate(pol, exponent, ring):
    pol_pow = pol ** exponent
    pol_pow_mod = pol_pow % ring.ring_modulus
    print(f"=> ({pol_pow_mod})")
    print(f"({pol}^{exponent} = {pol_pow} mod ({ring.ring_modulus}) = {pol_pow_mod}")

  @staticmethod
  def inversion(pol, ring):
    inv = ring.inverse(pol)
    mult = pol*inv
    mod = mult % ring.ring_modulus
    print(f"Обратный элемент для ({pol}): ({inv})")
    print(f"Проверка: ({pol})*({inv}) = ({mult}) mod ({ring.ring_modulus}) = {mod} ==? 1")

  @staticmethod
  def multiplication(m1, m2, ring):
    mult = m1*m2
    mod = mult % ring.ring_modulus
    print(f"({m1})*({m2}) = ({mod})")
    print(f"Проверка: ({m1})*({m2}) = ({mult}) mod ({ring.ring_modulus}) = {mod}")

  @staticmethod
  def addition(m1, m2, ring):
    add = m1 + m2
    mod = add % ring.ring_modulus

    print(f"=> ({mod})")
    print(f"Проверка: ({m1})+({m2}) = ({add}) mod ({ring.ring_modulus}) = {mod}")

  @staticmethod
  def division(m1, m2, ring):
    div = ring.divide(d1,d2)
    mult = div * d2
    mod = mult % ring.ring_modulus

    print(f"=> ({div})")
    print(f"Проверка: ({div})*({d2}) = {mult} mod ({ring.ring_modulus}) = {mod} ==? {m1}")

  @staticmethod
  def matrix_inversion(a11, a12, a21, a22, ring):

    print("Матрица A:")
    print(f"{a11}\t{a12}\n{a21}\t{a22}\n")

    # Cofactor matrix
    c11 = a22
    c22 = a11
    c12 = -a21
    c21 = -a12

    # Adjugate matrix
    c12, c21 = c21, c12

    print("Транспонированная матрица алгебраических дополнений:")
    print(f"{c11}\t{c12}\n{c21}\t{c22}\n")

    # Determinant
    det = a11*a22 - a12*a21

    print(f"Ее определитель: {det}\n")

    c11 = ring.divide(c11, det)
    c12 = ring.divide(c12, det)
    c21 = ring.divide(c21, det)
    c22 = ring.divide(c22, det)

    print("Обратная матрица:")
    print(f"{c11}\t{c12}\n{c21}\t{c22}\n")

    print("Проверка")
    print(f"{(a11*c11+a12*c21)%ring.ring_modulus}  {(a11*c12+a12*c22)%ring.ring_modulus} = 1  0")
    print(f"{(a21*c11+a22*c21)%ring.ring_modulus}  {(a21*c12+a22*c22)%ring.ring_modulus}   0  1")

  @staticmethod
  def equasion_solve(mod, mult, result):
    print("Лесенка НОД:")
    print(mod)
    print(mult)
    print("...")
    e = Algorithms.euclidian_algorithm(mod,mult)
    print(e[3])
    print(e[2])
    x = e[0]
    y = e[1]
    print("-------")
    print(f"x: {x}\ny: {y}")
    print("-------")
    ans = (y * Polynom([mod.gf.inverse(int(e[2]))], mod.gf.modulus) * result) % mod
    print(f"Ответ: {ans} == (y * обратный к последнему в лесенке * правая часть) % mod")
    print(f"Проверка: ({mult})*({ans}) = ({mult*ans}) mod ({mod}) = {(mult*ans)%mod} ==? {result}")

  @staticmethod
  def euclid_division(p1, p2, field):
    r = p1 % p2
    d = p1 // p2

    print(f"Деление с остатком в поле {field}:\n\n")

    s1 = p1.__repr__()
    s2 = p2.__repr__()
    s3 = r.__repr__()
    s4 = d.__repr__()
  
    print(f"{s1} | {s2}")
    print("-"*len(s1)+"-|-"+"-"*len(s2))
    print(" "*abs(len(s1) - len(s3))+f"{s3} | {s4}")
    print("-"*(len(s1)+len(s2)+3))

    print(f"Проверка: ({s2})*({s4}) + {s3} = {p2*d+r} ==? {s1}")

  @staticmethod
  def table_primitive(pol, ring):
    init = pol.clone()

    s = f"Степень {init}\t| {ring.ring_modulus} = 0"
    print(s)
    print("-"*len(s))
    for i in range(1, pol.gf.modulus**ring.ring_modulus.degree()):
      if len(init.__repr__()) == 1:
        print(f"{init}^{i}\t| \t{pol}")
      else:
        print(f"({init})^{i}\t| \t{pol}")
      if pol == pol.one():
        break
      pol = (pol*init)%ring.ring_modulus

  @staticmethod
  def variable_substitution(pol, varc, ring):
    result = pol.substitute(varc)
    print(f"({varc}) ~~> ({pol}): ")
    print(f" == ({result}) mod ({ring.ring_modulus}) = {result%ring.ring_modulus}")

if __name__ == "__main__":
  gf = Field(2)
  ring = QuotientRing(Polynom([1,1,0,0,1], gf.modulus), gf.modulus)
  primitive_root = Polynom([0,1], gf.modulus)
  Interface.table_primitive(primitive_root, ring)

  print(f"\n{'':=^80s}\n")

  gf = Field(2)
  p = Polynom([1,0,0,1,0,0,0,0,0,1], gf.modulus)
  q = Polynom([1,1,1], gf.modulus)
  Interface.euclid_division(p,q,gf)

  print(f"\n{'':=^80s}\n")

  gf = Field(2)
  p = Polynom([1,1,1], gf.modulus)
  ring = QuotientRing(Polynom([1,1,0,0,1], gf.modulus), gf.modulus)
  Interface.inversion(p, ring)

  print(f"\n{'':=^80s}\n")

  gf = Field(2)
  m1 = Polynom([1,1], gf.modulus)
  m2 = Polynom([0,1,0,1], gf.modulus)
  ring = QuotientRing(Polynom([1,1,0,0,1], gf.modulus), gf.modulus)
  Interface.multiplication(m1, m2, ring)

  print(f"\n{'':=^80s}\n")

  gf = Field(5)
  ring = QuotientRing(Polynom([3,2,1], gf.modulus), gf.modulus)
  a11 = Polynom([3,2], gf.modulus)
  a12 = Polynom([1,1], gf.modulus)
  a21 = Polynom([1,1], gf.modulus)
  a22 = Polynom([2,1], gf.modulus)
  Interface.matrix_inversion(a11, a12, a21, a22, ring)

  print(f"\n{'':=^80s}\n")

  gf = Field(5)
  ring = QuotientRing(Polynom([3,2,1], gf.modulus), gf.modulus)
  mod = Polynom([4,3,3,4], gf.modulus)
  mult = Polynom([3,4,0,3], gf.modulus)
  result = Polynom([4,3], gf.modulus)
  Interface.equasion_solve(mod, mult, result)