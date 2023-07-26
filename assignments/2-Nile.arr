### Assignment 2: Nile

## Part 1
data File:
    | file(name :: String, content :: List<String>)
end

data Recommendation<A>:
    | recommendation(count :: Number, content :: List<A>)
end

data BookPair:
  | pair(book1 :: String, book2 :: String)
end

data BookCount:
  | bookcount(title :: String, count :: Number)
end

fun contains(lst :: List<String>, str :: String) -> Boolean:
  doc: 'Returns true if the list `lst` contains the string `str`, returns false if it doesnt'
  cases (List) lst:
    | empty => false
    | link(first, rest) =>
      if first == str:
        true
      else:
        contains(rest, str)
      end
  end
where:
  contains([list: 'aaa', 'bbb'], 'aaa') is true
  contains([list: 'aaa', 'bbb'], 'ccc') is false
end

fun bookcount-list-contains(lst :: List<BookCount>, str :: String) -> Boolean:
  doc: 'Returns true if the list `lst` contains the string `str`, returns false if it doesnt'
  cases (List) lst:
    | empty => false
    | link(first, rest) =>
      if first.title == str:
        true
      else:
        bookcount-list-contains(rest, str)
      end
  end
where:
  bookcount-list-contains([list: bookcount('aaa', 1), bookcount('bbb', 1)], 'aaa') is true
  bookcount-list-contains([list: bookcount('aaa', 2), bookcount('bbb', 1)], 'ccc') is false
  bookcount-list-contains(empty, 'nnn') is false
end

fun filter-files(title :: String, files :: List<File>) -> List<File>:
  doc: 'Filters out any files that dont contain the `title` in their content list'
  predicate = lam(x): contains(x.content, title) end
  filter(predicate, files)
where:
  filter-files('rrr', [list: file('main.cpp', [list: 'aaa', 'bbb', 'ccc']), file('str.cpp', [list: 'aaa', 'bbb', 'ddd'])]) is [list: ]
  filter-files('aaa', [list: file('main.cpp', [list: 'aaa', 'bbb', 'ccc']), file('str.cpp', [list: 'aaa', 'bbb', 'ddd'])]) is [list: file('main.cpp', [list: 'aaa', 'bbb', 'ccc']), file('str.cpp', [list: 'aaa', 'bbb', 'ddd'])]
end

fun combine-files(lst :: List<File>, title :: String) -> List<String>:
  doc: 'Combines a list of files into one big list of all their content'
  cases (List) lst:
    | empty => empty
    | link(first, rest) => filter(lam(x): not(x == title) end, first.content) + combine-files(rest, title)
  end
where:
  combine-files([list: file('main.cpp', [list: 'aaa', 'bbb', 'ccc']), file('str.cpp', [list: 'aaa', 'bbb', 'ddd'])], 'aaa') is [list:  'bbb', 'ccc', 'bbb', 'ddd']
end

fun count-recommendations(lst :: List<String>, base :: List<BookCount>) -> List<BookCount>:
  doc: 'Takes a list of recommendations and counts their frequencies, returns a list of BookCount objects'
  cases (List) lst:
    | empty => base
    | link(first, rest) =>
      if bookcount-list-contains(base, first):
        block:
          old = find(lam(x): x.title == first end, base)
          old-value = cases (Option) old:
            | none => none
            | some(value) => value
          end
          clone = bookcount(old-value.title, (old-value.count + 1))
          new-base = filter(lam(x): not(x.title == first) end, base)
          count-recommendations(rest, link(clone, new-base))
        end
      else:
        count-recommendations(rest, link(bookcount(first, 1), base))
      end
  end
where:
  count-recommendations([list: 'a', 'a', 'b'], empty) is [list: bookcount('b', 1), bookcount('a', 2)]
end

fun get-top-recommendations(lst :: List<BookCount>) -> List<BookCount>:
  doc: 'Takes a list of BookCounts and returns a list of the ones with the highest count (aka: the most popular ones)'
  max-count = fold(lam(acc, curr): if curr.count > acc:
        curr.count
      else:
        acc
      end
      end, 0, lst)
  filter(lam(x): x.count == max-count end, lst)
where:
  get-top-recommendations([list: bookcount("ddd", 1), bookcount("bbb", 2), bookcount("ccc", 1)]) is [list: bookcount('bbb', 2)]
end

fun map-data(lst :: List<BookCount>) -> Recommendation:
  doc: 'Takes a list of BookCounts and maps them to a single Recommendation object'
  fold(lam(acc, curr): recommendation(curr.count, link(curr.title, acc.content)) end, recommendation(0, empty), lst)
where:
  map-data([list: bookcount('bbb', 2), bookcount('nnn', 2)]) is recommendation(2, [list: 'nnn', 'bbb']) 
end

fun recommend(title :: String, book-records :: List<File>) -> Recommendation<String>:
  doc: 'Takes a book title and a list of Files and produces a Recommendation'
  filtered-files = filter-files(title, book-records)
  combined-files = combine-files(filtered-files, title)
  counted-recs = count-recommendations(combined-files, empty)
  top-recommendations = get-top-recommendations(counted-recs)
  result = map-data(top-recommendations)
  
  result
where:
  recommend('aaa', [list: file('main.cpp', [list: 'aaa', 'bbb', 'ccc']), file('str.cpp', [list: 'aaa', 'bbb', 'ddd', 'ccc'])]) is recommendation(2, [list: 'bbb', 'ccc'])
  recommend('aaa', [list: file('main.cpp', [list: 'vvv', 'bbb', 'ccc']), file('str.cpp', [list: 'hhh', 'bbb', 'ddd'])]) is recommendation(0, [list:])
end

## Part 2



