import SwiftUI

struct TextEntrySheet: View {
    @Binding var text: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $text)
                    .frame(height: 200)
                    .border(Color.gray)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Add Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        text = ""
                        dismiss()
                    }
                }
            }
        }
    }
}
