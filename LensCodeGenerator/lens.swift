struct Lens<Whole, Part> {
  let view: Whole -> Part
  let set: Part -> (Whole -> Whole)
}
