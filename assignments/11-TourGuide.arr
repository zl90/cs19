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

data Edge:
  | edge(place1 :: Place, place2 :: Place, distance :: Number)
end

data Heap:
  | mt
  | node(value :: Edge, left :: Heap, right :: Heap)
end

fun insert(el :: Edge, h :: Heap) -> Heap:
  doc: ```Takes in a PossiblePath elt and a proper Heap h produces
       a proper Heap that has all of the elements of h and elt.```
  cases (Heap) h:
    | mt => node(el, mt, mt)
    | node(v,l,r) =>
      if el.distance > v.distance:
        node(v, insert(el, r), l)
      else:
        node(el, insert(v, r), l)
      end
  end
end

fun remove-min(h :: Heap%(is-node)) -> Heap:
  doc: ```Given a proper, non-empty Heap h, removes its minimum element.```
  amputated = amputate-bottom-left(h)
  cases (Heap) amputated.heap:
    | mt => mt
    | node(v,l,r) =>
      reorder(rebalance(node(amputated.elt, l, r)))
  end
end

fun rebalance(h :: Heap) -> Heap:
  doc: ```Given a Heap h, switches all children along the leftmost path```
  cases (Heap) h:
    | mt => mt
    | node(v,l,r) => node(v,r,rebalance(l))
  end
end

fun get-min(h :: Heap%(is-node)) -> Edge:
  doc: ```Takes in a proper, non-empty Heap h and produces the
       minimum weight in h.```
  cases (Heap) h:
    | mt => raise("Invalid input: empty heap")
    | node(val,_,_) => val
  end
end

data Amputated:
  | elt-and-heap(elt :: Edge, heap :: Heap)
end

fun amputate-bottom-left(h :: Heap%(is-node)) -> Amputated:
  doc: ```Given a Heap h, produes an Amputated that contains the
       bottom-left element of h, and h with the bottom-left element removed.```
  cases (Heap) h:
    | mt => raise("Invalid input: empty heap")
    | node(value, left, right) =>
      cases (Heap) left:
        | mt => elt-and-heap(value, mt)
        | node(_, _, _) =>
          rec-amputated = amputate-bottom-left(left)
          elt-and-heap(rec-amputated.elt,
            node(value, rec-amputated.heap, right))
      end
  end
end

fun reorder(h :: Heap) -> Heap:
  doc: ```Given a Heap h, where only the top node is misplaced,
       produces a Heap with the same elements but in proper order.```
  cases(Heap) h:
    | mt => mt
    | node(val, lh, rh) =>
      cases(Heap) lh:
        | mt => node(val, mt, mt)
        | node(lval, llh, lrh) =>
          cases(Heap) rh:
            | mt =>
              if val.distance < lval.distance:
                node(val, node(lval, mt, mt), mt)
              else:
                node(lval, node(val, mt, mt), mt)
              end
            | node(rval, rlh, rrh) =>
              if lval.distance <= rval.distance:
                if val.distance <= lval.distance:
                  h
                else:
                  node(lval, reorder(node(val, llh, lrh)), rh)
                end
              else:
                if val.distance <= rval.distance:
                  h
                else:
                  node(rval, lh, reorder(node(val, rlh, rrh)))
                end
              end
          end
      end
  end
end

fun dijkstra(start :: Name, graph :: Graph) -> Set<Path>:
  empty-set
end

fun campus-tour(
    tours :: Set<Tour>,
    start-position :: Point,
    campus-data :: Graph) -> Path:
  # Implement me!
  ...
end

check:
  dijkstra("asdfasdf", brown-university-landmarks) is empty-set
end