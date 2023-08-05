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
  true
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
  answer = matchmaker(companies, candidates)
  spy: answer end
  true
where:
  oracle(matchmaker) is true
end