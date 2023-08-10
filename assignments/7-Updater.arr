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
  | cursor(tree :: Tree<A>)
end

fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A>:
  dummy-cursor(tree)
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
