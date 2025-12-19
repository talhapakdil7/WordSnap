// ✅ Components/MyLifeRow.swift  (TAMAMINI BUNUNLA DEĞİŞTİR)
import SwiftUI

struct MyLifeRow: View {
    let item: MyLifeItem

    private var uiImage: UIImage? {
        guard let data = item.imageData else { return nil }
        return UIImage(data: data)
    }

    var body: some View {
        HStack(spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(width: 54, height: 54)

                if let img = uiImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.wordEN)
                    .font(.system(size: 17, weight: .bold))

                Text(item.wordTR)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text(item.personalMeaning)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(item.createdAtText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

