require_relative 'polynom'
require_relative 'algorithms'
require_relative 'interface'

require 'io/console'

$gf = nil

def getp(str)
  printf "#{str}: "
  #pol = STDIN.gets.chomp.split(/ /).map(&:to_i).reverse
  pol = []
  gets.chomp.reverse.each_char do |c|
    pol << c.to_i
  end
  p = Polynom.new(pol,$gf)
  puts "=> (#{p.pp})"
  return p
end


while true do
printf "Калькулятор в Конечных Полях v1.0\n"
puts "-"*"Калькулятор в Конечных Полях v1.0\n".size
printf "Поле коэффициентов: "
$gf = gets.chomp.to_i
field = Field.new($gf)
generator = getp("Генератор поля")
ring = Algorithms::QuotientRing.new($gf, generator)
puts "=> Работаем с полем F(#{$gf})/(#{generator.pp})"
while true do
puts "="*"Калькулятор в Конечных Полях v1.0\n".size
  puts "Действия: i,m,d,mi,eq,euc,tab,varc"
  puts "(1)i - \t найти обратный элемент"
  puts "(2)s - \t выполнить Сложение полиномов"
  puts "(3)m - \t выполнить Умножение полиномов"
  puts "(4)d - \t выполнить Деление в кольце"
  puts "(5)deg - \t возвести в Степень"

  puts "(6)mi - \t найти Обратную Матрицу 4х4"
  puts "(7)eq - \t найти Решение Уравнения"
  puts "(8)euc - \t выполнить Евклидово деление с остатком"
  puts "(9)tab - \t построить Таблицу для элемента поля"
  puts "(10)varc - \t выполнить Подстановку полиномов"
  puts "Enter - \t повторить ввод параметров"
  puts "-------"
  printf "Выбор: "
  s = gets.chomp
puts "="*"Калькулятор в Конечных Полях v1.0\n".size


# gf = 5
# generator = [1,1,2].reverse

# # For inverse
# inv = [1,0,1].reverse

# # For multiplication
# m1 = [2,1].reverse
# m2 = [2,0,0,2,0].reverse

# # For division
# d1 = [2,0].reverse
# d2 = [4,4].reverse

# # Matrix inversion
# a11 = [2,2].reverse
# a12 = [1,2].reverse
# a21 = [1,1].reverse
# a22 = [1,0].reverse

# # For equasion
# mult = [1,1,0,0].reverse
# result = [3,4].reverse
# mod = [3,4,4,1].reverse

# # For Euclid division
# p1 = [1,0,1,0,0,1].reverse
# p2 = [1,0,1,1].reverse

# # For table in ring
# tab1 = [1,0].reverse

# # For varchange
# pol1 = [1,2,2].reverse
# varc = [2,1].reverse

# printf "Введите поле Галуа: "
# gf = gets.chomp.to_i

# printf "Введите образующий многочлен: "
# list = STDIN.gets.chomp.split(/ /).map(&:to_i)
# f = getp
# ring = Algorithms::QuotientRing.new(gf, f)
# field = Field.new(gf)
# printf "Кольцо вычетов F(#{gf})[x]/"
# f.pp
# printf "Выберите опцию: i,m,d,mi,eq,euc,tab,varc: "
# s = gets.chomp
if s == "i" || s == "1"
  # printf "Введите многочлен для обращения: "
  # inv = STDIN.gets.chomp.split(/ /).map(&:to_i)
  # printf "Введен многочлен "
  # pol.pp

  # pol = getp
  pol = getp("Полином")

  Interface.inversion(pol,ring)

  # printf "Обратный элемент для #{pol.pp}: "
  # inv = ring.inverse(pol)
  # puts inv.pp
  # printf "Проверка: (#{pol.pp})*(#{inv.pp}) = #{(pol*inv).pp} mod (#{f.pp}) = #{((pol*inv)%f).pp} ==? 1\n"
elsif s == "s" || s == "2"
  s1 = getp("Первое слагаемое")
  s2 = getp("Второе слагаемое")

  Interface.addition(s1,s2,ring)
elsif s == "m" || s == "3"
  while true do
    m1 = getp("Первый множитель(0 для выхода)")
    m2 = getp("Второй множитель")
    if m1 == m1.zero || m2 == m2.zero
      break
    end
    Interface.multiplication(m1,m2,ring)
  end
  # mult = m1*m2
  # printf "Умножение: (#{m1.pp})*(#{m2.pp}) = #{mult.pp} mod (#{f.pp}) = #{(mult%f).pp}\n"
elsif s == "d" || s == "4"
  while true do
    d1 = getp("Делимое")
    d2 = getp("Делитель(0 для выхода)")
    if d2 == d2.zero
      break
    end
    Interface.division(d1,d2,ring)
  end

  # div = ring.divide(d1,d2)
  # printf "(#{d1.pp})/(#{d2.pp}) = #{div.pp}\n"
  # printf "Проверка: (#{div.pp})*(#{d2.pp}) = #{(div*d2).pp} mod (#{f.pp}) = #{((div*d2)%f).pp} ==? #{d1.pp}\n"
elsif s == "deg" || s == "5"
  pol = getp("Полином")
  while true
    printf "Степень: "
    deg = gets.chomp.to_i
    if deg == 0
      break
    end
    Interface.degree(pol,deg,ring)
  end
elsif s == "mi" || s == "6"

  # b11 = a11.clone
  # b12 = a12.clone
  # b21 = a21.clone
  # b22 = a22.clone

  a11 = getp("а11")
  a12 = getp("а12")
  a21 = getp("а21")
  a22 = getp("а22")

  Interface.matrix_inversion(a11,a12,a21,a22,ring)

  # b11 = getp
  # b22 = getp
  # b12 = getp
  # b21 = getp

  # printf "Матрица А:\n"
  # printf "#{a11.pp}\t#{a12.pp}\n"
  # printf "#{a21.pp}\t#{a22.pp}\n"

  # c11 = a22
  # c22 = a11
  # c12 = a21*(-1)
  # c21 = a12*(-1)

  # tmp = c12
  # c12 = c21
  # c21 = tmp

  # discr = a11*a22 - a12*a21

  # c11 = ring.divide(c11, discr)
  # c12 = ring.divide(c12, discr)
  # c21 = ring.divide(c21, discr)
  # c22 = ring.divide(c22, discr)

  # printf "Обратная матрица: \n"
  # printf "#{c11.pp}\t#{c12.pp}\n"
  # printf "#{c21.pp}\t#{c22.pp}\n"

  # puts "Проверка:"
  # printf "#{((b11*c11+b12*c21)%f).pp}\t#{((b11*c12+b12*c22)%f).pp}\n"
  # printf "#{((b21*c11+b22*c21)%f).pp}\t#{((b21*c12+b22*c22)%f).pp}\n"
elsif s == "eq" || s == "7"
  mod = getp("mod")
  mult = getp("mult")
  result = getp("result")

  Interface.equasion_solve(mod,mult,result)

  # printf "НОД:\n"
  # puts mod.pp
  # puts mult.pp
  # puts "......"
  # e = Algorithms::euclid(mod,mult)
  # puts e[3].pp
  # puts e[2].pp
  # x = e[0]
  # y = e[1]
  # puts "x: #{x.pp}"
  # puts "y: #{y.pp}"
  # puts "-------"
  # ans = y * field.inverse(e[2].to_i) * result
  # ans = ans % mod
  # puts "Ответ: #{ans.pp} = y * last^(-1) * 2x % mod"
  # puts "Проверка: (#{mult.pp})*(#{ans.pp}) = #{((mult*ans)%mod).pp} ==? #{result.pp}"
elsif s == "euc" || s == "8"
  p1 = getp("p1")
  while true do
    p2 = getp("p2(0 для выхода)")
    if p2 == p2.zero
      break
    end
    Interface.euclid_division(p1,p2,field)
  end

  # r = p1 % p2
  # d = p1 / p2

  # printf "Деление с остатком в поле F(#{gf}):\n\n"

  # s1 = "#{p1.pp}"
  # s2 = "#{p2.pp}"
  # s3 = "#{r.pp}"
  # s4 = "#{d.pp}"

  # printf "#{s1} | #{s2}\n"
  # printf "#{"-"*s1.size}-|-#{"-"*s2.size}\n"
  # printf "#{" "*(s1.size - s3.size)}#{s3} | #{s4}\n"

  # printf "Проверка:\n"
  # printf "(#{s2})*(#{s4}) + #{s3} = #{(p2*d+r).pp} ==? #{s1}\n"
elsif s == "tab" || s == "9"
#   init = tab1.clone
  while true do
    tab1 = getp("Генератор(0 для завершения)")
    if tab1 == tab1.zero
      break
    end
    Interface.table_primitive(tab1,ring)
  end

  # init = getp

#   printf "Степень #{init.pp}\t| #{f.pp} = 0\n"
#   puts "-"*"Степень #{init.pp}\t| #{f.pp} = 0\n".size
#   (1..gf**f.degree).each do |i|
#     printf "(#{init.pp})^#{i}\t| \t#{tab1.pp}\n"
#     tab1 = (tab1*init)%f
#     if tab1 == tab1.one
#       printf "(#{init.pp})^#{i+1}\t| \t#{tab1.pp}\n"
#       break
#     end
#   end
elsif s == "varc" || s == "10"
  pol1 = getp("Полином")
  varc = getp("Замена")

  Interface.variable_replace(pol1, varc, ring)

  # printf "(#{varc.pp}) ==> (#{pol1.pp}) :\n"
  # printf " == (#{(pol1.varchange(varc)).pp}) mod (#{f.pp}) = #{(pol1%f).pp}\n"
else
  break
end
end
end
