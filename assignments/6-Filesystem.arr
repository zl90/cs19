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
fun count-files-in-dirs(dirs :: List<Dir>) -> Number:
  doc: "Counts the number of files in a list of directories"
  cases (List) dirs:
    | empty => 0
    | link(f, r) => f.fs.length() + count-files-in-dirs(f.ds) + count-files-in-dirs(r)
  end
where:
  count-files-in-dirs(libs.ds) is 3
end

fun how-many(a-dir :: Dir) -> Number:
  doc: "Counts the number of files in a directory tree"
  a-dir.fs.length() + count-files-in-dirs(a-dir.ds)
where:
  how-many(TS) is 7
  how-many(libs) is 3
  how-many(docs) is 1
end

#==========Exercise 2==========#
fun du-files(files :: List<File>) -> Number:
  doc: "Computes the total size of all the files from a list of files"
  cases (List) files:
    | empty => 0
    | link(f, r) => 1 + f.size + du-files(r)
  end
where:
  du-files(text.fs) is 171
end

fun du-dirs(dirs :: List<Dir>) -> Number:
  doc: "Computes the total size of all the directories and files from a list of directories"
  cases (List) dirs:
    | empty => 0
    | link(f, r) => 1 + du-files(f.fs) + du-dirs(f.ds) + du-dirs(r)
  end
where:
  du-dirs([list: text]) is 171 + 1
  du-dirs([list: TS]) is 219
  du-dirs(empty) is 0
end

fun du-dir(a-dir :: Dir) -> Number:
  doc: "Computes the total size of all the files and subdirectories of a directory tree"
  du-files(a-dir.fs) + du-dirs(a-dir.ds)
where:
  du-dir(TS) is 218
  du-dir(code) is 12
end

#==========Exercise 3==========#
#fun can-find(a-dir :: Dir, fname :: String) -> Boolean:
#  doc: ""
#  ...
#where:
#  nothing
#end

#==========Exercise 4==========#
#fun fynd(a-dir :: Dir, fname :: String) -> List<Path>:
#  doc: ""
#  ...
#where:
#  nothing
#end
