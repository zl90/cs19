# CSCI0190 (Fall 2018)

provide *
provide-types *

import brown-university-landmarks, brown-university-tours from shared-gdrive(
  "tour-guide-data.arr", 
  "1u_UPQ0Z2N867XQQqJkGDo5MFFS97yysX")

include shared-gdrive(
  "tour-guide-definitions.arr",
  "1hVLncE2-w5JjhSucmLJdVaoxNWEylPjX")

## DO NOT EDIT ABOVE THIS LINE

## Data:

# data Path:
#   | List<Name>
# end

# data Graph:
#   | some form of list of Places
# end

# data Point:
#   | point(x :: Number, y :: Number)
# end

# data Place:
#   | place(
#       name :: Name,
#       position :: Point,
#       neighbors :: Set<Name>)
# end
#
# NOTE: Place includes the `.distance()` method, which calculates the manhattan distance between two
# places or two points

data Queue<T>:
  | queue(tail :: List<T>, head :: List<T>)
end

data Response<T>:
  | elt-and-q(e :: T, r :: Queue<T>)
end

mt-q :: Queue = queue(empty, empty)

fun enqueue<T>(q :: Queue<T>, e :: T) -> Queue<T>:
  queue(link(e, q.tail), q.head)
end

fun dequeue<T>(q :: Queue<T>) -> Response<T>:
  cases (List) q.head:
    | empty =>
      new-head = q.tail.reverse()
      elt-and-q(new-head.first,
        queue(empty, new-head.rest))
    | link(f, r) =>
      elt-and-q(f,
        queue(q.tail, r))
  end
end

fun dijkstra(start :: Name, graph :: Graph) -> Set<Path>:
  q = mt-q
  empty-set
end

fun campus-tour(
    tours :: Set<Tour>,
    start-position :: Point,
    campus-data :: Graph) -> Path:
  # Implement me!
  ...
end
