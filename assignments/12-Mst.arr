# CSCI0190 (Fall 2018)
provide *
provide-types *

import shared-gdrive("mst-support.arr", 
  "1NWo987lW1EmeT5bU6qC1asG_K4lq8KBr") as S

# Imports below

# Imports above
type Graph = S.Graph
type Edge = S.Edge

edge = S.edge

#####################################
### DO NOT CHANGE ABOVE THIS LINE ###
#####################################

# Test graphs:
elt1 = edge('a', 'b', 4)
elt2 = edge('a', 'c', 6)
elt3 = edge('d', 'a', 1)
elt4 = edge('b', 'd', 2)
elt5 = edge('b', 'e', 3)
elt6 = edge('d', 'e', 4)
g1 = [list: elt1, elt2, elt3, elt4, elt5, elt6]

g2 = empty

g3 = [list: edge('a', 'b', 45)]

# Union Find implementation:

data Element<T>:
  | elt(val :: T, ref parent :: Option<Element>)
end

fun index(l, e): l.get(e) end

type Sets = List<Element>

fun is-same-element(e1, e2): e1.val <=> e2.val end

fun is-in-same-set(e1 :: Element, e2 :: Element) -> Boolean:
  s1 = fynd(e1)
  s2 = fynd(e2)
  identical(s1, s2)
end

fun fynd(e :: Element) -> Element:
  cases (Option) e!parent:
    | none => e
    | some(parent) => fynd(parent)
  end
end
  
fun union(e1 :: Element, e2 :: Element):
  s1 = fynd(e1)
  s2 = fynd(e2)
  if identical(s1, s2):
    s1
  else:
    update-set-with(s1, s2)
  end
end

fun update-set-with(child :: Element, parent :: Element):
  child!{parent: some(parent)}
end

# MST Functions

fun kruskal-helper(elements :: List<Element>, edges :: List<Edge>, acc :: List<Edge>) -> List<Edge>:
  cases (List) edges:
    | empty => acc
    | link(f,r) =>
      elt-a = cases (Option) elements.find(lam(x): x.val == f.a end):
        | none => raise("Should never be empty")
        | some(e) => e
      end
      elt-b = cases (Option) elements.find(lam(x): x.val == f.b end):
        | none => raise("Should never be empty")
        | some(e) => e
      end
      if is-in-same-set(elt-a, elt-b):
        kruskal-helper(elements, r, acc)
      else:
        block:
          union(elt-a, elt-b)
          kruskal-helper(elements, r, acc + [list: f])
        end
      end
  end
end

fun exists-in(element :: String, lst :: List<Element>) -> Boolean:
  cases (List) lst:
    | empty => false
    | link(f,r) =>
      if element == f.val:
        true
      else:
        exists-in(element, r)
      end
  end
end

fun mst-kruskal(graph :: Graph) -> List<Edge>:
  doc: "Uses kruskals algorithm to find the minimum spanning tree for a graph"
  if graph == empty:
    empty
  else:
  sorted-edges = graph.sort-by(lam(a,b): a.weight < b.weight end, lam(a,b): (((a.a == b.a) and (a.b == b.b)) or ((a.a == b.b) and (a.b == b.a))) and (a.weight == b.weight) end)
  elements = fold(lam(acc, element):
        a-is-member = exists-in(element.a, acc)
        b-is-member = exists-in(element.b, acc)
        if not(a-is-member) and not(b-is-member):
          acc + [list: elt(element.a, none), elt(element.b, none)]
        else if not(a-is-member):
          acc + [list: elt(element.a, none)]
        else if not(b-is-member):
          acc + [list: elt(element.b, none)]
        else:
          acc
        end
      end, empty, graph)
    kruskal-helper(elements, sorted-edges, empty)
  end
where:
  mst-kruskal(g2) is empty
  mst-kruskal(g3) is [list: edge('a', 'b', 45)]
  mst-kruskal(g1) is [list: elt3, elt4, elt5, elt2]
end

fun mst-prim(graph :: Graph) -> List<Edge>:
  ...
end

# Oracle Functions

fun generate-input(num-vertices :: Number) -> Graph:
  ...
end

fun mst-cmp(
    graph :: Graph,
    mst-alg-a :: (Graph -> List<Edge>),
    mst-alg-b :: (Graph -> List<Edge>))
  -> Boolean:
  ...
end
  
fun sort-o-cle(
    mst-alg-a :: (Graph -> List<Edge>),
    mst-alg-b :: (Graph -> List<Edge>))
  -> Boolean:
  ...
end

check:
  s0 = map(elt(_, none), [list: 0,1,2,3,4,5,6,7])
  union(index(s0, 0), index(s0, 2))
  s1 = s0
  union(index(s1, 0), index(s1, 3))
  s2 = s0
  union(index(s2, 3), index(s2, 5))
  s3 = s0
  is-same-element(fynd(index(s0, 0)), fynd(index(s0, 5))) is true
  is-same-element(fynd(index(s0, 2)), fynd(index(s0, 5))) is true
  is-same-element(fynd(index(s0, 3)), fynd(index(s0, 5))) is true
  is-same-element(fynd(index(s0, 5)), fynd(index(s0, 5))) is true
  is-same-element(fynd(index(s0, 7)), fynd(index(s0, 7))) is true
end