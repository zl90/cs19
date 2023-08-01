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


