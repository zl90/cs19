# CSCI0190 (Fall 2018)
provide *
provide-types *

import shared-gdrive("oracle-support.arr",
  "11JjbUnU58ZJCXSphUEyIODD1YaDLAPLm") as O

##### PUT IMPORTS BELOW HERE ############


##### PUT IMPORTS ABOVE HERE ############

type Hire = O.Hire
hire = O.hire
is-hire = O.is-hire
matchmaker = O.matchmaker

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

fun generate-preference(num :: Number, acc :: List<Number>) -> List<Number>:
  doc: 
  ```
  generates a list of preferences of size num
  ```
  if acc.length() == num:
    acc
  else:
    random-number = num-random(num)
    if not(acc.member(random-number)):
      generate-preference(num, acc + [list: random-number])
    else:
      generate-preference(num, acc)
    end
  end
end

fun generate-input(num :: Number) -> List<List<Number>>:
  doc: 
  ```
  generates a list of candidates or companies for a group of size num
  ```
  if num == 0:
    empty
  else:
    iterator = range(0, num)
    result = iterator.map(lam(x): generate-preference(num, empty) end)

    result
  end
where:
  generate-input(0) is empty
end

fun is-correct-lengths(
    companies :: List<List<Number>>,
    candidates :: List<List<Number>>,
    hires :: Set<Hire>)
  -> Boolean:
doc: 'Returns true if all input lists have the same length'
  (companies.length() == candidates.length()) and (companies.length() == hires.to-list().length())
where:
  is-correct-lengths([list: [list: 2, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)]) is true
end

fun is-valid(
    companies :: List<List<Number>>,
    candidates :: List<List<Number>>,
    hires :: Set<Hire>)
  -> Boolean:
  doc: 
  ```
  Tells if the set of hires is a good match for the given
  company and candidate preferences.
  ```
  
  is-correct-lengths(companies, candidates, hires)
where:
  is-valid(empty, empty, empty-set) is true
end

fun oracle(a-matchmaker :: (List<List<Number>>, List<List<Number>> 
      -> Set<Hire>))
  -> Boolean:
  doc: 
  ```
  Takes a purported matchmaking algorithm as input and outputs whether or
  not it always returns the correct response
  ```
  companies = generate-input(5)
  candidates = generate-input(5)
  spy: companies end
  spy: candidates end
  solution = a-matchmaker(companies, candidates)
  spy: solution end
  true
where:
  oracle(matchmaker) is true
end