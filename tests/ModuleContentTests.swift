//
// Copyright © 2024 M-Lab Group Entrepreneurchat, University of Hamburg, Transferagentur. All rights reserved.
//

import Data
import Testing

@testable import LaunchLab

class ModuleContentTests {
  @Test("correct content type", arguments: [
    "info", "textfield"
  ])
  func parseCorrectType(type: String) async throws {
    #expect(Content.Kind(rawValue: type) != nil)
  }

  @Test("incorrect content type", arguments: [
    "hullo"
  ])
  func parseIncorrectType(type: String) async throws {
    #expect(Content.Kind(rawValue: type) == nil)
  }
}
