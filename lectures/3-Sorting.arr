#### Lecture 3: Sorting
# Write a basic sort function using the template;
fun insert(n :: Number, l :: List<Number>) -> List<Number>:
  cases (List) l:
    | empty => [list: n]
    | link(f, r) => 
      if n < f:
        link(n, l)
      else:
        link(f, insert(n, r))
      end
  end
end

fun my-sort(l :: List<Number>) -> List<Number>:
  cases (List) l:
    | empty => empty
    | link(f, r) => insert(f, sort(r))
  end
end

check:
  insert(2,  [list: 3,4,5])   is [list: 2,3,4,5]
  insert(1,  [list: 0,1,1,2]) is [list: 0,1,1,1,2]
  insert(-1, [list: -2,0,3])  is [list: -2,-1,0,3]
  insert(3,  [list: ])        is [list: 3]
  insert(4,  [list: 1,2,3])   is [list: 1,2,3,4]
  my-sort([list: 3,2,1])        is [list: 1,2,3]
  my-sort([list: 1,2,3])        is [list: 1,2,3] 
  my-sort([list: 4,1,-1])       is [list: -1, 1, 4]
  my-sort([list: 0.1, 0, 0.11]) is [list: 0, 0.1, 0.11]
end