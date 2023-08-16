# CSCI0190 (Fall 2018)
provide *

import shared-gdrive("join-lists-support.arr",
  "1OH25NKkXAwcOtXs9yGLAjZO3u65T6T0J") as J

# Imports below

# Imports above

type JoinList = J.JoinList
empty-join-list = J.empty-join-list
one = J.one
join-list = J.join-list

split = J.split
join-list-to-list = J.join-list-to-list
list-to-join-list = J.list-to-join-list
is-non-empty-jl = J.is-non-empty-jl

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

##Implementation

test-jl = join-list(join-list(join-list(one(1), one(2), 2), one(3), 3), join-list(join-list(one(4), one(5), 2), one(6), 3), 6)

fun j-first<A>(jl :: JoinList<A>%(is-non-empty-jl)) -> A:
  doc:"Returns the first element of a JoinList"
  cases (JoinList) jl:
    | one(e) => e
    | join-list(_, _, _) =>
      j-first(split(jl, lam(x, _): x end))
  end
where:
  j-first(test-jl) is 1
  j-first(one(4)) is 4
end


fun j-rest<A>(jl :: JoinList<A>%(is-non-empty-jl)) -> JoinList<A>:
  doc:"Returns a JoinList containing all elements of the input JoinList except the first element"
  cases (JoinList) jl:
    | one(e) => empty-join-list
    | join-list(_, _, _) =>
      split(jl, lam(x, y): j-rest(x).join(y) end)
  end
where:
  join-list-to-list(j-rest(test-jl)) is [list: 2, 3, 4, 5, 6]
  j-rest(one(5)) is empty-join-list
  j-rest(join-list(one(1), one(2), 2)) is one(2)
end
  
  
fun j-length<A>(jl :: JoinList<A>) -> Number:
  doc:"Returns the length of the input JoinList"
  cases (JoinList) jl:
    | empty-join-list => 0
    | one(e) => 1
    | join-list(_, _, _) =>
      split(jl, lam(x, y): j-length(x) + j-length(y) end)
  end
where:
  j-length(test-jl) is 6
  j-length(one(4)) is 1
  j-length(empty-join-list) is 0
end


fun j-nth<A>(jl :: JoinList<A>%(is-non-empty-jl),
    n :: Number) -> A:
  doc:"Returns the nth element (using a 0-based index) of a list containing at least n+1 elements"
    cases (JoinList) jl:
    | one(e) => 
      if n == 0: 
        e
      else:
        raise("too large")
      end
    | join-list(_, _, _) =>
      split(jl, lam(j1, j2): 
          j1-length = j-length(j1)
          if j1-length <= n:
            j-nth(j2, n - j1-length)
          else:
            j-nth(j1, n)
          end
        end)
  end
where:
  j-nth(test-jl, 0) is 1
  j-nth(test-jl, 5) is 6
  j-nth(test-jl, 6) raises "too large"
  j-nth(one(5), 0) is 5
end


fun j-max<A>(jl :: JoinList<A>%(is-non-empty-jl), 
    cmp :: (A, A -> Boolean)) -> A:
  doc:"Returns the largest element in the JoinList according to the comparison function `cmp`"
  cases (JoinList) jl:
    | one(e) => e
    | join-list(_,_,_) => 
      split(jl, lam(l1, l2): 
          max-l1 = j-max(l1, cmp)
          max-l2 = j-max(l2, cmp)
          if cmp(max-l1, max-l2):
            max-l2
          else:
            max-l1
          end
        end)
  end
where:
  j-max(test-jl, lam(a,b): a < b end) is 6
  j-max(one(7), lam(a,b): a < b end) is 7
end


fun j-map<A,B>(map-fun :: (A -> B), jl :: JoinList<A>) -> JoinList<B>:
  doc:"Maps over the joinlist, returning a new joinlist with each element having the `map-fun` function applied to it"
  cases (JoinList) jl:
    | empty-join-list => empty-join-list
    | one(e) => one(map-fun(e))
    | join-list(_,_,_) => 
      split(jl, lam(l1, l2): 
          j-map(map-fun, l1).join(j-map(map-fun, l2))
        end)
  end
where:
  join-list-to-list(j-map(lam(x): x + 1 end, test-jl)) is [list: 2, 3, 4, 5, 6, 7]
end


fun j-filter<A>(filter-fun :: (A -> Boolean), jl :: JoinList<A>) -> JoinList<A>:
  doc:""
  empty-join-list
end


fun j-reduce<A>(reduce-func :: (A, A -> A), 
    jl :: JoinList<A>%(is-non-empty-jl)) -> A:
  doc:""
  ...
end


fun j-sort<A>(cmp-fun :: (A, A -> Boolean), jl :: JoinList<A>) -> JoinList<A>:
  doc:""
  empty-join-list
end
