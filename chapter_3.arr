#### DCIC Chapter 3 - Basic Data
### 3.1 Getting Started

# What do you notice about the flags?
# - All rectangular
# - Simple colors
# - Made up mostly of simple shapes
# - A few exceptions
# - How can we render the special image
#   for Zambia?

## 3.1.3 Expressions

# What is an expression?
# - Combining smaller computations in a
#   format that Pyret can understand.
# - In other words: computation written
#   in the formal notation of a
#   programming language.

# Exercise: 
# the max of 5, -10 and -20:
num-max(5, num-max(-10, -20))

# fractions:
1/3

## 3.1.6 Images
circle(30, "solid", "red")
rectangle(100, 60, "outline", "purple")

## 3.1.6.1 Combining images
rotate(45, rectangle(20, 20, "solid", "red"))
overlay(circle(25, "solid", "red"), rectangle(30, 50, "solid", "blue"))
above(circle(25, "solid", "red"), rectangle(30, 50, "solid", "blue"))
triangle(20, "solid", "green")
overlay(rotate(180, triangle(30, "solid", "white")), triangle(60, "solid", "yellow"))
overlay(circle(10, "solid", "red"), overlay(circle(20, "solid", "white"), circle(30, "solid", "red")))

## 3.1.6.2
# Draw the flag of Armenia
above(rectangle(100, 20,"solid", "red"), above(rectangle(100, 20,"solid", "blue"), rectangle(100, 20,"solid", "orange")))

## 3.1.7 Types, Errors, and Documentation
# Create an error:
# 8 * circle(25, "solid", "red")

# Types notation:
# What is this contract telling you?
#
# rotate :: (degrees :: Number, img :: 
#     Image) -> Image
#
# The contract defines a function 'rotate'
# which takes two args: degrees (which is
# a number) and img (which is an Image
# type), and the function returns an
# image type.

## 3.1.7.3 Documentation
radial-star(7, 28, 64, "solid", "dark-green")

### 3.2 Naming Values
red-circ = circle(30, "solid", "red")
red-circ

## 3.2.2.2 Expressions vs. Statements
# Definitions tell Pyret to associate names
# with values.
# Expressions tell Pyret to perform a
# computation and return the result.

# Expressions:
5 + 8
triangle(20, "solid", "blue")

# Definitions:
x = 15 + 13
blue_circle = circle(x, "solid", "blue")

# Definitions are a kind of Statement.
# Statements don't yield values but instead
# give some other kind of instruction to the
# language.

## 3.2.3 The Program Directory
width = 29
width # const, can't be reassigned

### 3.4 Conditionals and Booleans
## 3.4.1 Shipping Costs example
fun pen_cost(num_pens :: Number, word :: String) -> Number:
  PRICE_PER_CHAR = 0.02
  PRICE_PER_PEN = 0.25
  num_pens * (PRICE_PER_PEN + (string-length(word) * PRICE_PER_CHAR))
where:
  pen_cost(5, 'Hell') is 1.65
  pen_cost(1, 'Hi') is (0.25 + (2 * 0.02))
  pen_cost(2, 'Hi') is (2 * ((0.25 + (2 * 0.02))))
  pen_cost(3, 'Hell') is 0.99
end

# Write a function to compute total cost of order
# including shipping:
fun add_shipping(order_cost :: Number) -> Number:
  if (order_cost > 30):
    order_cost + 12
  else if (order_cost > 10):
    order_cost + 8
  else:
    order_cost + 4
  end
where:
  add_shipping(10) is 14
  add_shipping(10.001) is 18.001
  add_shipping(100) is 112
end

# Conditionals are 'computations with decisions'

# You can compare strings for alphabitical order:
"a" < "b" #true

# Compare `true` and `false`
false == true #false

"test" == "test" #true

# The string-contains function is like .include()
# in typescript:
string-contains("test", "t") #true

## 3.4.4
# Exercise: skateboarding ad
# (using only conditional statements)
fun show_ad_conditionals(age :: Number, hair_color :: String) -> Boolean:
  if (age <= 18):
    if (age >= 9):
      if (hair_color == 'pink'):
        true
      else if (hair_color == 'purple'):
        true
      else:
        false
      end
    else:
      false
    end
  else:
    false
  end
where:
  show_ad_conditionals(7, 'red') is false
  show_ad_conditionals(10, 'pink') is true
  show_ad_conditionals(10, 'red') is false
  show_ad_conditionals(18, 'purple') is true
end

# Exercise: skateboarding ad
# (using only boolean operations)
fun show_ad_booleans(age :: Number, hair_color :: String) -> Boolean:
  (age >= 9) and (age <= 18) and ((hair_color == 'pink') or (hair_color == 'purple'))
where:
  show_ad_conditionals(7, 'red') is false
  show_ad_conditionals(10, 'pink') is true
  show_ad_conditionals(10, 'red') is false
  show_ad_conditionals(18, 'purple') is true
end

## 3.4.6 Composing Functions
# Write a function that computes the total cost,
# with shipping, or an order of 10 pens that say
# "bravo"
fun compute_total_cost(num_of_pens :: Number, word :: String) -> Number:
  cost_of_pens = pen_cost(num_of_pens, word)
  add_shipping(cost_of_pens)
where:
  compute_total_cost(10, "bravo") is 7.5
end

# How do the following expressions differ?
# 1:
cost_of_pens = pen_cost(10, "bravo")
add_shipping(cost_of_pens)

# 2:
add_shipping(pen_cost(10, "bravo"))

# Answer: the 2nd expression does not write to the
# program directory, only reads, whereas the 1st
# expression writes `cost_of_pens` to the directory.

## 3.4.7 Nested Conditionals
fun buy_tickets1(count :: Number, is_senior :: Boolean) -> Number:
  doc: "Compute the price of tickets at $10 each"
  base_price = count * 10
  if is_senior or (count > 5):
    base_price * 0.85
  else:
      base_price
  end
where:
  buy_tickets1(0, false) is 0
  buy_tickets1(0, true) is 0
  buy_tickets1(2, false) is 2 * 10
  buy_tickets1(2, true) is 2 * 10 * 0.85
  buy_tickets1(6, false) is 6 * 10 * 0.85
  buy_tickets1(6, true) is 6 * 10 * 0.85
end


