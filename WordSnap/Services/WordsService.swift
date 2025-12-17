// MARK: - Services/WordsService.swift

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class WordsService {

    private let db = Firestore.firestore()

    private func wordsRef() throws -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        return db.collection("users").document(uid).collection("words")
    }

    func addWord(word: String, meaning: String, sentence: String) async throws {
        let ref = try wordsRef().document()
        try await ref.setData([
            "word": word,
            "meaning": meaning,
            "sentence": sentence,
            "createdAt": Timestamp(date: Date())
        ])
    }

    func listenWords(onChange: @escaping ([WordItem]) -> Void) throws -> ListenerRegistration {
        let ref = try wordsRef()
        return ref
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snap, _ in
                let items: [WordItem] = snap?.documents.compactMap { doc in
                    let d = doc.data()
                    let ts = (d["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    return WordItem(
                        id: doc.documentID,
                        word: d["word"] as? String ?? "",
                        meaning: d["meaning"] as? String ?? "",
                        sentence: d["sentence"] as? String ?? "",
                        createdAt: ts
                    )
                } ?? []
                onChange(items)
            }
    }
}

