#### Assignment 4: Data Scripting

### Task 1: Write a function that consumes a string and produces a boolean indicating whether the string with all the spaces and punctuation removed is a palindrome.

fun is-alphanumeric(num :: Number) -> Boolean:
  doc: 'Returns true if the input number corresponds with an alphanumeric character code in the ASCII character set'
  ((num >= 47) and (num <= 57)) or ((num >= 65) and (num <= 90)) or ((num >= 97) and (num <= 122))
where:
  is-alphanumeric(40) is false
  is-alphanumeric(50) is true
  is-alphanumeric(84) is true
end

fun is-palindrome(str :: String) -> Boolean:
  doc: 'Returns true if the input string with all the spaces and punctuation removed is a palindrome'
  split-str = string-split-all(str, "")
  cleaned = split-str.filter(lam(char): is-alphanumeric(string-to-code-point(char)) end).map(lam(char): string-to-lower(char) end)
  reversed = cleaned.reverse()
  string1 = cleaned.join-str("")
  string2 = reversed.join-str("")
  string1 == string2
where:
  is-palindrome("a man, a plan, a canal: Panama") is true
  is-palindrome("abca") is false
  is-palindrome("yes, he did it") is false
  is-palindrome("1221") is true
  is-palindrome("01001") is false
end

### Task 2: Sum Over Table. Design a program sum-largest that consumes a table of numbers and produces the sum of the largest item from each row. Assume that no row is empty.

fun sum-largest(l :: List<List<Number>>) -> Number:
  doc: 'Consumes a table of numbers and returns the sum of the largest item from each row'
  fold(lam(acc1, curr1):
      block:
        largest = fold(lam(acc2, curr2):
            block:
              if curr2 > acc2:
                curr2
              else:
                acc2
              end
            end
          end, 0, curr1)
        acc1 + largest
      end
    end, 0, l)
where:
  sum-largest([list: [list: 1, 7, 5, 3], [list: 20], [list: 6, 9]]) is (7 + 20 + 9)
end

### Task 3: Design a program called adding-machine that consumes a list of numbers and produces a list of the sums of each non-empty sublist separated by zeros. Ignore input elements that occur after the first occurrence of two consecutive zeros.

fun my-fold(l :: List<Number>, acc :: List<Number>, index :: Number) -> List<Number>:
  cases (List) l:
    | empty => acc
    | link(f, r) =>
      if f == 0:
        # Check whether the next number is zero. If so, return the accumulator, because we are done. If not, add a new entry to the accumulator.
        cases (List) r:
          | empty => acc
          | link(f2, r2) => 
            if f2 == 0:
              acc
            else:
              my-fold(r, acc + [list: f], index + 1)
            end
        end
      else:
        # Add the first element of the list to the last element of the accumulator.
          if (acc.length() > 0):
            my-fold(r, set(acc, index, acc.last() + f), index)
          else:
            my-fold(r, [list: f], index)
          end
      end
  end
end

fun adding-machine(l :: List<Number>) -> List<Number>:
  doc: 'Consumes a list of numbers and produces a list of the sums of each non-empty sublist separated by zeros'
  my-fold(l, empty, 0)
where:
  adding-machine([list: 1, 2, 0, 7, 0, 5, 4, 1, 0, 0, 6]) is [list: 3, 7, 10]
  adding-machine([list: 1, 0, 0]) is [list: 1]
  adding-machine([list: 0, 0, 0]) is [list: ]
end