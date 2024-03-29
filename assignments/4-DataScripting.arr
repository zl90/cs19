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

data NameCount:
  | name-count(name :: String, count :: Number) 
end

fun get-n(name :: String, l :: List<NameCount>, acc :: Number) -> Number:
  doc: 'Searches a list of NameCounts for a specific name and returns the index of the name in the list. Raises an error if the index does not exist in the list.'
  cases (List) l:
    | empty => raise('Error: name is not in list')
    | link(f, r) =>
      if f.name == name:
        acc
      else:
        get-n(name, r, acc + 1)
      end
  end
where:
  get-n('jerry', [list: name-count('fred', 5), name-count('jerry', 2)], 0) is 1
  get-n('gene', [list: name-count('fred', 5), name-count('jerry', 2)], 0) raises 'Error: name is not in list'
end

fun name-count-contains(name :: String, l :: List<NameCount>) -> Boolean:
  doc: 'Returns true if a name-count list contains an entry which matches the name, false otherwise'
  cases (List) l:
    | empty => false
    | link(f, r) =>
      if (f.name == name):
        true
      else:
        name-count-contains(name, r)
      end
  end
where:
  name-count-contains('fred', [list: name-count('john', 2), name-count('fred', 2)]) is true
  name-count-contains('fred', [list: name-count('john', 2), name-count('randy', 2)]) is false
end

fun increment(name :: String, l :: List<NameCount>, value :: Number) -> List<NameCount>:
  doc: 'Searches the list for the entry that matches the name, then increments the count of that entry by the value'
  if name-count-contains(name, l):
    block:
      index = get-n(name, l, 0)
      result = set(l, index, name-count(name, get(l, index).count + value))
      result
    end
  else:
    l
  end
where:
  increment('fred', [list: name-count('fred', 2)], 1) is [list: name-count('fred', 3)]
  increment('fred', [list: name-count('george', 2)], 1) is [list: name-count('george', 2)]
end

fun frequent-words(words :: List<String>) -> List<String>:
  doc: 'Consumes a list of strings and produces a list containing the three strings that occur the most frequently in the input list'
  namecounts = fold(lam(acc, word):
      if name-count-contains(word, acc):
        increment(word, acc, 1)
      else:
        acc + [list: name-count(word, 1)]
      end
    end, empty, words)
  sorted = sort-by(namecounts, lam(a, b): a.count > b.count end, lam(a, b): a.count == b.count  end)
  topthree = sorted.take(3)
  result = topthree.map(lam(x): x.name end)
  result
where:
  frequent-words([list: "silver", "james", "james", "silver", "howlett", "silver", "loganne", "james", "loganne"]) is  [list: "james", "silver", "loganne"]
end

### Task 7: Earthquake Monitoring.
data HzReport:
  | max-hz(date :: Number, max-reading :: Number)
end

fun extract-month(num :: Number) -> Number:
  doc: 'Given an 8 digit integer which represents a date (eg: 20220708), returns a 1 or 2 digit integer representing the month from the input integer'
  modulo = num-modulo(num, 10000)
  num-floor(modulo / 100)
where:
  extract-month(20150613) is 6
  extract-month(20151213) is 12
  extract-month(20150113) is 1
end
  
fun fold-hz-data(l :: List<Number>, acc :: List<HzReport>, last-max-report :: HzReport) -> List<HzReport>:
  doc: 'Folds over a list of seismic data and returns a sorted list of the max seismic reading per day'
  cases (List) l:
    | empty => acc
    | link(f, r) => 
      if f > 500:
        fold-hz-data(r, acc + [list: max-hz(f, 0)], max-hz(f, 0))
      else:
        if last-max-report.max-reading < f:
          if acc.length() > 0:
            fold-hz-data(r, set(acc, acc.length() - 1, max-hz(last-max-report.date, f)), max-hz(last-max-report.date, f))
          else:
            fold-hz-data(r, [list: max-hz(last-max-report.date, f)], max-hz(last-max-report.date, f))
          end
        else:
          fold-hz-data(r, acc, last-max-report)
        end
      end
  end
end

fun daily-max-for-month(sensor-data :: List<Number>, month :: Number) -> List<HzReport>:
  doc: 'Consumes a list of seismic data and returns a sorted list of the max seismic reading per day, for a specified month'
  top-reports = fold-hz-data(sensor-data, empty, max-hz(sensor-data.get(0), 0))
  reports-for-this-month = top-reports.filter(lam(x): extract-month(x.date) == month end)
  
  reports-for-this-month
where:
  daily-max-for-month([list: 20151004, 150, 200, 175, 20151005, 0.002, 0.03, 20151007, 130, 0.54, 20151101, 78], 10) is [list: max-hz(20151004, 200), max-hz(20151005, 0.03), max-hz(20151007, 130)]
end