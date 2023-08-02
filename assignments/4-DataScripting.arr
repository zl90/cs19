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
        # Check whether the next number in the list is zero. If so, return the accumulator, because we are done. If not, add a new entry to the accumulator.
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

### Task 4: The BMI sorter. 

data PHR:
  | phr(name :: String,
      height :: Number,
      weight :: Number,
      heart-rate :: Number)
end
    
data Report:
  | bmi-summary(under :: List<String>,
      healthy :: List<String>,
      over :: List<String>,
      obese :: List<String>)
end

fun bmi-report(phrs :: List<PHR>) -> Report:
  doc: 'Consumes a list of Personal Health Records and returns a BMI Report containing lists of names of patients and their BMI classification'
  fold(lam(acc, patient):
      block:
        bmi = patient.weight / (patient.height * patient.height)
        if bmi < 18.5:
          bmi-summary(acc.under + [list: patient.name], acc.healthy, acc.over, acc.obese)
        else if bmi < 25:
          bmi-summary(acc.under, acc.healthy + [list: patient.name], acc.over, acc.obese)
        else if bmi < 30:
          bmi-summary(acc.under, acc.healthy, acc.over + [list: patient.name], acc.obese)
        else:
          bmi-summary(acc.under, acc.healthy, acc.over, acc.obese + [list: patient.name])
        end
      end
    end, bmi-summary(empty, empty, empty, empty), phrs)
where:
  bmi-report([list: phr("eugene", 2, 60, 77), phr("matty", 1.55, 58.17, 56 ), phr("ray", 1.8, 55, 84), phr("mike", 1.5, 100, 64)]) is bmi-summary(
  [list: "eugene", "ray"], # under
  [list: "matty"],         # healthy
  [list: ],                # over
  [list: "mike"]           # obese
)
end

### Task 5: Data smoothing.

fun smoothing-fold(l :: List<PHR>, prev :: Option<Number>, acc :: List<Number>) -> List<Number>:
  cases (List) l:
    | empty => acc
    | link(curr, r) =>
      cases (Option) prev:
        | none => 
          # We're on the first element of the list. Just append it to the accumulator
          smoothing-fold(r, some(curr.heart-rate), acc + [list: curr.heart-rate])
        | some(previous) => 
        # Get the next element
        cases (List) r:
          | empty => acc + [list: curr.heart-rate] # We are at the end of the list
          | link(next, r2) => 
            block:
                average = (previous + curr.heart-rate + next.heart-rate) / 3
                smoothing-fold(r, some(curr.heart-rate), acc + [list: average])
            end
        end
      end
  end
end

fun data-smooth(phrs :: List<PHR>) -> List<Number>:
  doc: 'Consumes a list of personal health records and produces a list of the smoothed heart-rate values'
  smoothing-fold(phrs, none, empty)
where:
  data-smooth([list: phr("eugene", 2, 60, 77), phr("matty", 1.55, 58.17, 56 ), phr("ray", 1.8, 55, 84), phr("mike", 1.5, 100, 64)]) is [list: 77, (77 + 56 + 84) / 3, (56 + 84 + 64) / 3, 64]
end

# Task 6: Most Frequent Words.
# Given a list of strings, design a function frequent-words that produces a list containing the three strings that occur most frequently in the input list.

fun frequent-words(words :: List<String>) -> List<String>:
  doc: 'Consumes a list of strings and produces a list containing the three strings that occur the most frequently in the input list'
  # Ideas:
  # - sort the list then do a custom fold over it, accumulating the return list, the current word, the current count and the current max count? O(nlogn).
  # - use a list of custom data type like name-count(name :: String, count :: Number), sort the list by count, take the first 3 elements, check for same counts, then sort by name length. O(nlogn).
  # this would be very easy with a hash map... O(n).
where:
  frequent-words([list: "silver", "james", "james", "silver", "howlett", "silver", "loganne", "james", "loganne"]) is  [list: "james", "silver", "loganne"]
end

