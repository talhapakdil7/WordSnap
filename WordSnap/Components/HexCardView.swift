import SwiftUI

struct HexCardView<Content: View>: View {
    let size: CGFloat
    var fill: AnyShapeStyle = AnyShapeStyle(.ultraThinMaterial)
    let content: Content

    init(size: CGFloat,
         fill: AnyShapeStyle = AnyShapeStyle(.ultraThinMaterial),
         @ViewBuilder content: () -> Content) {
        self.size = size
        self.fill = fill
        self.content = content()
    }

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(fill)
                .overlay(
                    HexagonShape()
                        .stroke(Color.white.opacity(0.55), lineWidth: 2)
                )
                .shadow(radius: 14, x: 0, y: 10)

            content
                .padding(14)
                .frame(width: size, height: size)
                .clipShape(HexagonShape())
        }
        .frame(width: size, height: size)
    }
}

