import SwiftUI

struct WordsView: View {

    @State private var showAddWord = false
    @State private var float = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let top = geo.safeAreaInsets.top
            let bottom = geo.safeAreaInsets.bottom

            // Boyutlar (ekrana göre otomatik)
            let small = min(170, w * 0.42)
            let mid   = min(240, w * 0.58)
            let photo = min(300, w * 0.72)

            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                SoftHexBackground().opacity(0.45).ignoresSafeArea()

                VStack(spacing: 22) {

                    // HEADER
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WordSnap")
                                .font(.system(size: min(38, w * 0.10), weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)   // ✅ taşmayı engeller
                                .frame(maxWidth: w * 0.70, alignment: .leading)

                            HStack(spacing: 6) {
                                Text("75")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                            }
                        }

                        Spacer()

                        Button {
                            showAddWord = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 40, height: 40)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, top + 8)

                    // içerik
                    VStack(spacing: 18) {

                        // üst küçük hex (sağda) — FLOAT
                        HStack {
                            Spacer()
                            HexCardView(size: small, fill: AnyShapeStyle(Color.orange.opacity(0.55))) {
                                hexText(
                                    title: "Down time",
                                    subtitle: "…for a relaxing evening after…",
                                    date: "Oct 1",
                                    titleSize: 16,
                                    bodySize: 12,
                                    dateSize: 12,
                                    color: .white
                                )
                            }
                            .opacity(0.55)
                            .offset(y: float ? -6 : 6)
                        }
                        .padding(.horizontal, 18)

                        // ana turuncu hex — FLOAT
                        HexCardView(size: mid, fill: AnyShapeStyle(Color.orange)) {
                            hexText(
                                title: "Catching\nmy breath",
                                subtitle: "So grateful for a relaxing evening.",
                                date: "Sep 12",
                                titleSize: 22,
                                bodySize: 14,
                                dateSize: 12,
                                color: .white
                            )
                        }
                        .offset(y: float ? 4 : -4)

                        // foto hex — FLOAT
                        HexPhotoCard(
                            size: photo,
                            image: Image("sample1"),
                            title: "Passed the test!",
                            subtitle: "⭐⭐⭐",
                            date: "Sep 12"
                        )
                        .padding(.horizontal, 18)
                        .offset(y: float ? -3 : 3)

                        Spacer(minLength: 0)
                        Color.clear.frame(height: 20 + bottom)
                    }
                }
            }
            .onAppear {
                // ✅ sürekli animasyon (hareket)
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    float.toggle()
                }
            }
            .sheet(isPresented: $showAddWord) {
                AddWordView()
            }
        }
    }

    // HEX TEXT (taşma engelli)
    private func hexText(
        title: String,
        subtitle: String,
        date: String,
        titleSize: CGFloat,
        bodySize: CGFloat,
        dateSize: CGFloat,
        color: Color
    ) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: titleSize, weight: .bold))
                .foregroundStyle(color)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)

            Text(subtitle)
                .font(.system(size: bodySize, weight: .semibold))
                .foregroundStyle(color.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)

            Text(date)
                .font(.system(size: dateSize, weight: .bold))
                .foregroundStyle(color.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

