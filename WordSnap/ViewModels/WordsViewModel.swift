
// ✅ ViewModels/WordsViewModel.swift  (BU DOSYAYI AYNEN YAPIŞTIR)
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class WordsViewModel: ObservableObject {

    @Published var items: [WSWord] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let service = WordsFirestoreService()
    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func start() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in."
            items = []
            return
        }

        isLoading = true
        listener?.remove()

        listener = service.listenWords(uid: uid) { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                self.isLoading = false
                switch result {
                case .success(let list):
                    self.items = list
                    self.errorMessage = nil
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func stop() {
        listener?.remove()
        listener = nil
    }

    func addWord(word: String, meaning: String, sentence: String, dateText: String) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in."
            return
        }

        let item = WSWord(
            id: UUID().uuidString,
            word: word,
            meaning: meaning,
            sentence: sentence,
            dateText: dateText
        )

        do {
            try await service.addWord(uid: uid, word: item)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWord(id: String) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in."
            return
        }

        do {
            try await service.deleteWord(uid: uid, id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
