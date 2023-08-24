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

include string-dict

# testing graphs

q1 = place("1", point(0,0), [set: "2", "3"])
q2 = place("2", point(1,0), [set: "1", "3", "4"])
q3 = place("3", point(0,1), [set: "1", "2", "4"])
q4 = place("4", point(2,0), [set: "2", "3"])
g = to-graph([set: q1, q2, q3, q4])

r1 = place("1", point(0,0), [set: "2", "3", "5"])
r2 = place("2", point(1,1), [set: "1", "3", "4"])
r3 = place("3", point(1, -1), [set: "1", "2", "4"])
r4 = place("4", point(2, 0), [set: "2", "3", "5"])
r5 = place("5", point(3, 0), [set: "4", "1"])
g1 = to-graph([set: r1, r2, r3, r4, r5])

data Edge:
  | edge(place1 :: Place, place2 :: Place, weight :: Number)
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
      if el.weight > v.weight:
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
              if val.weight < lval.weight:
                node(val, node(lval, mt, mt), mt)
              else:
                node(lval, node(val, mt, mt), mt)
              end
            | node(rval, rlh, rrh) =>
              if lval.weight <= rval.weight:
                if val.weight <= lval.weight:
                  h
                else:
                  node(lval, reorder(node(val, llh, lrh)), rh)
                end
              else:
                if val.weight <= rval.weight:
                  h
                else:
                  node(rval, lh, reorder(node(val, rlh, rrh)))
                end
              end
          end
      end
  end
end
 
fun enqueue-neighbors(start:: Name, graph :: Graph, neighbors :: Set<Name>, acc :: Heap, current-weight :: Number, existing-paths :: StringDict<List<Name>>) -> Heap:
  doc: 'Places all the neighbors into a priority queue'
  lst = neighbors.to-list()
  cases (List) lst:
    | empty => acc
    | link(f,r) =>
      if existing-paths.has-key(f):
        enqueue-neighbors(start, graph, list-to-set(r), acc, current-weight, existing-paths)
      else:
        f-node = graph.get(f)
        start-node = graph.get(start)
        new-edge = edge(start-node, f-node, start-node.distance(f-node) + current-weight)
        enqueue-neighbors(start, graph, list-to-set(r), insert(new-edge, acc), current-weight, existing-paths)
      end
  end
end

fun dijkstra-helper(start :: Name, graph :: Graph, paths :: StringDict<List<Name>>, weights :: StringDict<Number>, queue :: Heap) -> Set<Path>:
  doc: "Performs the main algorithm loop as described in this video: https://youtu.be/CerlT7tTZfY"
  current-node = graph.get(start)
  current-weight = cases(Option) weights.get(start):
    | some(a) => a
    | none => 0
  end
  neighbors = current-node.neighbors
  
  # Place all the neighbors into the priority queue
  updated-queue = enqueue-neighbors(start, graph, neighbors, queue, current-weight, paths)
  
  if updated-queue == mt:
    # If there are no more items in the queue, we are done:
    result-list = paths.keys().fold(lam(acc, key): acc + [list: paths.get-value(key)] end, empty)
    result-set = list-to-set(result-list)
    result-set
  else:
    # Handle the minimum item from the priority queue:
    min-item = get-min(updated-queue)
    
    if paths.has-key(min-item.place2.name):
      # If we've already processed the min item, skip it:
      updated-queue2 = remove-min(updated-queue)
      dijkstra-helper(start, graph, paths, weights, updated-queue2)
    else:
      # Process the min item:
      previous-path = cases (Option) paths.get(min-item.place1.name):
        | some(a) => a
        | none => empty
      end
      updated-paths = paths.set(min-item.place2.name, [list: min-item.place2.name] + previous-path)
      updated-weights = weights.set(min-item.place2.name, min-item.weight)
      updated-queue2 = remove-min(updated-queue)

      # Process the next node:
      dijkstra-helper(min-item.place2.name, graph, updated-paths, updated-weights, updated-queue2)
    end
  end
end

fun dijkstra(start :: Name, graph :: Graph) -> Set<Path>:
  nodes = graph.names()
  queue = mt
  if nodes.member(start):
    dijkstra-helper(start, graph, [string-dict: start, [list: start]], [string-dict: start, 0 ], queue)
  else:
    empty-set
  end
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
  dijkstra("asdfasdf", g) is empty-set
  dijkstra("1", g) is [set: [list: "1"], [list: "3", "1"], [list: "2", "1"], [list: "4", "2", "1"]]
  dijkstra("1", g1) is [list-set:[list:"5", "1"], [list:"3", "1"], [list:"4", "5", "1"], [list:"1"], [list:"2", "1"]]
end