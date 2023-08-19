# CSCI0190 (Fall 2018)
provide *

import shared-gdrive("map-reduce-support.arr",
  "1F87DfS_i8fp3XeAyclYgW3sJPIf-WRuH") as support

type Tv-pair = support.Tv-pair
tv = support.tv
wc-map = support.wc-map
wc-reduce = support.wc-reduce

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

# data Tv-pair<A, B>:
#   | tv(tag :: A, value :: B)
# end

## A. Your map-reduce definition

fun mapper-helper<A,B,M,N>(input :: List<Tv-pair<A,B>>, mapper :: (Tv-pair<A,B> -> List<Tv-pair<M,N>>)) -> List<Tv-pair<M,N>>:
  doc: "Applies a mapper function to each tag-value pair in the input list, returns a list of tokenized tag-value pairs"
  cases (List) input:
    | empty => empty
    | link(f, r) =>
      mapper(f) + mapper-helper(r, mapper)
  end
where:
  mapper-helper([list: tv('test', 'this is a sentence'), tv('test2', 'this is foo bar')], wc-map) is [list: tv('this', 1), tv('is', 1), tv('a', 1), tv('sentence', 1), tv('this', 1), tv('is', 1), tv('foo', 1), tv('bar', 1)]
end

fun get-index(lst :: List<Tv-pair>, elt :: Tv-pair, n :: Number) -> Number:
  cases (List) lst:
    | empty => raise('Element does not exist in the list')
    | link(f, r) =>
      if f.tag == elt.tag:
        n
      else:
        get-index(r, elt, n + 1)
      end
  end
end

fun tv-contains(lst :: List<Tv-pair>, elt :: Tv-pair) -> Boolean:
  cases (List) lst:
    | empty => false
    | link(f, r) =>
      if f.tag == elt.tag:
        true
      else:
        tv-contains(r, elt)
      end
  end
end

fun shuffle-helper<M,N>(input :: List<Tv-pair<M,N>>, acc :: List<Tv-pair<M,List<N>>>) -> List<Tv-pair<M,List<N>>>:
  doc: "Takes a list of mapper outputs and converts it into a list of reducer inputs"
  cases (List) input:
    | empty => acc
    | link(f, r) =>
      if tv-contains(acc, f):
        index = get-index(acc, f, 0)
        shuffle-helper(r, acc.set(index, tv(f.tag, acc.get(index).value + [list: f.value])))
      else:
        shuffle-helper(r, acc + [list: tv(f.tag, [list: f.value])])
      end
  end
where:
  test-input = [list: tv('this', 1), tv('is', 1), tv('a', 1), tv('sentence', 1), tv('this', 1), tv('is', 1), tv('foo', 1), tv('bar', 1)]
  shuffle-helper(test-input, empty) is [list: tv('this', [list: 1,1]), tv('is', [list: 1,1]), tv('a', [list: 1]), tv('sentence', [list: 1]), tv('foo', [list: 1]), tv('bar', [list: 1])]
end

fun reduce-helper<M,N,O>(input :: List<Tv-pair<M,List<N>>>, reducer :: (Tv-pair<M,List<N>> -> Tv-pair<M,O>)) -> List<Tv-pair<M,O>>:
  doc: "Applies a reducer function to a list of tag-value pairs"
  cases (List) input:
    | empty => empty
    | link(f, r) =>
      link(reducer(f), reduce-helper(r, reducer))
  end
where:
  test-input = [list: tv('this', [list: 1,1]), tv('is', [list: 1,1]), tv('a', [list: 1]), tv('sentence', [list: 1]), tv('foo', [list: 1]), tv('bar', [list: 1])]
  reduce-helper(test-input, wc-reduce) is [list: tv('this', 2), tv('is', 2), tv('a', 1), tv('sentence', 1), tv('foo', 1), tv('bar', 1)]
end

fun map-reduce<A,B,M,N,O>(input :: List<Tv-pair<A,B>>,
    mapper :: (Tv-pair<A,B> -> List<Tv-pair<M,N>>),
    reducer :: (Tv-pair<M,List<N>> -> Tv-pair<M,O>)) -> List<Tv-pair<M,O>>:
  doc:"A simplified, recursive simulation of Google's MapReduce framework"
  mapped-output = mapper-helper(input, mapper)
  shuffled-output = shuffle-helper(mapped-output, empty)
  reduced-output = reduce-helper(shuffled-output, reducer)
  
  reduced-output
where:
  test-input = [list: tv('test', 'this is a sentence'), tv('test2', 'this is foo bar')]
  map-reduce(test-input, wc-map, wc-reduce) is [list: tv('this', 2), tv('is', 2), tv('a', 1), tv('sentence', 1), tv('foo', 1), tv('bar', 1)]
end

### B. Your anagram implementation  
  
fun anagram-map(input :: Tv-pair<String, String>) 
  -> List<Tv-pair<String, String>>:
  doc:""
  empty
where:
  empty is empty
end

fun anagram-reduce(input :: Tv-pair<String, List<String>>) 
  -> Tv-pair<String, List<String>>:
  doc:""
  empty
where:
  empty is empty
end


## C. Your Nile implementation

fun recommend(title :: String, 
  book-records :: List<Tv-pair<String, String>>)
  -> Tv-pair<Number, List<String>>:
  doc:""
  empty
where:
  empty is empty
end

fun popular-pairs(book-records :: List<Tv-pair<String, String>>) 
  -> Tv-pair<Number, List<String>>:
  doc:""
  empty
where:
  empty is empty
end


