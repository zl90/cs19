# CSCI0190 (Fall 2018)

provide *
provide-types *

import brown-university-landmarks, brown-university-tours from shared-gdrive(
  "tour-guide-data.arr", 
  "1u_UPQ0Z2N867XQQqJkGDo5MFFS97yysX")

include shared-gdrive(
  "tour-guide-definitions.arr",
  "1hVLncE2-w5JjhSucmLJdVaoxNWEylPjX")

## DO NOT EDIT ABOVE THIS LINE

fun dijkstra(start :: Name, graph :: Graph) -> Set<Path>:
  # Implement me!
  ...
end

fun campus-tour(
    tours :: Set<Tour>,
    start-position :: Point,
    campus-data :: Graph) -> Path:
  # Implement me!
  ...
end
