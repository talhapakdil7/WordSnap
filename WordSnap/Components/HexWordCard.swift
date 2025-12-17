import SwiftUI

struct HexWordCard: View {
    let size: CGFloat
    let item: WordUI

    var body: some View {
        HexCardView(size: size) {
            VStack(spacing: 10) {
                Spacer(minLength: 0)

                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)

                Text(item.subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black.opacity(0.55))

                Text(item.date)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.45))

                Spacer(minLength: 0)
            }
        }
    }
}

