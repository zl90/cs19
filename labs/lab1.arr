### Lab 3: Higher order functions

# Write a function to convert a list of fahrenheit temperatures into a list of celcius temperatures:
fun f-to-c(fahr :: List<Number>) -> List<Number>:
  doc: ``` Takes a list of degrees in fahrenheit and returns
       a new list with the degrees converted to celcius ```
  cases(List) fahr:
    | empty => empty
    | link(first, rest) => link((5/9) * (first - 32), f-to-c(rest))
  end
where:
  f-to-c([list: ]) is [list: ]
  f-to-c([list: 131, 77, 68]) is [list: 55, 25, 20]
end

# Write a function that reports whether a temperature in fahrenheit is "too hot", "just right" or "too cold":
fun goldilocks(fahr :: List<Number>) -> List<String>:
  doc: ``` Takes a list of numbers representing degrees in
       fahrenheit, returns a new list of descriptions for
       each number in the original list. Above 90 degrees
       is "too hot", below 70 degrees is "too cold" and
       anything in between is "just right". ```
  cases(List) fahr:
    | empty => empty
    | link(first, rest) =>
      if first > 90:
        link('too hot', goldilocks(rest))
      else if first < 70:
        link('too cold', goldilocks(rest))
      else:
        link('just right', goldilocks(rest))
      end
  end
where:
  goldilocks([list: ]) is [list: ]
  goldilocks([list: 131, 77, 68]) is
[list: "too hot", "just right", "too cold"]
end

# Implement goldilocks with map:
fun check-temp(temp :: Number) -> String:
  if temp > 90:
    'too hot'
  else if temp < 70:
    'too cold'
      else:
    'just right'
  end 
end

fun goldilocks-map(fahr :: List<Number>) -> List<String>:
doc: ``` Takes a list of numbers representing degrees in
       fahrenheit, returns a new list of descriptions for
       each number in the original list. Above 90 degrees
       is "too hot", below 70 degrees is "too cold" and
       anything in between is "just right". ```
  map(check-temp, fahr)
where:
  goldilocks-map([list: ]) is [list: ]
  goldilocks-map([list: 131, 77, 68]) is
[list: "too hot", "just right", "too cold"]
end

# Now, to prove your understanding of the map function, write your own implementation of it:
fun my-map<T, K>(functor :: (T -> K), l :: List<T>) -> List<K>:
  cases(List) l:
    | empty => empty
    | link(first, rest) => link(functor(first), my-map(functor, rest))
  end
where:
  my-map(num-tostring, [list: 1, 2]) is [list: "1", "2"]
  my-map(lam(x): x + 1 end, [list: 1, 2]) is [list: 2, 3]
end