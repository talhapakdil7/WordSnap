import SwiftUI

struct WSHexTextCard: View {
    let size: CGFloat
    let fill: Color
    let title: String
    let subtitle: String
    let date: String
    let titleSize: CGFloat
    let bodySize: CGFloat
    let textColor: Color

    var body: some View {
        ZStack {
            WSHexagon()
                .fill(fill)
                .shadow(radius: 16, x: 0, y: 12)

            WSHexagon()
                .stroke(Color.white.opacity(0.55), lineWidth: 2)

            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: titleSize, weight: .bold))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: bodySize, weight: .semibold))
                        .foregroundStyle(textColor.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.7)
                }

                if !date.isEmpty {
                    Text(date)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(textColor.opacity(0.9))
                }
            }
            .padding(16)
            .frame(width: size, height: size)
            .clipShape(WSHexagon())
        }
        .frame(width: size, height: size)
    }
}

