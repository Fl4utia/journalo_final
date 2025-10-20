import SwiftUI

struct RichTextEditSheet: View {
    @Binding var element: PageElement
    @Environment(\.dismiss) var dismiss
    
    // Local @State variables for editing controls
    @State private var editText: String
    @State private var editColor: Color
    @State private var editSize: CGFloat

    // Initialize local state from the bound element data
    init(element: Binding<PageElement>) {
        self._element = element
        self._editText = State(initialValue: element.wrappedValue.text ?? "")
        self._editColor = State(initialValue: element.wrappedValue.textColor)
        self._editSize = State(initialValue: element.wrappedValue.fontSize)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 1. Text Editor
                TextEditor(text: $editText)
                    .frame(height: 150)
                    .font(.system(size: 18))
                    .border(Color.gray)
                    .padding(.horizontal)
                
                // 2. Size Slider
                VStack(alignment: .leading) {
                    Text("Text Size: \(Int(editSize))")
                        .font(.headline)
                    Slider(value: $editSize, in: 10...40, step: 1)
                }
                .padding(.horizontal)
                
                // 3. Color Picker
                ColorPicker("Text Color", selection: $editColor)
                    .padding(.horizontal)
                
                // 4. Preview
                Text(editText)
                    .font(.system(size: editSize))
                    .foregroundColor(editColor)
                    .padding()
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Edit Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        // Save changes back to the bound element
                        element.text = editText
                        element.textColor = editColor
                        element.fontSize = editSize
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
