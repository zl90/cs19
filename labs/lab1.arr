### Lab 3: Higher order functions

# Write a function to convert a list of fahrenheit temperatures into a list of celcius temperatures:
fun f-to-c(fahr :: List<Number>) -> List<Number>:
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