// MARK: - Models/WordItem.swift

import Foundation
import FirebaseFirestore

struct WordItem: Identifiable {
    let id: String
    let word: String
    let meaning: String
    let sentence: String
    let createdAt: Date
}

