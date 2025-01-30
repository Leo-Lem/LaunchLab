//
// Copyright © 2024 M-Lab Group Entrepreneurchat, University of Hamburg, Transferagentur. All rights reserved.
//

import Data
import SwiftUI
import UIComponents

extension Lecture {
  /// The actual content is displayed in these blocks.
  struct Block: View {
    @State private var answer = ""
    @Binding var isAnswered: Bool
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
          .onAppear { isAnswered = true }
      case .textfield:
        AnswerTextField($answer, coFounderTip: CoFounderTip(), question: markdown, hideCoFounder: content.module.index == 0) {
          await CoFounder.shared.getHelp(content.module.title, question: content.content)
        }
        .onAppear {
          if let module = try? CoreDataStack.shared.mainContext
            .fetch(Module.fetchRequest())
            .first(where: { ($0.questionAndAnswer[content.title]?.isEmpty) != nil }) {
            answer = module.questionAndAnswer[content.title] ?? ""
          }
          isAnswered = !answer.isEmpty
        }
        .onChange(of: answer) {
          isAnswered = !answer.isEmpty
          content.module.questionAndAnswer[content.title] = answer
          CoreDataStack.shared.save()
        }
      }
    }
  }
}
