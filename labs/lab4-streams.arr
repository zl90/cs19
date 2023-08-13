data Stream<T>:
  | lz-link(h :: T, t :: ( -> Stream<T>))
end

rec ones = lz-link(1, lam(): ones end)

fun nats-from(n :: Number):
  lz-link(n, {(): nats-from(n + 1)})
end

nats = nats-from(0)

fun lz-first<T>(s :: Stream<T>) -> T: s.h end
fun lz-rest<T>(s :: Stream<T>) -> Stream<T>: s.t() end

fun take<T>(n :: Number, s :: Stream<T>) -> List<T>:
  if n == 0:
    empty
  else:
    link(lz-first(s), take(n - 1, lz-rest(s)))
  end
end

# Lab assignments
fun lz-fold<A, B>(f :: (A, B -> A), base :: A, s :: Stream<B>) -> Stream<A>:
  lz-link(f(base, lz-first(s)), lam(): lz-fold(f, f(base, lz-first(s)), lz-rest(s)) end) 
end

fun lz-filter<A>(f :: (A -> Boolean), s :: Stream<A>) -> Stream<A>:
  if f(lz-first(s)) == true:
    lz-link(lz-first(s), lam(): lz-filter(f, lz-rest(s)) end)
  else:
    lz-filter(f, lz-rest(s))
  end
end

>> take(10, lz-filter(lam(x): if x > 10: true else: false end end, nats))
[list: 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

>> take(10, lz-fold(lam(x, acc): acc + x end, 0, nats))
[list: 0, 1, 3, 6, 10, 15, 21, 28, 36, 45]