
import SwiftUI

struct HeaderView: View {
    let title: String
    let count: Int

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 38, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                HStack(spacing: 6) {
                    Text("\(count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 40, height: 40)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
        }
        .padding(.horizontal, 18)
    }
}

struct HexTextCard: View {
    let size: CGFloat
    let fill: Color
    let title: String
    let subtitle: String
    let date: String

    var body: some View {
        ZStack {
            Hexagon()
                .fill(fill)
                .shadow(radius: 14, x: 0, y: 10)

            Hexagon()
                .stroke(Color.white.opacity(0.55), lineWidth: 2)

            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)

                Text(subtitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)

                if !date.isEmpty {
                    Text(date)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(14)
            .frame(width: size, height: size)
            .clipShape(Hexagon())
        }
        .frame(width: size, height: size)
    }
}

struct HexImageCard: View {
    let size: CGFloat
    let imageName: String
    let title: String
    let subtitle: String
    let date: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipped()
                .clipShape(Hexagon())

            LinearGradient(
                colors: [.black.opacity(0.05), .black.opacity(0.60)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(Hexagon())

            if !title.isEmpty {
                VStack(spacing: 6) {
                    Spacer()
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.95))
                    }

                    if !date.isEmpty {
                        Text(date)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(width: size, height: size)
        .shadow(radius: 14, x: 0, y: 10)
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w, y: h * 0.25))
        p.addLine(to: CGPoint(x: w, y: h * 0.75))
        p.addLine(to: CGPoint(x: w * 0.5, y: h))
        p.addLine(to: CGPoint(x: 0, y: h * 0.75))
        p.addLine(to: CGPoint(x: 0, y: h * 0.25))
        p.closeSubpath()
        return p
    }
}
