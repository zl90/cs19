#### Lab 2: Big O

## Task: Determine the minimum possible runtime complexity to sum all elements in a list of integers of size n.
# Answer: If the elements are all the same value, and their value is known: O(1)
# Otherwise O(n) because each value must be viewed at least once.

## Task: Determine the minimum possible runtime complexity to sum all elements in a list of integers of size n and a list of size m.
# Answer: again, O(1) but only if all the elements in m and n are the same and their values are known.
# Otherwise O(MAX(n, m)) because you can do this imperatively by iterating through both at the same time using two pointers, and you'll only need to iterate MAX(n, m) times.

## Task: Consider two lists of integers, of size m and n. Determine the minimum possible runtime complexity to find the sum of all possible products between an element from the first list and an element from the second list.
# Answer: The best I can come up with is O(n*m) because by the nature of the problem you must perform an operation on every element in n to every element in m.

## Task: What if in the previous problem instead of taking the product of the element a from the first list and b from the second list, we used a^b? Would the minimum possible runtime complexity change?
# Answer: No, changing the operation from * to ^ doesn't affect the runtime complexity.

## Task: Perform and write out a Big O analysis like above for the following implementation of the unique function from your summer work:
fun my-reverse<elt>(loa :: List<elt>) -> List<elt>:
    doc: "outputs input list with elements in reverse order"
    l.foldl(lam(acc, cur): link(cur, acc) end, empty, loa)
where:
    my-reverse(empty) is empty
    my-reverse([list: 1]) is [list: 1]
    my-reverse([list: 1, 2]) is [list: 2, 1]
    my-reverse([list: 1, 2, 1]) is [list: 1, 2, 1]
    my-reverse([list: 2, 1, 1, 2, 3]) is [list: 3, 2, 1, 1, 2]
    my-reverse([list: 1, 2, 3, 4, 5]) is [list: 5, 4, 3, 2, 1]
end

fun unique<elt>(loa :: List<elt>) -> List<elt>:
    doc: "implementation of unique using hofs, outputs input list with no duplicate elements"
    unique-builder = lam(acc, cur):
        if not(l.member(acc, cur)):
            link(cur, acc)
        else:
            acc
        end
    end
    my-reverse(l.foldl(unique-builder, empty, loa))
where:
    unique(empty) is empty
    unique([list: 1, 2]) is [list: 1, 2]
    unique([list: 1, 2, 2, 1]) is [list: 1, 2]
    unique([list: 3, 3, 1, 3]) is [list: 3, 1]
    unique([list: 1, 2, 3, 4, 1, 2]) is [list: 1, 2, 3, 4]
    unique([list: 3, 3, 3, 3, 3]) is [list: 3]
end

# Answer: The `my-reverse` algorithm runs in O(n), where n represents the length of the input list, `loa`.
# It performs a recursive `fold` operation which recurses through every element in the list, and accumulates each value into the output list, in reverse order.
# No value of `loa` will be skipped, since the function handles only one element at a time: the list will be passed through with every element from index 0 to index n.
# The `unique` algorithm runs in O(n^2), where n represents the length of the input list, `loa`.
# It performs a recursive `fold` operation which recurses through every element in the list, accumulating all unique values into the output list.
# The fold operation itself is in O(n) runtime, because every element in the list is recursed over.
# However, to determine which elements are unique, the fold operation must run the folder lambda function, named `unique-builder`.
# `unique-builder` runs in O(n) because it checks each value in the accumulator, which approaches size n in the worst case scenario (if all values in `loa` are unique).
# Since `unique-builder` is called once per every element in `loa`, we can say that `unique` runs in O(n * n), which is O(n^2).
# `unique` also calls the `my-reverse` function as the last step, which is O(n), however this does not affect the overall runtime because O((n^2) + n) is bounded by O(n^2).