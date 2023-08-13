# CSCI0190 (Fall 2018)
provide *
provide-types *

### IMPORTS BELOW

import shared-gdrive("contfracs-types.arr", "1YtBYBATzXGp4EwUYZlViFSPNZknv_Zgt")
as support
type Stream = support.Stream
lz-link = support.lz-link

### IMPORTS ABOVE

## Part 1: Streams

# cf-phi :: Stream<Number> = 
# cf-e :: Stream<Number> = 

fun take<A>(s :: Stream<A>, n :: Number) -> List<A>:
  ...
end

fun repeating-stream(numbers :: List<Number>) -> Stream<Number>:
  doc: ""
  ...
end

fun threshold(approximations :: Stream<Number>, thresh :: Number)-> Number:
  doc: ""
  ...
end

fun fraction-stream(coefficients :: Stream<Number>) -> Stream<Number>:
  doc: ""
  ...
end


## Part 2: Options and Terminating Streams

# cf-phi-opt :: Stream<Option<Number>> = 
# cf-e-opt :: Stream<Option<Number>> = 
# cf-pi-opt :: Stream<Option<Number>> = 

fun terminating-stream(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: ""
  ...
end

fun repeating-stream-opt(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: ""
  ...
end

fun threshold-opt(approximations :: Stream<Option<Number>>,
    thresh :: Number) -> Number:
  doc: ""
  ...
end

fun fraction-stream-opt(coefficients :: Stream<Option<Number>>)
  -> Stream<Option<Number>>:
  doc: ""
  ...
end
