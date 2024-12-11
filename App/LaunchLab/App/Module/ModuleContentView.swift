//
// Copyright © 2024 M-Lab Group Entrepreneurchat, University of Hamburg, Transferagentur. All rights reserved.
//

import Data
import SwiftUI
import UIComponents

struct ModuleContentView: View {
  let content: ModuleContent

  var body: some View {
    Text(content.title)
      .font(.title)
      .fontWeight(.bold)
      .multilineTextAlignment(.center)
      .padding(.bottom, 12)
      .foregroundStyle(content.module.gradient)

    switch content.contentType {
    case .info:
      Text(markdown)
        .font(.title3)
    case .textfield:
      AnswerTextField(text: $answer, placeholder: markdown)
    }
  }

  @State private var answer = ""

  private var markdown: AttributedString {
    (try? AttributedString(
      markdown: content.content,
      options: .init(allowsExtendedAttributes: true, interpretedSyntax: .inlineOnlyPreservingWhitespace)
    )) ?? AttributedString(
        stringLiteral: content.content
      )
  }
}

#Preview {
  ModuleContentView(content: Module.example(0).content[0])
  Divider()
  ModuleContentView(content: Module.example(0).content[1])
}
