import SwiftUI

struct HexPhotoCard: View {
    let size: CGFloat
    let image: Image
    let title: String
    let subtitle: String
    let date: String

    var body: some View {
        HexCardView(size: size, fill: AnyShapeStyle(Color.clear)) {
            ZStack {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipped()

                LinearGradient(
                    colors: [.black.opacity(0.0), .black.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(spacing: 6) {
                    Spacer()
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Text(date)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.bottom, 6)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

