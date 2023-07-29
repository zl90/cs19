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
  initial-list = range(0, len)
  ascii-list = initial-list.map(lam(item): num-random(MAX_ASCII_CHAR - MIN_ASCII_CHAR) +
    MIN_ASCII_CHAR end)
  char-list = ascii-list.map(lam(item): string-from-code-point(item) end)
  result = char-list.join-str("")
  result
end

fun generate-input(len :: Number) -> List<Person>:
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
  generate-input(5).map(lam(x): string-length(x.name) > 0 is true end) # Check names are valid
end


