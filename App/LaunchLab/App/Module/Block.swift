//
// Copyright © 2024 M-Lab Group Entrepreneurchat, University of Hamburg, Transferagentur. All rights reserved.
//

import Data
import SwiftUI
import UIComponents

extension Lecture {
  /// The actual content is displayed in these blocks.
  struct Block: View {
    let content: ModuleContent

    private var markdown: AttributedString {
      (try? AttributedString(
        markdown: content.content,
        options: .init(allowsExtendedAttributes: true, interpretedSyntax: .inlineOnlyPreservingWhitespace)
      )) ?? AttributedString(
        stringLiteral: content.content
      )
    }

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
        AnswerTextField($answer, question: markdown) {
          await CoFounder.shared.getHelp(content.module.title, question: content.content)
        }
        .onAppear {
          if let module = try? CoreDataStack.shared.mainContext
            .fetch(Module.fetchRequest())
            .first(where: { ($0.questionAndAnswer[content.title]?.isEmpty) != nil }) {
            answer = module.questionAndAnswer[content.title] ?? ""
          }
        }
        .onChange(of: answer) {
          content.module.questionAndAnswer[content.title] = answer
          CoreDataStack.shared.save()
        }
      }
    }

    @State private var answer = ""
  }
}

#Preview {
  // swiftlint:disable:next force_unwrapping
  Lecture.Block(content: Module.example(0).content.first!)
}
