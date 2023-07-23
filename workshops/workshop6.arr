#### Workshop 6 - Lists and Recursion

# General list format:
# link(first :: A, rest :: List)
#
# An empty list is denoted as:
# empty
# or
# [list:]

# A list with only one element is just a linked
# list where an element is linked to an empty list:
[list: "lonely"]
# is the same as:
link("lonely", empty)

# link is a function that takes in an element and a
# list, and appends the element to the front of the
# list and returns the new list
link(23, [list: 24, 25, 26])
# is the same as:
[list: 23, 24, 25, 26]
# is the same as: 
link(23, link(24, link(25, link(26, empty))))


### Recursion
# calling a function inside of its own function
# body.

## Recursion Cheat Sheet:
# All recursive functions have two parts:
#    - Base case: simplest case?
#    - Recursive case: what is the relationship
#      between this case and the answer to a
#      slightly smaller case?
# Each time you make a recursive call you MUST make
# the input smaller somehow! Like decrementing a
# number.

# Example: length of a list.
# Define a function `my-length`, that takes in a
# List as an input and returns a Number representing
# how long the input list was.

# This was my attempt:
fun my-length(my-list :: List, count :: Number) -> Number:
  if my-list == empty:
    # base case
    count
  else: 
    # relationship: list gets smaller, count goes up
    my-length(my-list.rest, count + 1)
  end
end

my-length([list: 1, 2, 3, 3, 3], 0)

# This was the answer:
fun my-length-answer(lst :: List) -> Number:
  doc: "outputs the length of the inputted list"
  cases (List) lst:
    | empty =>  0
    | link(first, rest) => 1 + my-length-answer(rest)
  end
end

my-length-answer([list: 1, 2, 3, 3, 3])

# Takeaways:
# They use the `cases` syntax, this isn't needed as
# you can just use conditionals.
# They were able to eliminate the need for a count
# parameter by simply returning 1 + my-length, very
# nice!

# To check if some list `li` contains the number 29:
li = [list: 1, 2, 29]
member(li, 29) # evaluates to true

# Assume we have some list `temps` containing
# temperature readings in degrees Fahrenheit
# which operations would we use to convert all of
# the tempts to Celsius? The answer is map:
map(lam(fahr): fahr + 30 end, [list: 12, 23, 2])

# Assume we have some list containing temperature
# readings in degrees celcius: which operations
# would we use to find the temperatures below
# freezing?
filter(lam(cels): cels < 0 end, [list: 23, -10, -2])

# Assume you're given a list of strings and want the
# number of unique strings, considering two strings
# to be the same if they have the same letters but
# perhaps different capitalization.
length(distinct(map(lam(x): string-to-lower(x) end,[list: 'a', 'A', 'b', 'c', 'c'])))