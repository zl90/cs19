#### Assignment 1 - DocDiff

fun overlap(doc1 :: List<String>, doc2 :: List<String>) -> Number:

fun distinct_words(input1 :: List, input2 :: List) -> List:
  doc: "Given two lists of words, returns a list of all distinct words from both lists"
    input1_lowercase = (map(lam(x): string-to-lower(x) end, input1))
    input2_lowercase = (map(lam(x): string-to-lower(x) end, input2))
  combined = append(input1_lowercase, input2_lowercase)
    sort(distinct(combined))
where:
  distinct_words([list: 'A', 'b'], [list: 'a', 'B', 'b']) is [list: 'a', 'b']
    distinct_words([list: "a", "B", "c"],
      [list: "d", "d", "D", "b"]) is [list: 'a', 'b', 'c', 'd']

end

fun vectorise(input :: List, possible_words :: List) -> List:
  doc: "Converts list of words into a vector list representing the frequencies of each distinct word"
    input_lowercase = map(string-to-lower, input)
  map(lam(x): length(filter(lam(y): x == y end, input_lowercase)) end, possible_words)
where:
  vectorise([list: 'a', 'A', 'c'], [list: 'a', 'b', 'c']) is [list: 2, 0, 1]
    vectorise([list: "d", "d", "D", "b"], [list: 'a', 'b', 'c', 'd']) is [list: 0, 1, 0, 3]
    vectorise([list: 'a', 'B', 'c'], [list: 'a', 'b', 'c', 'd']) is [list: 1, 1, 1, 0]
    
end

  fun dot_product(vector1 :: List, vector2 :: List) -> Number:
    vectors_multiplied = map2(lam(x,y): x * y end, vector1, vector2)
    fold(lam(accumulator, value): accumulator + value end, 0, vectors_multiplied)
  where:
    dot_product([list: 1, 2, 1], [list: 1, 3, 2])  is 9
    dot_product([list: 1, 1, 1, 0], [list: 0, 1, 0, 3]) is 1
  end

  fun normalised_dot_product(vector1 :: List, vector2 :: List) -> Number:
    doc: "Takes two vectors, calculates their dot product, then returns the normalized result of the dot product"
    magnitude1 = num-sqrt(dot_product(vector1, vector1))
    magnitude2 = num-sqrt(dot_product(vector2, vector2))
  
    dot_product(vector1, vector2) / num-max(num-sqr(magnitude1), num-sqr(magnitude2))
  where:
    normalised_dot_product([list: 1, 2, 3], [list: 1, 2, 3]) is-roughly 1
    normalised_dot_product([list: 1, 1, 1, 1], [list: 0, 0, 1, 1]) is-roughly 0.5
    normalised_dot_product([list: 1, 0, 0], [list: 0, 1, 1]) is-roughly 0  
    normalised_dot_product([list: 1, 1, 1, 0], [list: 0, 1, 0, 3]) is-roughly 0  
  end

  words = distinct_words(doc1, doc2)
  v1 = vectorise(doc1, words)
  v2 = vectorise(doc2, words)
  normalised_dot_product(v1, v2)
  
where:
  overlap([list: 'a', 'b', 'c'], [list: 'a', 'd', 'f']) is-roughly 1/3
  overlap([list: "welcome", "to", "Walmart"], 
    [list: "WELCOME", "To", "walmart"]) is-roughly 3/3
  overlap([list: 'a', 'b', 'c'], [list: 'a', 'b', 'd', 'f']) is-roughly 2/4
  overlap([list: "a", "c"], [list: "c"]) is-roughly 1/2
  overlap([list: "1", "!", "A", "?", "b", "a"], 
    [list: "1", "A", "b"]) is-roughly 3/5
  overlap([list: "a", "C", 'x', 'Y'], [list: "c", 'u', 'o', 'l']) is-roughly 1/4
  overlap([list: 'a', 'B', 'c'], [list: 'd', 'd', 'D', 'b']) is-roughly 1/3
end

li1 = [list: 'a', 'B', 'c']
li2 = [list: 'd', 'e', 'f', 'b']

overlap(li1, li2)