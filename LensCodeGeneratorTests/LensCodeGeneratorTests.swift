import XCTest

extension PropertyStructure: Equatable {}

public func == (lhs: PropertyStructure, rhs: PropertyStructure) -> Bool {
  return lhs.identifier == rhs.identifier && lhs.type == rhs.type
}

class LensCodeGeneratorTests: XCTestCase {
  func testparsePropertyNone() {
    let matched = parseProperty("khdfa")
    XCTAssertNil(matched)
  }

  func testparsePropertyCorrect() {
    let matched = parseProperty("let value: String")
    let expected = PropertyStructure(identifier: "value", type: "String")
    XCTAssertEqual(matched, expected)
  }

  func testparsePropertyCorrectNotClear() {
    let matched = parseProperty("  let  value :    String ")
    let expected = PropertyStructure(identifier: "value", type: "String")
    XCTAssertEqual(matched, expected)
  }

  func testGetStructStringsNone() {
    let strings = getStructStrings("")
    XCTAssertEqual(strings.count, 0)
  }

  func testGetStructStringsSingle() {
    var fileContent = ""
    fileContent += "struct Type {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    let strings = getStructStrings(fileContent)
    XCTAssertEqual(strings.count, 1)
  }

  func testGetStructStringsSingleWithStructInAttributeName() {
    var fileContent = ""
    fileContent += "struct Type {\n"
    fileContent += "  let firstStruct: String\n"
    fileContent += "  let structAttribute: String\n"
    fileContent += "}\n"
    let strings = getStructStrings(fileContent)
    XCTAssertEqual(strings.count, 1)
  }

  func testGetStructStringsTwo() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    fileContent += "\n"
    fileContent += "struct Type2 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"

    let strings = getStructStrings(fileContent)
    XCTAssertEqual(strings.count, 2)
  }

  func testGetStructStringsThree() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    fileContent += "\n"
    fileContent += "struct Type2 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "}\n"
    fileContent += "struct Type3 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "  let thirdAttribute: String\n"
    fileContent += "}\n"

    let strings = getStructStrings(fileContent)
    XCTAssertEqual(strings.count, 3)
  }

  func testGetStructStringsMultipleGarbage() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    fileContent += "\n"
    fileContent += "\n"
    fileContent += "struct Type2 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "}\n"
    fileContent += "ciao sergio\n"
    fileContent += "}\n"
    fileContent += "}\n"
    fileContent += "{\n"
    fileContent += "struct Type3 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "  let thirdAttribute: String\n"
    fileContent += "}\n"

    let strings = getStructStrings(fileContent)
    XCTAssertEqual(strings.count, 3)
  }

  func testGetStructName() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    let name = getStructName(fileContent)
    XCTAssertEqual(name, "Type1")
  }

  func testGetPropertyStringsNone() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "}\n"
    let propertyStrings = getPropertyStrings(fileContent)
    XCTAssertEqual(propertyStrings.count, 0)
  }

  func testGetPropertyStringsSingle() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "}\n"
    let propertyStrings = getPropertyStrings(fileContent)
    XCTAssertEqual(propertyStrings.count, 1)
  }

  func testGetPropertyStringsTwo() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String\n"
    fileContent += "  let secondAttribute: String\n"
    fileContent += "}\n"
    let propertyStrings = getPropertyStrings(fileContent)
    XCTAssertEqual(propertyStrings.count, 2)
  }

  func testGetPropertyStringsTwoSameLine() {
    var fileContent = ""
    fileContent += "struct Type1 {\n"
    fileContent += "  let firstAttribute: String;let secondAttribute: String\n"
    fileContent += "}\n"
    let propertyStrings = getPropertyStrings(fileContent)
    XCTAssertEqual(propertyStrings.count, 2)
  }
}
