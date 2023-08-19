# Brown University - Accelerated Intro to CS class (CS019).

I'm taking this class for fun and to become a better engineer. I work professionally with Typescript, so it will be interesting to see if this helps me learn the Pyret language.

This course uses the book DCIC (https://dcic-world.org/2023-02-21/index.html), which I'll also be working through.

### DCIC book: Chapter 3 - Basic Data

**3.4.4** Asking Multiple Questions

- Very interesting exercise which demonstrates how conditionals and boolean statements can be used to do the same thing, but one is vastly superior in terms of readability:

```
# Exercise: skateboarding ad
# (using only conditional statements)
fun show_ad_conditionals(age :: Number, hair_color :: String) -> Boolean:
  if (age <= 18):
    if (age >= 9):
      if (hair_color == 'pink'):
        true
      else if (hair_color == 'purple'):
        true
      else:
        false
      end
    else:
      false
    end
  else:
    false
  end
where:
  show_ad_conditionals(7, 'red') is false
  show_ad_conditionals(10, 'pink') is true
  show_ad_conditionals(10, 'red') is false
  show_ad_conditionals(18, 'purple') is true
end

# Exercise: skateboarding ad
# (using only boolean operations)
fun show_ad_booleans(age :: Number, hair_color :: String) -> Boolean:
  (age >= 9) and (age <= 18) and ((hair_color == 'pink') or (hair_color == 'purple'))
where:
  show_ad_conditionals(7, 'red') is false
  show_ad_conditionals(10, 'pink') is true
  show_ad_conditionals(10, 'red') is false
  show_ad_conditionals(18, 'purple') is true
end
```

- Pyret uses the `not` boolean operation instead of the bang operator `!` for negating booleans.

#### Takeaways

- Didn't learn much new things in terms of computer science but did learn the basic syntax of Pyret, looks similar to OCaml.
- Learned how boolean operations and conditionals can be used to achieve the same logic.
- Learned how unit tests are done inside the function, very impressive and simple way to introduce TDD!

### Workshop 6

Notes:

- Recursion cheat sheet was really helpful!
  1.  What is the simplest case? (base case)
  2.  What is the relationship between the current case and the next smallest case?
- You can return stuff like `1 + my_func()` etc, this avoids the need to use a counter variable. This kinda connected the synapses in my brain, I finally realised how recursion works. Need to play around with this more obviously.
- Learnt a few List functions like `map`, `member`, `distinct` and `filter`. Really nothing new since javascript has equivalent functions.

### Assignment 1 - DocDiff

There's **a lot** for me to learn here, particularly brushing up on basic vector stuff like Dot Product, Magnitude and Normalisation.

**Dot Product**: Sum of the products of the corresponding entries of two sequences of numbers. Easy. In this case, the two sequences of numbers are the frequencies of words.

**Normalisation**: Basically converting to a ratio between 0 and 1. In this case, if the Document Difference is 0.99 that means they are very similar, and if it's 0.04 then they are not similar.

**Magnitude**: Magnitude of a dot product is given by it's square root? The assignment is unclear about this.

Learned about the **Document Distance problem** from this lecture: https://youtu.be/Zc54gFhdpLA?t=2004 - Example: if google wants to catalog a html document but first needs to check if it has the same document stored already, they could check this by calculating the document distance between the document and google's cataloged documents. - Could also be used in anti-plagiarism technology.

Things I'll need to do:

1. Compute word frequencies
   - Get a list of distinct words contained in both lists -> use `distinct` function on both lists combined (potentially use `link` to combine the lists).
   - Use separate lists to hold the vectors, basing the frequencies on the distinct list obtained above.
1. Compute the Dot Product
1. Normalise the Dot Product

#### Things I learned:

- In Pyret you can use `fold2` to iterate over two lists with an accumulator.
- This assignment spec was a refresher for me on basic Vectors, Dot Products, Vector Distance and Normalisation.
- TDD is surprisingly fun. Pyret makes it really easy by letting you write tests inside your functions.
- Learned what a lambda function is: since I work in Typescript I had always known them as anonymous functions.
- Converting mathematical expressions to code using builtins from the Pyret library.

### Workshop 3

Introducing the table data structure:
This is essentially an array of rows. The rows themselves are objects in the form:

```
{
	"name": "Fred",
	"age": 34,
	"married": true,
}

// The columns can be accessed like this:
my_row[col_name]
```

The rows themselves are extracted from the table like so:
`my_table.row-n(0)`

### Lab 1: Higher-Order Functions

Higher order functions are functions that either consume another function as input or return another function.

#### Takeaways

- Writing a function that requires iteration **without** using `map` or `for` loop was pretty tricky for me. I knew the problem required recursion, but figuring out what to actually return was the difficult part. It wasn't until I slowed down and really thought "Okay, what do I actually need to return? I need to return a list, and I currently have the first element and a link to the rest of the list... maybe if I return a list with the first element modified and THEN call recursion on the rest of the list!". This was a big learning moment for me, as I've never used recursion before.
- Learned about Type Parameters. Still don't fully understand them, but I used them to implement my own map function. I couldn't find anything about them in the DCIC book but they are present in the language documentation. These are called **Generics** in Typescript! I've never used them before but I'm quickly getting used to them.
- I learned that in Pyret you can nest the `cases` operation to iterate over two (or more) data structures at the same time. Without this, implementing the `map2` function from scratch would have been impossible.

### Assignment 2: Nile

#### Challenges faced

- Overall this was a huge spike in difficulty compared to the last assignment, primarily due to all of the type conversion/data mapping needed to get the job done.
- Combining lists using recursion was tricky for me. I first tried to push the elements into a temporary list, but the assignment doesn't allow using state like that, so I had to find another solution.
- Getting the second part to work was very difficult. I eventually realised I needed to use the function I created in part 1 to get the job done. Thankfully this assignment isn't measured on performance/efficiency, because my solution was definitely not performant.

#### Things I learned

- To combine lists using recursion you can use the `+` operator on lists. Example:

```
fun combine-files(lst :: List<File>) -> List<String>:
  doc: 'Combines a list of files into one big list of all their content'
  cases (List) lst:
    | empty => empty
    | link(first, rest) => first.content + combine-files(rest)
  end
end
```

- Through trial and error I figured out how to write my own `member` function, which I named as `contains`.

### Lecture 3: Sorting

Question: What would the template look like for a list of numbers?
My guess:

```
cases (List<Number>):
  | empty
  | link(val :: Number, rest :: List<Number>)
end
```

Professor K's anwer:

```
fun flon(l :: List<Number>) -> Any
  | empty => ...
  | link(f :: Number, r :: List<Number>) => ...
end
```

**What is a template?**

- An attempt to extract as much code as we can out of the data definition, even before we know what problem we're trying to solve.
- So the data definition can give us a bunch of information about how to solve issues surrounding the data type, and how to construct a function around the data type.
- The template tells you "These are the pieces you can use to assemble a solution".

This lecture blows my mind. I will need to watch this two or three times.

**Code Drills**

- I drilled the 'insertion sort' coding exercise multiple times to make sure it sticks.
- Doing this really helps me understand not only Pyret functions but Recursion in general.
- The way Professor K breaks down each step in the process is genius!

**The Pyret problem solving process**

At each step, assess the following:

- What are the possible cases? (ie: the empty/base case? The next item in the list?)
- What do I need to return? (Look at your function template, this is free information!)
- What do I currently have access to? (Function arguments? First item in the list? The rest of the list?)
- How do I take what I already have and turn it into the correct return type?

### Assignment 3: Testing Oracle

#### Challenges faced

- The most difficult part of this assignment was accounting for all the edge cases when sorting a list of objects. There could be many different permutations of different sorted lists which are all valid. I believe I caught them all by drawing out many examples on paper.

#### Things I learned

- I learned what a testing oracle is (testing whether the output has the right relationship with the input).
- I also learned what Property Based Testing is (eg: generating random input data to test a wide range of properties of the code, great for finding edge cases).
- I'm really solidifying my ability to use recursion in Pyret.

### Lecture 4: Big O

**Code kata for later:** Write the `length()` function using recursion in Pyret.

### Assignment 4: Data Scripting

#### Challenges faced

- Task 3: Adding machine. This was difficult because I had to use two accumulators in a recursive fold function. This is something I hadn't done before. After lots of trial and error, it occurred to me that I could use a second accumulator to keep track of an index needed for inserting an element into a list. In the future I will be re-attempting this question, because it didn't feel right to be inserting values into a list. A large part of Pyret is about breaking away from the imperative programming style and ideally not mutating state (which I technically didn't), and I believe this challenge is doable without using the `set()` function in Pyret.
- Optimizing these algorithms isn't within my capabilities yet, I just don't have enough knowledge of the Pyret programming style/methodology. All my algorithms for this assignment have quadratic time complexity. Conversely, I could do most of these in O(n) using an imperative style in Typescript.
- Task 7: Earthquake Monitoring. This was also difficult because it required me to use two accumulators and write my own fold function, however I made the mistake of rushing into the implementation without considering what data type I would need to use for my second accumulator, which led me down a wild goose chase, only to realise I wasn't accumulating with all the data I needed.

#### Things I learned

- I need to spend more time planning my implementation, especially when it comes to challenges with tricky/custom data types which need to be managed. Taking extra time to plan can save a lot of wasted time later on.
- Thinking about how the data could be _reshaped_ or _cleaned_ was really helpful, especially for code readability and helping me figure out the problem.

### Assignment 5: Oracle

#### Things I learned

- This assignment further solidified my knowledge of _property based testing_. I learned to carefully consider what the _properties_ of the output data should be, rather than the _content_ of the output data. For example: the output list should contain no duplicate items, the output list should be the same length as the input list, and all the values in the output list should be in the correct range.
- Gained more experience with using _testing oracles_.

### Assignment 6: Filesystem

#### Challenges faced

- The final task `fynd` was pretty difficult. It required me to recurse over an n-ary tree while checking both the value in the node and whether the value existed deeper in the tree. Additionally, I had to keep track of the current path I was at in the "filesystem" and simulteneously accumulate a list of filepaths which led to a specified filename. This was a lot to keep track of, and I wasn't able to do it using the function signature given in the assignment spec, so I added a helper function which allowed me to do everything including checking the value, recursing on child nodes, keeping track of the current filepath and accumulating a list of filepaths.

#### Things I learned

- I learned how to traverse an n-ary tree using recursion. It was a lot easier than I expected.
- I also gained some basic insight into how filesystems work under the hood.

### Assignment 7: Updater

This assignment teaches you how to make *atomic* updates to a tree with *arbitrary degree* (that is, each node in the tree can have any number of children). Atomic updates are selective updates made to a specific node/subtree, without having to replace the entire tree. This is done by creating a datatype that can act as a cursor, or pointer, to a specific subtree. This means we can update a tree in constant time, given a cursor. I had a tonne of fun with this assignment.

#### Challenges faced

- The biggest challenge of this assignment was (once again) choosing the correct properties to use in the main data type: the Cursor. I got all the way to the last few tasks before realising I needed an extra property in the Cursor to hold its sibling index. Without this property my functions would work in linear time, but that wasn't good enough to satisfy the assignment requirements, so I had to refactor the entire program (including the tests) to work with the new property.

### Things I learned

- How to think about trees: in terms of cursors.
- How to update a subtree within a tree in constant time.

### Assignment 9: JoinList

#### Challenges faced

- The final task `j-sort` was extremely difficult. It required us to sort a tree-like data structure which was designed to simulate a distributed data set. I had to seek help to finish this task, unfortunately. It required Pyret syntax knowledge that I simply didn't have (using `else` in a `cases` statement). Also, it required two steps: firstly to sort the split data sets, and then to combine the sorted sets in order. I wasn't able to figure this out by myself. I will be coming back to this assignment to have another attempt at it later because I really want to solidify this knowledge. I'm down, but not out!
- 
### List of assignments I will be re-doing

- Assignment 2: Nile. I struggled alot with this assignment due to my lack of Pyret knowledge and my inexperience with using recursion. Now that I have more experience I'll be having another attempt.
- Assignment 8: Continued Fractions. This assignment was really difficult for me as I don't have a mathematical background. I'm definitely going to attack it again after I complete the rest of the course.
- Assignment 10: MapReduce. I wasn't able to complete the final tasks due to the way I wrote my `shuffle-helper` function. I couldn't see a way to make this generic for every possible reducer input. But I know I can figure it out, I'll be trying again later.
