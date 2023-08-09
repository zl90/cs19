#  _____                _                                      _ 
# |_   _| __ ___  ___  | |_ _ __ __ ___   _____ _ __ ___  __ _| |
#   | || '__/ _ \/ _ \ | __| '__/ _` \ \ / / _ \ '__/ __|/ _` | |
#   | || | |  __/  __/ | |_| | | (_| |\ V /  __/ |  \__ \ (_| | |
#   |_||_|  \___|\___|  \__|_|  \__,_| \_/ \___|_|  |___/\__,_|_|

data BTree<T>:
  | mt
  | node(value :: T, left :: BTree<T>, right :: BTree<T>)
end

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

