# CSCI0190 (Fall 2018)
provide *
provide-types *
# Imports below

# Imports above
import shared-gdrive("filesystem-types.arr", 
  "1C9WPivMElRfYhBzPibLMtDkXeME8N5rI") as F
type Dir = F.Dir
type File = F.File
type Path = F.Path
dir = F.dir
file = F.file

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

# Implementation:

#======== Example Tree =========#
hang = file('hang', 8, '')
draw = file('draw', 2, '')
read = file('read!', 19, '')
code = dir('Code', empty, [list: hang, draw])
docs = dir('Docs', empty, [list: read])
libs = dir('Libs', [list: code, docs], empty)
part1 = file('part1', 99, '')
part2 = file('part2', 52, '')
part3 = file('part3', 17, '')
text = dir('Text', empty, [list: part1, part2, part3])
read2 = file('read!', 10, '')
TS = dir('TS', [list: text, libs], [list: read2])


#==========Exercise 1==========#
fun how-many(a-dir :: Dir) -> Number:
  doc: "Counts the number of files in a directory tree"
  ...
where:
  nothing
end

#==========Exercise 2==========#
fun du-dir(a-dir :: Dir) -> Number:
  doc: ""
  ...
where:
  nothing
end

#==========Exercise 3==========#
fun can-find(a-dir :: Dir, fname :: String) -> Boolean:
  doc: ""
  ...
where:
  nothing
end

#==========Exercise 4==========#
fun fynd(a-dir :: Dir, fname :: String) -> List<Path>:
  doc: ""
  ...
where:
  nothing
end