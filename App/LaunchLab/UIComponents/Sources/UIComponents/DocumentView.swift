//
// Copyright © 2024 M-Lab Group Entrepreneurchat, University of Hamburg, Transferagentur. All rights reserved.
//

import SwiftfulRouting
import SwiftUI

public struct DocumentView: View {
  @Environment(\.router) var router
  @Environment(\.colorScheme) var colorScheme
  @State private var pdfURL: URL?
  private let isAvailable: Bool
  private let documentTitle: String
  private let dismissAction: () -> Void

  public init(isAvailable: Bool, documentTitle: String, dismissAction: @escaping () -> Void) {
    self.isAvailable = isAvailable
    self.documentTitle = documentTitle
    self.dismissAction = dismissAction
  }

  public var body: some View {
    VStack(spacing: 20) {
      Image("generating")
        .resizable()
        .frame(width: 250, height: 250)

      Text("Generate your personalized \(documentTitle)")
        .font(.title2)
        .bold()
        .multilineTextAlignment(.center)

      Text("This will prompt ChatGPT with your entered data. If you don't want to share your data with ChatGPT, you can skip this step.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)

      Spacer()

      if let pdfFileURL = pdfURL {
        ShareLink(
          item: pdfFileURL,
          preview: SharePreview("PDF Document", image: Image(systemName: "doc.richtext"))
        ) {
          Text("Export PDF")
            .padding(.vertical)
            .foregroundStyle(Color.white)
            .frame(width: UIScreen.main.bounds.width - 80)
            .background(
              RoundedRectangle(cornerRadius: 40)
                .fill(Color(uiColor: colorScheme == .dark ? .secondarySystemGroupedBackground : .blue))
            )
        }
      } else {
        ActionPrimaryButton(isClickable: true, title: isAvailable ? "Generate" : "Locked 🔒") {
          try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
          generatePDF()
        }
        .disabled(!isAvailable)
      }

      if isAvailable {
        Button("Mark as completed") { dismissAction() }
          .padding(.top, -10)
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 30)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: router.dismissScreen) {
          Image(systemName: "xmark.circle")
            .frame(width: 20, height: 20)
        }
      }
    }
  }

  private func generatePDF() {
    let pdfContent = """
    This is a generated PDF for the document titled "Elevator Pitch".
    Use this space to add your custom PDF content.
    """
    let tempDirectory = FileManager.default.temporaryDirectory
    let fileURL = tempDirectory.appendingPathComponent("ElevatorPitch.pdf")

    do {
      let pdfData = try createPDF(content: pdfContent)
      try pdfData.write(to: fileURL)
      pdfURL = fileURL
    } catch {
      print("Error generating PDF: \(error.localizedDescription)")
    }
  }

  /// Create PDF data from content
  private func createPDF(content: String) throws -> Data {
    let pdfMetaData = [
      kCGPDFContextCreator: "Screenless",
      kCGPDFContextAuthor: "Screenless User"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]

    let pageWidth = 8.5 * 72.0 // 8.5 inches
    let pageHeight = 11.0 * 72.0 // 11 inches
    let pageSize = CGSize(width: pageWidth, height: pageHeight)

    let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)
    return renderer.pdfData { context in
      context.beginPage()
      let attributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
      ]
      content.draw(in: CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40), withAttributes: attributes)
    }
  }
}
