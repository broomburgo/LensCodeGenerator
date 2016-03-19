import Foundation

infix operator |> { associativity left precedence 90 }
func |> <A,B,C> (lhs: A -> B, rhs: B -> C) -> A -> C {
  return { rhs(lhs($0)) }
}

func |> <A,B> (lhs: A, rhs: A -> B) -> B {
  return rhs(lhs)
}

infix operator <*> { associativity left precedence 70 }

func <*> <A,B>(lhs: A -> B, rhs: A) -> B {
  return lhs(rhs)
}

func <*> <A,B>(lhs: (A -> B)?, rhs: A?) -> B? {
  switch (lhs, rhs) {
  case let (.Some(transform), .Some(value)):
    return transform(value)
  default:
    return nil
  }
}

func curry<A,B,C>(function: (A, B) -> C) -> A -> B -> C {
  return { a in
    { b in
      return function(a,b)
    }
  }
}
