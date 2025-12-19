// ✅ Views/MyLifeView.swift  (TAMAMINI BUNUNLA DEĞİŞTİR)
import SwiftUI

struct MyLifeView: View {

    @State private var showAdd = false

    // ✅ DİKKAT: BURADA [Any] YOK. SADECE [MyLifeItem]
    @State private var items: [MyLifeItem] = [
        // ✅ Views/MyLifeView.swift içindeki dummy datayı da buna göre düzelt (items array)
        // örnek 1 kayıt:
        MyLifeItem(
           id: UUID().uuidString,
           wordEN: "Hike",
           wordTR: "Doğa yürüyüşü",
           personalMeaning: "Bana huzur veriyor, kafa boşaltıyorum.",
           example: "I went on a hike last weekend.",
           imageData: nil,                 // istersen nil bırak
           latitude: 41.0082,
           longitude: 28.9784,
           locationTitle: "Istanbul",
           pinHex: "#34C759", // varsayılan yeşil (Apple green)

           createdAtText: "Oct 4"
        )

    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(items) { item in
                        NavigationLink {
                            MyLifeDetailView(item: item)
                        } label: {
                            MyLifeRow(item: item)
                        }
                    }
                    .onDelete { indexSet in
                        items.remove(atOffsets: indexSet)
                    }
                } header: {
                    Text("MyLife")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("MyLife")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddMyLifeView { newItem in
                    items.insert(newItem, at: 0)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

