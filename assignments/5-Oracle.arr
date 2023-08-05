# CSCI0190 (Fall 2018)
provide *
provide-types *

import shared-gdrive("oracle-support.arr",
  "11JjbUnU58ZJCXSphUEyIODD1YaDLAPLm") as O

##### PUT IMPORTS BELOW HERE ############
import lists as L
import equality as EQ
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
  is-correct-lengths([list: [list: 2, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)]) is false
  is-correct-lengths([list: [list: 2, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(4, 2), hire(4, 2), hire(2, 3), hire(1,4), hire(0, 0)]) is false
end

fun is-values-in-correct-range(
    companies :: List<List<Number>>,
    candidates :: List<List<Number>>,
    hires :: Set<Hire>)
  -> Boolean:
  doc: 'Returns true if all values are within the range of 0 - (n-1), where n represents the lengths of the lists'
  n = companies.length()
  is-companies-valid = fold(lam(acc, item):
      if not(fold(lam(acc2, element):
        if (element < 0) or (element >= n):
            false
        else:
            acc2
        end
            end, true, item)):
        false
      else:
        acc
      end
    end, true, companies)
  is-candidates-valid = fold(lam(acc, item):
      if not(fold(lam(acc2, element):
        if (element < 0) or (element >= n):
            false
        else:
            acc2
        end
            end, true, item)):
        false
      else:
        acc
      end
    end, true, candidates)
  is-hires-valid = fold(lam(acc, item): 
      if (item.company < 0) or (item.company >= n) or (item.candidate < 0) or (item.candidate >= n): 
        false
      else:
        acc
      end
    end, true, hires.to-list())
  
  is-companies-valid and is-candidates-valid and is-hires-valid
where:
  is-values-in-correct-range([list: [list: 2, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)]) is true
  is-values-in-correct-range([list: [list: -1, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)]) is false
  is-values-in-correct-range([list: [list: 8, 3, 0, 4, 1], [list: 0, 3, 2, 4, 1], [list: 3, 1, 2, 0, 4], [list: 0, 1, 2, 4, 3], [list: 2, 0, 4, 3, 1]], [list: [list: 0, 2, 4, 1, 3], [list: 4, 2, 0, 3, 1], [list: 4, 0, 3, 2, 1], [list: 3, 4, 2, 0, 1], [list: 3, 1, 2, 4, 0]], [list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)]) is false
end

fun contains(l :: List<Hire>, item :: Hire) -> Boolean:
  cases (List) l:
    | empty => false
    | link(f, r) =>
      if (item.company == f.company) and (item.candidate == f.candidate):
        true
      else:
        contains(r, item)
      end
  end
where:
  contains([list-set: hire(4, 2), hire(4, 2), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), hire(4, 2)) is true
  contains([list-set: hire(4, 2), hire(4, 2), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), hire(4, 7)) is false
end

fun company-contains(l :: List<Hire>, item :: Number) -> Boolean:
  cases (List) l:
    | empty => false
    | link(f, r) =>
      if (item == f.company):
        true
      else:
        company-contains(r, item)
      end
  end
where:
  company-contains([list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1, 4), hire(0, 0)].to-list(), 4) is true
  company-contains([list-set: hire(3, 1), hire(2, 3), hire(1, 4), hire(0, 0)].to-list(), 4) is false
end

fun candidate-contains(l :: List<Hire>, item :: Number) -> Boolean:
  cases (List) l:
    | empty => false
    | link(f, r) =>
      if (item == f.candidate):
        true
      else:
        candidate-contains(r, item)
      end
  end
where:
  candidate-contains([list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1, 4), hire(0, 0)].to-list(), 4) is true
  candidate-contains([list-set: hire(3, 1), hire(2, 3), hire(1, 4), hire(0, 0)].to-list(), 2) is false
end

fun is-duplicate-hires(hires :: List<Hire>, acc :: Boolean) -> Boolean:
  doc: 'Returns true if there are duplicate hires in the input list, or if there are duplicate companies/candidates'
  cases (List) hires:
    | empty => acc
    | link(f, r) =>
      if contains(r, f) or company-contains(r, f.company) or candidate-contains(r, f.candidate):
        true
      else:
        is-duplicate-hires(r, acc)
      end
  end
where:
  is-duplicate-hires([list-set: hire(4, 2), hire(3, 1), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), false) is false
  is-duplicate-hires([list-set: hire(4, 2), hire(4, 1), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), false) is true
  is-duplicate-hires([list-set: hire(4, 2), hire(3, 2), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), false) is true
  is-duplicate-hires([list-set: hire(4, 2), hire(4, 2), hire(2, 3), hire(1,4), hire(0, 0)].to-list(), false) is false
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
  is-correct-lengths(companies, candidates, hires) and is-values-in-correct-range(companies, candidates, hires) and not(is-duplicate-hires(hires.to-list(), false))
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
  hires = a-matchmaker(companies, candidates)
  true
where:
  oracle(matchmaker) is true
end