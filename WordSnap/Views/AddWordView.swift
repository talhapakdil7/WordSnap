
import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var word = ""
    @State private var meaning = ""
    @State private var sentence = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Word") {
                    TextField("English word", text: $word)
                        .textInputAutocapitalization(.never)
                }
                Section("Meaning") {
                    TextField("Turkish meaning", text: $meaning)
                }
                Section("Example") {
                    TextField("Example sentence", text: $sentence, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Word")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // Adım 3: Firestore’a kaydı burada yapacağız
                        dismiss()
                    }
                    .disabled(word.isEmpty || meaning.isEmpty)
                }
            }
        }
    }
}
