#### Assignment 4: Sortacle

## Task 1: Write a function named `generate-input` that generates a list of random `Persons`:
MAX_CHARACTERS_IN_NAME = 15
MIN_CHARACTERS_IN_NAME = 2
MAX_AGE = 120
MIN_ASCII_CHAR = 65 # 'A'
MAX_ASCII_CHAR = 122 # 'z'

data Person:
  | person(name :: String, age :: Number) 
end

fun generate-name(len :: Number) -> String:
  doc: 'Generates a random name with a specified length'
  initial-list = range(0, len)
  ascii-list = initial-list.map(lam(item): num-random(MAX_ASCII_CHAR - MIN_ASCII_CHAR) +
    MIN_ASCII_CHAR end)
  char-list = ascii-list.map(lam(item): string-from-code-point(item) end)
  result = char-list.join-str("")
  result
end

fun generate-input(len :: Number) -> List<Person>:
  doc: 'Generates a random list of `Person`s with a specified length'
  if not(num-is-integer(len)) or (len < 0):
      raise("Error: length must be a positive integer")
  else:
    initial-list = range(0, len)

    fun functor(index :: Number) -> Person:
      name = generate-name(num-random(MAX_CHARACTERS_IN_NAME - MIN_CHARACTERS_IN_NAME) + 
        MIN_CHARACTERS_IN_NAME)
      age = num-random(MAX_AGE)
      person(name, age)
    end
    
    result = initial-list.map(functor)
    result
  end
where:
  generate-input(0) is empty
  generate-input(-1) raises "Error: length must be a positive integer"
  generate-input(0.55) raises "Error: length must be a positive integer"
  length(generate-input(6)) is 6
  generate-input(5).map(lam(x): x.age >= 0 is true end) # Check ages are non-negative
  generate-input(5).map(lam(x): string-length(x.name) > 0 is true end) # Check names are not empty
end

## Task 2: Write a function that determines whether the 2nd input is a sorted version of the 1st
fun insert(p :: Person, l :: List<Person>) -> List<Person>:
  doc: 'Inserts the Person `p` into the list `l`'
  cases (List) l:
    | empty => [list: p]
    | link(f, r) =>
      if p.age <= f.age:
        link(p, l)
      else:
        link(f, insert(p, r))
      end
  end
end

fun insertion-sort(l :: List<Person>) -> List<Person>:
  doc: 'Takes a list of `Person`s and returns a sorted list of `Person`s'
  cases (List) l:
    | empty => empty
    | link(f, r) => insert(f, insertion-sort(r))
  end
where:
  insertion-sort([list: person('asdf', 3), person('asdf', 2), person('asdf', 1)]) is
  [list: person('asdf', 1), person('asdf', 2), person('asdf', 3)]
  insertion-sort([list: ]) is [list: ]
end

fun is-ages-equal(list1 :: List<Person>, list2 :: List<Person>) -> Boolean:
  doc: 'Returns true if each index in two lists of `Person`s share the same `age` value'
  cases (List) list1:
    | empty => true
    | link(f1, r1) =>
      cases (List) list2:
        | empty => true
        | link(f2, r2) =>
          if f1.age == f2.age:
            is-ages-equal(r1, r2)
          else:
            false
          end
      end
  end
where:
  is-ages-equal([list: person('c', 3), person('b', 3), person('a', 3)],
    [list: person('b', 3), person('c', 3), person('a', 3)]) is true
  is-ages-equal([list: person('c', 2), person('b', 3), person('a', 3)],
    [list: person('b', 3), person('c', 3), person('a', 3)]) is false
end

fun is-string-list-equal(list1 :: List<String>, list2 :: List<String>) -> Boolean:
  doc: 'Returns true if each index in two lists of Strings are the same'
    cases (List) list1:
    | empty => true
    | link(f1, r1) =>
      cases (List) list2:
        | empty => true
        | link(f2, r2) =>
          if f1 == f2:
            is-string-list-equal(r1, r2)
          else:
            false
          end
      end
  end
end

fun is-names-equal(list1 :: List<Person>, list2 :: List<Person>) -> Boolean:
  doc: 'Returns true if each index in two lists of `Person`s share the same `name` value'
    
  names1 = sort(list1.map(lam(x): x.name end))
  names2 = sort(list2.map(lam(x): x.name end))
  
  is-string-list-equal(names1, names2)
where:
  is-names-equal([list: person('aaa', 3), person('asdf', 2), person('asdf', 1)],
    [list: person('asdf', 1), person('asdf', 2), person('aaa', 3)]) is true
  is-names-equal([list: person('ag', 1), person('asdf', 2), person('asdf', 3)],
    [list: person('asdf', 1), person('asdf', 2), person('asdf', 3)]) is false
end

fun all-elements-exist-in-both(list1 :: List<Person>, list2 :: List<Person>) -> Boolean:
  doc: 'Returns true if each element in `list1` exists in `list2`, regardless of order'
  cases (List) list1:
    | empty => true
    | link(f, r) =>
      block:
        found = list2.find(lam(x): (x.name == f.name) and (x.age == f.age) end)
        if found == none:
          false
        else:
          all-elements-exist-in-both(r, list2)
        end
      end
  end
where:
  all-elements-exist-in-both([list: person('asdf', 3), person('asdf', 2), person('asdf', 1)],
    [list: person('asdf', 1), person('asdf', 2), person('asdf', 3)]) is true
  all-elements-exist-in-both([list: person('asdf', 3), person('asdf', 2), person('asdf', 1)],
    [list: person('asdf', 1), person('asdf', 2), person('ddd', 3)]) is false
end

fun is-valid(list1 :: List<Person>, list2 :: List<Person>) -> Boolean:
  doc: 'Returns true if the 2nd input is a sorted version of the 1st input, false otherwise'
  if (list1 == empty) or (list2 == empty) or not(length(list1) == length(list2)):
    false
  else:
    list1-sorted = insertion-sort(list1)
    is-ages-equal(list1-sorted, list2) and is-names-equal(list1-sorted, list2) and
    all-elements-exist-in-both(list1-sorted, list2)
  end
where:
  is-valid([list: person('asdf', 3), person('asdf', 2), person('asdf', 1)],
    [list: person('asdf', 1), person('asdf', 2), person('asdf', 3)]) is true
  is-valid([list: person('c', 3), person('b', 3), person('a', 3)],
    [list: person('b', 3), person('c', 3), person('a', 3)]) is true # Any permutation of names is ok
  is-valid([list: person('a', 3)], [list: person('a', 3), person('b', 4)]) is false
  is-valid([list: person('a', 3)], [list: ]) is false
  is-valid([list: ], [list: ]) is false # Empty lists can't be sorted, so this is not valid
  is-valid([list: person('a', 1), person('b', 1), person('c', 2), person('d', 3)],
    [list: person('b', 1), person('a', 1), person('d', 3), person('c', 2), ]) is false
end

