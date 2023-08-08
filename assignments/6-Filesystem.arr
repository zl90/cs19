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
fun is-in-files(files :: List<File>, fname :: String, acc :: Boolean) -> Boolean:
  cases (List) files:
    | empty => acc
    | link(f, r) => 
      if f.name == fname:
        true
      else:
        is-in-files(r, fname, acc)
      end
  end
end

  fun is-in-child-dirs(dirs :: List<Dir>, fname :: String, acc :: Boolean) -> Boolean:
  cases (List) dirs:
    | empty => acc
    | link(f, r) => 
      if is-in-files(f.fs, fname, false) or is-in-child-dirs(f.ds, fname, false):
          true
      else:
        is-in-child-dirs(r, fname, false)
      end      
  end
end

fun can-find(a-dir :: Dir, fname :: String) -> Boolean:
  doc: "Determines whether or not a file with the input name can be found anywhere in that directory tree"
  is-in-files(a-dir.fs, fname, false) or is-in-child-dirs(a-dir.ds, fname, false)
where:
  can-find(TS, 'hang') is true
  can-find(TS, 'test') is false
  can-find(libs, 'foo') is false
  can-find(libs, 'read!') is true
end

#==========Exercise 4==========#
fun fynd-in-child-dirs(dirs :: List<Dir>, fname :: String, current-path :: Path, acc :: List<Path>) -> List<Path>:
  cases (List) dirs:
    | empty => acc
    | link(f, r) => 
      if is-in-files(f.fs, fname, false) and is-in-child-dirs(f.ds, fname, false):
        fynd-in-child-dirs(f.ds, fname, current-path + [list: f.name], link(current-path + [list: f.name], acc))
      else if is-in-files(f.fs, fname, false):
        link(current-path + [list: f.name], acc)
      else if is-in-child-dirs(f.ds, fname, false):
        fynd-in-child-dirs(f.ds, fname, current-path + [list: f.name], acc)
      else:
        fynd-in-child-dirs(r, fname, current-path, acc)
      end      
  end
end

fun fynd(a-dir :: Dir, fname :: String) -> List<Path>:
  doc: "It consumes a Dir d and a file name (String) f, and produces a list of all the paths to all the files named f in d."
  if is-in-files(a-dir.fs, fname, false) and is-in-child-dirs(a-dir.ds, fname, false):
    fynd-in-child-dirs(a-dir.ds, fname, [list: a-dir.name], [list: [list: a-dir.name]])
  else if is-in-files(a-dir.fs, fname, false):
    [list: [list: a-dir.name]]
  else if is-in-child-dirs(a-dir.ds, fname, false):
    fynd-in-child-dirs(a-dir.ds, fname, [list: a-dir.name], empty)
  else:
    [list: ]
  end
where:
  fynd(TS, "part3") is [list: [list: "TS", "Text"]]
  fynd(TS, "read!") is [list: [list: "TS", "Libs", "Docs"], [list: "TS"] ]
end
