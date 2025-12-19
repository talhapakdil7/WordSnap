import SwiftUI

struct WSAddWordSheet: View {

    @Environment(\.dismiss) private var dismiss

    @State private var word = ""
    @State private var meaning = ""
    @State private var sentence = ""

    var onSave: (WSWord) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Word") {
                    TextField("English word", text: $word)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section("Meaning") {
                    TextField("Turkish meaning", text: $meaning)
                }
                Section("Sentence") {
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
                        let item = WSWord(
                            id: UUID().uuidString,
                            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
                            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
                            sentence: sentence.trimmingCharacters(in: .whitespacesAndNewlines),
                            dateText: dateText()
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func dateText() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f.string(from: Date())
    }
}

