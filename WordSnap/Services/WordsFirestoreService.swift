import Foundation
import FirebaseAuth
import FirebaseFirestore

final class WordsFirestoreService {

    private let db = Firestore.firestore()

    private func wordsCollection(uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("words")
    }

    // ✅ Realtime dinle (ekle/sil/güncelle otomatik UI'ya yansır)
    func listenWords(uid: String, onChange: @escaping (Result<[WSWord], Error>) -> Void) -> ListenerRegistration {
        wordsCollection(uid: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error { onChange(.failure(error)); return }
                guard let docs = snapshot?.documents else { onChange(.success([])); return }

                let items: [WSWord] = docs.compactMap { doc in
                    let data = doc.data()
                    let word = data["word"] as? String ?? ""
                    let meaning = data["meaning"] as? String ?? ""
                    let sentence = data["sentence"] as? String ?? ""
                    let dateText = data["dateText"] as? String ?? ""
                    return WSWord(id: doc.documentID, word: word, meaning: meaning, sentence: sentence, dateText: dateText)
                }
                onChange(.success(items))
            }
    }

    // ✅ Ekle
    func addWord(uid: String, word: WSWord) async throws {
        let ref = wordsCollection(uid: uid).document() // Firestore id
        let payload: [String: Any] = [
            "word": word.word,
            "meaning": word.meaning,
            "sentence": word.sentence,
            "dateText": word.dateText,
            "createdAt": FieldValue.serverTimestamp()
        ]
        try await ref.setData(payload)
    }

    // ✅ Sil
    func deleteWord(uid: String, id: String) async throws {
        try await wordsCollection(uid: uid).document(id).delete()
    }
}

