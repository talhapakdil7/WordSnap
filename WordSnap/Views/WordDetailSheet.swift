import SwiftUI

struct WSWordDetailSheet: View {
    let item: WSWord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Text(item.word)
                    .font(.system(size: 28, weight: .bold))

                Text("Meaning: \(item.meaning)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)

                if !item.sentence.isEmpty {
                    Text("Sentence")
                        .font(.headline)
                    Text(item.sentence)
                        .font(.body)
                }

                Spacer()
            }
            .padding(18)
            .navigationTitle("Word")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

