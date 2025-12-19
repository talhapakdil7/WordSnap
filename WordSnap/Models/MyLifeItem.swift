// ✅ Models/MyLifeItem.swift  (TAMAMINI BUNUNLA DEĞİŞTİR)
import Foundation

struct MyLifeItem: Identifiable, Equatable {
    let id: String
    var wordEN: String
    var wordTR: String
    var personalMeaning: String
    var example: String
    var imageData: Data?
    var latitude: Double?
    var longitude: Double?
    var locationTitle: String?
    var pinHex: String          // ✅ kullanıcı rengi (hex)
    var createdAtText: String
}
