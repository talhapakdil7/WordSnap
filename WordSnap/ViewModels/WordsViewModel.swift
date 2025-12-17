// ✅ 1) WordsViewModel.swift  (DOSYA ADI: WordsViewModel.swift)
// NOT: Projede "WordsViewModel" diye başka dosya/struct varsa SİL. Tek bir tane olacak.

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class WordsViewModel: ObservableObject {

    @Published var words: [WordItem] = []
    @Published var errorMessage: String?

    private let service = WordsService()
    private var listener: ListenerRegistration?

    func start() {
        stop()
        do {
            listener = try service.listenWords { [weak self] items in
                self?.words = items
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func stop() {
        listener?.remove()
        listener = nil
    }

    func add(word: String, meaning: String, sentence: String) async {
        do {
            try await service.addWord(word: word, meaning: meaning, sentence: sentence)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

