// MARK: - Views/AddWordView.swift

import SwiftUI

struct AddWordView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var wordsVM: WordsViewModel

    @State private var word = ""
    @State private var meaning = ""
    @State private var sentence = ""

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
                        Task {
                            await wordsVM.add(word: word, meaning: meaning, sentence: sentence)
                            dismiss()
                        }
                    }
                    .disabled(word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

