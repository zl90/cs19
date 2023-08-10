#  _____                _                                      _ 
# |_   _| __ ___  ___  | |_ _ __ __ ___   _____ _ __ ___  __ _| |
#   | || '__/ _ \/ _ \ | __| '__/ _` \ \ / / _ \ '__/ __|/ _` | |
#   | || | |  __/  __/ | |_| | | (_| |\ V /  __/ |  \__ \ (_| | |
#   |_||_|  \___|\___|  \__|_|  \__,_| \_/ \___|_|  |___/\__,_|_|

data BTree<T>:
  | mt
  | node(value :: T, left :: BTree<T>, right :: BTree<T>)
end

# Example tree:
#
#       a
#      / \
#     b   c
#    / \
#   d   e

testTree = node('a', node('b', node('d', mt, mt), node('e', mt, mt)), node('c', mt, mt))

# Task: Implement and write test cases for the following functions:
fun btree-in-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via an in-order traversal"
  cases (BTree) tree:
    | mt => empty
    | node(value, left, right) =>
      btree-in-order(left) + [list: value] + btree-in-order(right)
  end
where:
  btree-in-order(testTree) is [list: 'd', 'b', 'e', 'a', 'c']
end

fun btree-pre-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via a pre-order traversal"
  cases (BTree) tree:
    | mt => empty
    | node(value, left, right) =>
      [list: value] + btree-pre-order(left) + btree-pre-order(right)
  end
where:
  btree-pre-order(testTree) is [list: 'a', 'b', 'd', 'e', 'c']
end

fun btree-post-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via a post-order traversal"
  cases (BTree) tree:
    | mt => empty
    | node(value, left, right) =>
      btree-post-order(left) + btree-post-order(right) + [list: value] 
  end
where:
  btree-post-order(testTree) is [list: 'd', 'e', 'b', 'c', 'a']
end

# Task: Write the function signature for each of the following functions:

# btree-map -- like `map` on `Lists`, but for each value in a `BTree`
# Answer:
fun btree-map<A, B>(functor :: (A -> B), tree :: BTree<A>) -> BTree<B>:
  doc: 'Recursively applies `functor` to the value of every node contained in tree'
  cases (BTree) tree:
    | mt => mt
    | node(value, left, right) =>
      node(functor(value), btree-map(functor, left), btree-map(functor, right))
  end
where:
  btree-map(lam(x): 'a' end, testTree) is node('a', node('a', node('a', mt, mt), node('a', mt, mt)), node('a', mt, mt))
end

# btree-filter -- like `filter` on `Lists`, but for each value in a `BTree`
# Answer:
fun btree-filter<A>(predicate :: (A -> Boolean), tree :: BTree<A>) -> BTree<A>:
  doc: 'Recursively applies `predicate` to the value of every node and leaf in tree. If `predicate` returns false for a given node or leaf, that node and all of its children should be removed from the tree; otherwise, the returned BTree<A> should contain the given node'
  cases (BTree) tree:
    | mt => mt
    | node(value, left, right) =>
      if predicate(value):
        node(value, btree-filter(predicate, left), btree-filter(predicate, right))
      else:
        mt
      end
  end
where:
  btree-filter(lam(x): not(x == 'b') end, testTree) is node('a', mt, node('c', mt, mt))
end

# btree-fold -- like `fold` on `List`s, but for each value in a `Btree`
# Answer:
fun btree-fold<A, B>(folder :: (B, A -> B), traversal :: (BTree<A> -> List<A>), acc :: B, tree :: BTree<A>) -> B:
  doc: 'Uses `traversal` to generate a List<A> of the values in tree in the order that the should be folded, then applies the `folder` function over the generated List<A>, starting with the initial value `acc`'
  lst = traversal(tree)
  fold(folder, acc, lst)
where:
  btree-fold(lam(acc, item): acc + [list: string-to-upper(item)] end, btree-in-order, empty, testTree) is [list: 'D', 'B', 'E', 'A', 'C']
end




