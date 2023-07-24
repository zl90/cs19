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

## Filter
# Implement the function `tl-dr` using filter:
fun tl-dr<T>(lol :: List<List<T>>, length-thresh :: Number) -> List<List<T>>:
  doc: 'Eliminates all lists in `lol` whose lengths are greater than `length-thresh'
  predicate = lam(x): length(x) <= length-thresh end
  filter(predicate, lol)
where:
  tl-dr<Number>([list: [list: 1, 1, 1], [list: 2]], 2) is [list: [list: 2]]
  tl-dr<Number>([list: ], 0) is [list: ]
end

# Implement the function `eliminate-e` using filter.
# Restriction: no using string builtin functions other than `string-to-code-points`:
fun contains-letter(word :: String, letter :: String) -> Boolean:
doc: 'Returns true if the `word` contains the `letter`, false if it doesnt'
  chars = string-to-code-points(word)
  char = string-to-code-point(letter)
  predicate = lam(x): x == char end
  result = filter(predicate, chars)
  length(result) > 0
where:
  contains-letter('Teeth', 'e') is true
  contains-letter('Tooth', 'e') is false
end

fun eliminate-e(words :: List<String>) -> List<String>:
  doc: 'Eliminates all strings from `words` that contain the letter e'
  predicate = lam(x): not(contains-letter(x, 'e'))  end
  filter(predicate, words)
where:
  eliminate-e([list: 'eee', 'a', 'b']) is [list: 'a', 'b']
  eliminate-e([list: 'eee', 'a', 'b', 'tee']) is [list: 'a', 'b']
  eliminate-e([list: 'eee']) is [list: ]
  eliminate-e([list: ]) is [list: ]
end

# Write your own implementation of the filter function:
fun my-filter<K>(predicate :: (K -> Boolean), l :: List<K>) -> List<K>:
  cases(List) l:
    | empty => empty
    | link(first, rest) =>
      if predicate(first):
        link(first, my-filter(predicate, rest))
      else:
        my-filter(predicate, rest)
      end
  end
where:
  my-filter(lam(x): x > 5 end, [list: 1, 1, 2, 6, 2]) is [list: 6]
  my-filter(lam(x): x > 5 end, [list: 1, 1, 2, 6, 2, 8, 0, 8]) is [list: 6, 8, 8]
  my-filter(lam(x): x > 5 end, [list: 1, 1, 2, 5, 2]) is [list: ]
  my-filter(lam(x): x > 5 end, [list: ]) is [list: ]
end

## Fold (Reduce)
# Write your own implementation of the fold function:
fun my-fold<T, K>(folder :: (K, T -> K), base :: K, lst :: List<T>) -> K:
  cases(List) lst:
    | empty => base
    | link(first, rest) => my-fold(folder, folder(base, first), rest)
  end
      where:
  my-fold(lam(acc, curr): acc + curr end, 0, [list: 1, 2, 3, 4, 5]) is 15
end

## Map2
# Write your own implementation of the map2 function:
fun my-map2<A, B, C>(functor :: (A, B -> C), lst1 :: List<A>, lst2 :: List<B>) -> List<C>:
  if not(length(lst1) == length(lst2)):
    raise("Error: lst1 and lst2 have different lengths")
  else:
    cases(List) lst1:
      | empty => empty
      | link(first1, rest1) =>
        cases (List) lst2:
          | empty => empty
          | link(first2, rest2) =>
            link(functor(first1, first2), my-map(functor, rest1, rest2))
        end
    end
  end
  where:
  noun-list = [list: "kitten", "puppy", "student"]
adj-list = [list: "fluffy", "ugly", "smart"]
map2(lam(n, a): a + " " + n end, noun-list, adj-list)
is [list: "fluffy kitten", "ugly puppy", "smart student"]
end

## Creating your own: Maximizing Revenue
# Write a higher-order function, best-price, which takes in a demand function and a list of potential prices and computes the optimal price, the price that will yield the greatest revenue
fun best-price(demand-func :: (Number, Number -> Number), prices :: List<Number>, best :: Number) -> Number:
  cases(List) prices:
    | empty => best
    | link(first, rest) =>
      if demand-func(first) >= demand-func(best):
        best-price(demand-func, rest, first)
      else:
        best-price(demand-func, rest, best)
      end
  end
where:
  best-price(lam(x): x * (100 - (30 * x)) end, [list: 1, 2, 3], 1) is 2
end