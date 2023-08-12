# CSCI0190 (Fall 2018)
provide *
provide-types *

import shared-gdrive("updater-types.arr", "1h-qMLhuD-flbIdVmNCZ4mTOpmd6lF_UJ") 
as support

type Tree = support.Tree
mt = support.mt
node = support.node

# test tree:
#        1
#       / \
#      2   5
#     / \   \
#    4   3   6 
#         \   \
#         3.5  7

test-tree = 
  node(1, [list:
      node(2, [list:
          node(4, empty),
          node(3, [list: 
              node(3.5, empty)])]),
      node(5, [list:
          node(6, [list: 
              node(7, empty)])])])

data Cursor<A>:
  | mt-cursor
  | cursor(tree :: Tree<A>, parent :: Cursor)
end

fun find-cursor-in-children<A>(trees :: List<Tree<A>>, pred :: (A -> Boolean), parent :: Cursor) -> Cursor<A>:
  cases (List) trees:
    | empty => mt-cursor
    | link(f, r) =>
      cases (Tree) f:
        | mt => mt-cursor
        | node(value, children) =>
          if pred(value):
            cursor(f, parent)
          else if children.length() > 0:
            result = find-cursor-in-children(children, pred, cursor(f, parent))
            if not(result == mt-cursor):
              result
            else:
              find-cursor-in-children(r, pred, parent)
            end
          else:
            find-cursor-in-children(r, pred, parent)
          end
      end
  end
end

fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A>:
  cases (Tree) tree:
    | mt => mt-cursor
    | node(value, children) =>
      if pred(value):
        cursor(tree, mt-cursor)
      else:
        result = find-cursor-in-children(children, pred, cursor(tree, mt-cursor))
        if result == mt-cursor:
          raise("Could not find node matching predicate")
        else:
          result
        end
      end
  end
where:
  find-cursor(test-tree, lam(x): x == 1 end) is cursor(test-tree, mt-cursor)
  find-cursor(test-tree, lam(x): x == 3 end) is cursor(node(3,[list:node(3.5,[list:])]),cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor)))
  find-cursor(test-tree, lam(x): x == 6 end) is cursor(node(6,[list:node(7,[list:])]),cursor(node(5,[list:node(6,[list:node(7,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor)))
  find-cursor(test-tree, lam(x): x == 88 end) raises "Could not find node matching predicate"
end

fun up<A>(cur :: Cursor<A>) -> Cursor<A>:
  cur
end

fun left<A>(cur :: Cursor<A>) -> Cursor<A>:
  cur
end

fun right<A>(cur :: Cursor<A>) -> Cursor<A>:
  cur
end

fun down<A>(cur :: Cursor<A>, child-index :: Number ) -> Cursor<A>:
  cur
end

fun update<A>(cur :: Cursor<A>, func :: (Tree<A> -> Tree<A>)) -> Cursor<A>:
  cur
end

fun to-tree<A>( cur :: Cursor<A> ) -> Tree<A>:
  cur.tree
end

fun get-node-val<A>(cur :: Cursor<A>) -> Option<A>: 
  none
end
