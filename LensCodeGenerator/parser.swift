import Foundation

struct FileStructure {
  let structs: [StructStructure]
}

struct StructStructure {
  let type: String
  let properties: [PropertyStructure]
}

public struct PropertyStructure {
  let identifier: String
  let type: String
}

func parseFileContent(fileContent: String) -> FileStructure {
  return FileStructure.init
    <*> fileContent |> getStructStrings |> { $0.flatMap(parseStructString) }
}

func getStructStrings(fileContent: String) -> [String] {
  guard let regex = "struct\\s+[a-z][a-z0-9]*\\s*\\{[^}]+\\}".regex else { return [] }

  return regex.matches(fileContent).flatMap {
    guard $0.numberOfRanges >= 1 else { return nil }
    return fileContent.getSubstringWithRange($0.rangeAtIndex(0))
  }
}

func parseStructString(structString: String) -> StructStructure? {
  return curry(StructStructure.init)
    <*> structString |> getStructName
    <*> structString |> getPropertyStrings |> { $0.flatMap(parseProperty) }
}

func getStructName(structString: String) -> String? {
  guard let regex = "^struct\\s+([a-z][a-z0-9]*)".regex else { return nil }
  guard let match = regex.firstMatch(structString) else { return nil }
  guard match.numberOfRanges >= 2 else { return nil }

  return structString.getSubstringWithRange(match.rangeAtIndex(1))
}

func getPropertyStrings(structString: String) -> [String] {
  guard let regex = "\\blet\\s+[a-z][a-z0-9]*\\s*:\\s*[a-z][a-z0-9]*\\s*[;\\n]".regex
    else { return [] }
  
  return regex.matches(structString).flatMap {
    guard $0.numberOfRanges >= 1 else { return nil }
    return structString.getSubstringWithRange($0.rangeAtIndex(0))
  }
}

func parseProperty(declaration: String) -> PropertyStructure? {
  guard let regex = "let\\s+([a-z][a-z0-9]*)\\s*:\\s*([a-z]+)".regex else { return nil }
  guard let match = regex.firstMatch(declaration) else { return nil }
  guard match.numberOfRanges >= 3 else { return nil }

  let identifier = declaration.getSubstringWithRange(match.rangeAtIndex(1))
  let type = declaration.getSubstringWithRange(match.rangeAtIndex(2))

  return PropertyStructure(identifier: identifier, type: type)
}
