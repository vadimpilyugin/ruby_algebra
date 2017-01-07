require_relative 'polynom'
require_relative 'algorithms'

# def Interface.clone(list)
#   newlist = []
#   list.each do |elem|
#   	newlist << elem
#   end
#   printf "#{newlist}\n"
#   return newlist
# end
module Interface
  def Interface.degree(pol, deg, ring)
  	printf "=> (#{((pol**deg)%ring.f).pp})\n"
  	printf "(#{pol.pp})^#{deg} = #{(pol**deg).pp} mod (#{ring.f.pp}) = #{((pol**deg)%ring.f).pp}\n"
  end
  def Interface.inversion(pol, ring)
    printf "Обратный элемент для #{pol.pp}: "
    inv = ring.inverse(pol)
    puts inv.pp
  
    printf "Проверка: (#{pol.pp})*(#{inv.pp}) = #{(pol*inv).pp} mod (#{ring.f.pp}) = #{((pol*inv)%ring.f).pp} ==? 1\n"
  end
  
  def Interface.multiplication(m1, m2, ring)
    mult = m1*m2
  
    printf "Умножение: (#{m1.pp})*(#{m2.pp}) = #{mult.pp} mod (#{ring.f.pp}) = #{(mult%ring.f).pp}\n"
  end  
  def Interface.addition(m1, m2, ring)
    mult = m1+m2
  
    printf "Сложение: (#{m1.pp})+(#{m2.pp}) = #{mult.pp} mod (#{ring.f.pp}) = #{(mult%ring.f).pp}\n"
  end
  
  def Interface.division(d1, d2, ring)
    div = ring.divide(d1,d2)
  
    printf "(#{d1.pp})/(#{d2.pp}) = #{div.pp}\n"
    printf "Проверка: (#{div.pp})*(#{d2.pp}) = #{(div*d2).pp} mod (#{ring.f.pp}) = #{((div*d2)%ring.f).pp} ==? #{d1.pp}\n"
  end
  
  def Interface.matrix_inversion(a11, a12, a21, a22, ring)
  
    b11 = a11.clone
    b12 = a12.clone
    b21 = a21.clone
    b22 = a22.clone
  
  assert(b11.hash != a11.hash, "Same object!")
  assert(!a11.coeffs.equal?(b11.coeffs), "Same coefficients!")
  assert(b11.class != nil.class, "Is a nil!")
  
    printf "Матрица А:\n"
    printf "#{a11.pp}\t#{a12.pp}\n"
    printf "#{a21.pp}\t#{a22.pp}\n"
  
    c11 = a22
    c22 = a11
    c12 = a21*(-1)
    c21 = a12*(-1)
  
    tmp = c12
    c12 = c21
    c21 = tmp
  
    discr = a11*a22 - a12*a21
  
  
    c11 = ring.divide(c11, discr)
    c12 = ring.divide(c12, discr)
    c21 = ring.divide(c21, discr)
    c22 = ring.divide(c22, discr)
  
    printf "Обратная матрица: \n"
    printf "#{c11.pp}\t#{c12.pp}\n"
    printf "#{c21.pp}\t#{c22.pp}\n"
  
    puts "Проверка:"
    printf "#{((b11*c11+b12*c21)%ring.f).pp}\t#{((b11*c12+b12*c22)%ring.f).pp}\n"
    printf "#{((b21*c11+b22*c21)%ring.f).pp}\t#{((b21*c12+b22*c22)%ring.f).pp}\n"
  end
  
  def Interface.equasion_solve(mod, mult, result)
    printf "НОД:\n"
    puts mod.pp
    puts mult.pp
    puts "......"
    e = Algorithms::euclid(mod,mult)
    puts e[3].pp
    puts e[2].pp
    x = e[0]
    y = e[1]
    puts "x: #{x.pp}"
    puts "y: #{y.pp}"
    puts "-------"
    ans = y * mod.field.inverse(e[2].to_i) * result
    ans = ans % mod
    puts "Ответ: #{ans.pp} = y * обратный к последнему в лесенке * правая часть % mod"
    puts "Проверка: (#{mult.pp})*(#{ans.pp}) = #{((mult*ans)%mod).pp} ==? #{result.pp}"
  end
  
  def Interface.euclid_division(p1, p2, field)
    r = p1 % p2
    d = p1 / p2
  
    printf "Деление с остатком в поле F(#{field.maxval}):\n\n"
  
    s1 = "#{p1.pp}"
    s2 = "#{p2.pp}"
    s3 = "#{r.pp}"
    s4 = "#{d.pp}"
  
    printf "#{s1} | #{s2}\n"
    printf "#{"-"*s1.size}-|-#{"-"*s2.size}\n"
    printf "#{" "*(s1.size - s3.size)}#{s3} | #{s4}\n"
  
    printf "Проверка:\n"
    printf "(#{s2})*(#{s4}) + #{s3} = #{(p2*d+r).pp} ==? #{s1}\n"
  end
  
  def Interface.table_primitive(pol, ring)
    init = pol.clone
  
    printf "Степень #{init.pp}\t| #{ring.f.pp} = 0\n"
    puts "-"*"Степень #{init.pp}\t| #{ring.f.pp} = 0\n".size
    (1..pol.field.maxval**ring.f.degree).each do |i|
      printf "(#{init.pp})^#{i}\t| \t#{pol.pp}\n"
      pol = (pol*init)%ring.f
      if pol == pol.one
        printf "(#{init.pp})^#{i+1}\t| \t#{pol.pp}\n"
        break
      end
    end
  end
  
  def Interface.variable_replace(pol, varc, ring)
  	result = pol.varchange(varc)

    printf "(#{varc.pp}) ==> (#{pol.pp}) :\n"
    printf " == (#{(pol.varchange(varc)).pp}) mod (#{ring.f.pp}) = #{(result%ring.f).pp}\n"
  end
end