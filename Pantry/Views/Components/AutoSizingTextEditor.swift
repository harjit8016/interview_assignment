import SwiftUI

struct AutoSizingTextEditor: View {
    @Binding var text: String
    var placeholder: String = "Enter text..." // Default value
    var minLines: Int = 1
    var maxLines: Int = 6
    
    var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .lineLimit(minLines...maxLines)
            .textFieldStyle(.plain)
    }
}
