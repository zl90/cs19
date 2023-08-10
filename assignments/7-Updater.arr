# CSCI0190 (Fall 2018)
provide *
provide-types *

import shared-gdrive("updater-types.arr", "1h-qMLhuD-flbIdVmNCZ4mTOpmd6lF_UJ") 
as support

type Tree = support.Tree
mt = support.mt
node = support.node

# You will come up with a Cursor definition, which may have more than
# one variant, and can have whatever fields you need

# "dummy-cursor" doesn't mean anything, and you should replace it
# with your own definition
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
