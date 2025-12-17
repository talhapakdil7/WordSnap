// ✅ WordsView.swift (TEK DOSYA - HATALARI DÜZELTİLMİŞ)
// ÖNEMLİ: Projede eski Hexagon / HexTextCard / HexImageCard vs varsa SİL veya isimlerini değiştir.
// Bu dosya tek başına derlenir.

import SwiftUI

struct WordsView: View {

    @State private var scrollY: CGFloat = 0
    @State private var showAddWord = false

    private let topTitle = "Went to a great\nconcert with\nBlair 🎶"
    private let mainTitle = "Catching\nmy breath"
    private let mainSub = "So grateful for a relaxing evening."
    private let mainDate = "Oct 4"

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                WSOffsetReader { y in
                    scrollY = y
                }
                .frame(height: 0)

                VStack(spacing: 0) {
                    header
                        .padding(.top, 10)

                    Color.clear.frame(height: 40)

                    GeometryReader { geo in
                        let w = geo.size.width

                        let topHex = w * 0.48
                        let mainHex = w * 0.62

                        let t = wsClamp((-scrollY) / 140, 0, 1)
                        let topOpacity = wsLerp(0.40, 0.85, t)

                        ZStack {
                            // üst küçük hex
                            WSHexTextCard(
                                size: topHex,
                                fill: Color.orange.opacity(topOpacity),
                                title: topTitle,
                                subtitle: "",
                                date: "",
                                titleSize: 18,
                                bodySize: 12,
                                textColor: .white.opacity(0.85)
                            )
                            .opacity(0.9)
                            .position(x: w * 0.52, y: 40)

                            // ana turuncu hex
                            WSHexTextCard(
                                size: mainHex,
                                fill: Color.orange,
                                title: mainTitle,
                                subtitle: mainSub,
                                date: mainDate,
                                titleSize: 26,
                                bodySize: 16,
                                textColor: .white
                            )
                            .position(x: w * 0.68, y: 215)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    .frame(height: 420)

                    // alt alan (sonra diğer hex’ler gelecek)
                    Color.clear.frame(height: 700)
                }
            }

            // sağ üst + butonu (header üstünde)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showAddWord = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.95))
                            .clipShape(Circle())
                            .shadow(radius: 6, x: 0, y: 4)
                    }
                    .padding(.trailing, 18)
                    .padding(.top, 62)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showAddWord) {
            WSAddWordStubView()
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Grateful Moments")
                    .font(.system(size: 40, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                HStack(spacing: 6) {
                    Text("75")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.orange)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 18)
    }
}

// MARK: - Components (ÖZEL İSİMLER: WS... redeclare olmaz)

private struct WSHexTextCard: View {
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

private struct WSHexagon: Shape {
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

// Scroll offset okuyucu
private struct WSOffsetReader: View {
    var onChange: (CGFloat) -> Void

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: WSOffsetKey.self, value: geo.frame(in: .global).minY)
        }
        .onPreferenceChange(WSOffsetKey.self, perform: onChange)
    }
}

private struct WSOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private func wsClamp(_ x: CGFloat, _ a: CGFloat, _ b: CGFloat) -> CGFloat {
    min(max(x, a), b)
}

private func wsLerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}

// + buton ekranı (şimdilik)
private struct WSAddWordStubView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Add Word (UI sonra)")
                .navigationTitle("Add Word")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") { dismiss() }
                    }
                }
        }
    }
}

