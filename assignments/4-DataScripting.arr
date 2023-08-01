#### Assignment 4: Data Scripting

### Task 1: Write a function that consumes a string and produces a boolean indicating whether the string with all the spaces and punctuation removed in a palindrome.

fun is-alphanumeric(num :: Number) -> Boolean:
  doc: 'Returns true if the input number corresponds with an alphanumeric character code in the ASCII character set'
  ((num >= 47) and (num <= 57)) or ((num >= 65) and (num <= 90)) or ((num >= 97) and (num <= 122))
where:
  is-alphanumeric(40) is false
  is-alphanumeric(50) is true
  is-alphanumeric(84) is true
end

fun is-palindrome(str :: String) -> Boolean:
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
