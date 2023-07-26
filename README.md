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
- I learned that in Pyret you can nest the `cases` operation to iterate over two (or more) datum at the same time. Without this, implementing the `map2` function from scratch would have been impossible.

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
