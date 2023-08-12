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
  | cursor(tree :: Tree<A>, parent :: Cursor, index :: Number)
end

fun find-cursor-in-children<A>(trees :: List<Tree<A>>, pred :: (A -> Boolean), parent :: Cursor, index :: Number) -> Cursor<A>:
  doc: 'Finds the cursor in a list of trees where the predicate is true (depth first)'
  cases (List) trees:
    | empty => mt-cursor
    | link(f, r) =>
      cases (Tree) f:
        | mt => mt-cursor
        | node(value, children) =>
          if pred(value):
            cursor(f, parent, index)
          else if children.length() > 0:
            result = find-cursor-in-children(children, pred, cursor(f, parent, index), 0)
            if not(result == mt-cursor):
              result
            else:
              find-cursor-in-children(r, pred, parent, index + 1)
            end
          else:
            find-cursor-in-children(r, pred, parent, index + 1)
          end
      end
  end
end

fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A>:
  doc: 'Finds the cursor in the tree where the predicate is true (depth first)'
  cases (Tree) tree:
    | mt => mt-cursor
    | node(value, children) =>
      if pred(value):
        cursor(tree, mt-cursor, 0)
      else:
        result = find-cursor-in-children(children, pred, cursor(tree, mt-cursor, 0), 0)
        if result == mt-cursor:
          raise("Could not find node matching predicate")
        else:
          result
        end
      end
  end
where:
  find-cursor(test-tree, lam(x): x == 1 end) is cursor(test-tree, mt-cursor, 0)
  find-cursor(test-tree, lam(x): x == 3 end) is cursor(node(3,[list:node(3.5,[list:])]),cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  find-cursor(test-tree, lam(x): x == 6 end) is cursor(node(6,[list:node(7,[list:])]),cursor(node(5,[list:node(6,[list:node(7,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),1),0)
  find-cursor(test-tree, lam(x): x == 88 end) raises "Could not find node matching predicate"
end

fun up<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: 'Returns the parent of the input cursor'
  if cur == mt-cursor:
    raise("Invalid movement")
  else:
    cur.parent
  end
where:
  up(mt-cursor) raises "Invalid movement"
  up(cursor(test-tree, mt-cursor, 0)) is mt-cursor
end

fun left<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: 'Returns the cursor to the left of the input cursor `cur`'
  parent = cur.parent
  if parent == mt-cursor:
    raise("Invalid movement")
  else:
    siblings = parent.tree.children
    index = cur.index
    if (siblings == mt-cursor) or (index == 0) or (siblings.length() <= 1):
      raise("Invalid movement")
    else:
      cursor(siblings.get(index - 1), parent, index - 1)
    end
  end
where:
  cursor5 = cursor(node(5,[list:node(6,[list:node(7,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),1)
  cursor2 = cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0)
    cursor0 = cursor(mt, mt-cursor,0)
  left(cursor5) is cursor2
  left(cursor2) raises "Invalid movement"
  left(cursor0) raises "Invalid movement"
end

fun right<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: 'Returns the cursor to the right of the input cursor `cur`'
   parent = cur.parent
  if parent == mt-cursor:
    raise("Invalid movement")
  else:
    siblings = parent.tree.children
    index = cur.index
    if (siblings == mt-cursor) or ((index + 1) >= siblings.length()) or (siblings.length() <= 1):
      raise("Invalid movement")
    else:
      cursor(siblings.get(index + 1), parent, index + 1)
    end
  end
where:
    cursor5 = cursor(node(5,[list:node(6,[list:node(7,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),1)
  cursor2 = cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0)
    cursor0 = cursor(mt, mt-cursor,0)
  right(cursor2) is cursor5
  right(cursor5) raises "Invalid movement"
  right(cursor0) raises "Invalid movement"
end

fun down<A>(cur :: Cursor<A>, child-index :: Number ) -> Cursor<A>:
  doc: 'Returns the child of the input cursor at the specified index'
  if (cur.tree.children == empty) or (cur.tree.children.get(child-index) == "too large") or (cur.tree.children.get(child-index) == "invalid argument"):
    raise("Invalid movement")
  else:
    cursor(cur.tree.children.get(child-index), cur, child-index)
  end
  where:
  cursor2 = cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0)
  cursor3 = cursor(node(3,[list:node(3.5,[list:])]),cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  down(cursor2, 1) is cursor3
  down(cursor(node(5, empty), mt-cursor, 0), 2) raises "Invalid movement"
end

fun update<A>(cur :: Cursor<A>, func :: (Tree<A> -> Tree<A>)) -> Cursor<A>:
  doc: 'Updates an input cursor `cur` by applying the functor `func` to the tree in the input cursor'
  cursor(func(cur.tree), cur.parent, cur.index)
where:
  cursor3 = cursor(node(3,[list:node(3.5,[list:])]),cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  update(cursor(test-tree, mt-cursor, 0), lam(x): mt end) is cursor(mt, mt-cursor, 0)
  update(cursor3, lam(x): mt end) is cursor(mt, cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  update(cursor3, lam(x): node(3,[list:node(3.5,[list:node(45, [list:])])]) end) is cursor(node(3,[list:node(3.5,[list:node(45, [list:])])]), cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
end

fun clean-mt-nodes-from-children<A>(trees :: List<Tree<A>>, acc :: List<Tree<A>>) -> List<Tree<A>>:
  doc: 'Prunes all `mt` nodes from a list of trees'
  cases (List) trees:
    | empty => acc
    | link(f, r) =>
      cases (Tree) f:
        | mt => clean-mt-nodes-from-children(r, acc)
        | node(value, children) =>
            clean-mt-nodes-from-children(r, acc + [list: node(value, clean-mt-nodes-from-children(children, empty))])
      end
  end
end

fun to-tree<A>( cur :: Cursor<A> ) -> Tree<A>:
  doc: 'Converts a cursor to a tree'
  if cur.tree == mt:
    mt
  else:
    node(cur.tree.value, clean-mt-nodes-from-children(cur.tree.children, empty))
  end
where:
  cursor3 = cursor(node(3,[list:node(3.5,[list:node(45, [list:])])]), cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  cursor3-mt = cursor(node(3,[list:node(3.5,[list:node(45, [list: mt])])]), cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  to-tree(cursor3) is node(3,[list:node(3.5,[list:node(45, [list:])])])
  to-tree(cursor3-mt) is node(3,[list:node(3.5,[list:node(45, [list:])])])
  to-tree(cursor(mt, mt-cursor, 0)) is mt

end

fun get-node-val<A>(cur :: Cursor<A>) -> Option<A>: 
  doc: 'Extracts the value of the node at the cursor'
  ask:
    | cur.tree == mt then: none
    | otherwise: some(cur.tree.value)
  end
where:
  cursor6 = cursor(node(6,[list:node(7,[list:])]),cursor(node(5,[list:node(6,[list:node(7,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),1),0)
  cursor3 = cursor(node(3,[list:node(3.5,[list:])]),cursor(node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),cursor(node(1,[list:node(2,[list:node(4,[list:]),node(3,[list:node(3.5,[list:])])]),node(5,[list:node(6,[list:node(7,[list:])])])]),mt-cursor,0),0),1)
  cursor0 = cursor(mt, mt-cursor,0)
  cursor1 = cursor(test-tree, mt-cursor,0)
  get-node-val(cursor6) is some(6)
  get-node-val(cursor0) is none
  get-node-val(cursor1) is some(1)
  get-node-val(cursor3) is some(3)
end
