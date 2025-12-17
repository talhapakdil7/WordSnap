import SwiftUI

// MARK: - Model (benzersiz isim)
private struct WSWordItem: Identifiable, Equatable {
    let id: String
    var word: String
    var meaning: String
    var sentence: String
    var dateText: String
}

// MARK: - WordsView
struct WordsView: View {

    @State private var scrollY: CGFloat = 0
    @State private var showAddWord = false
    @State private var selectedWord: WSWordItem? = nil

    // ✅ Eklenen kelimeler buraya gelecek
    @State private var items: [WSWordItem] = [
        .init(
            id: UUID().uuidString,
            word: "Catching\nmy breath",
            meaning: "nefeslenmek",
            sentence: "So grateful for a relaxing evening.",
            dateText: "Oct 4"
        )
    ]

    private let topTitle = "Went to a great\nconcert with\nBlair 🎶"

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

                    // Referans üst alan
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

                            // ana turuncu hex (son eklenen kelime)
                            let mainItem = items.first
                            WSHexTextCard(
                                size: mainHex,
                                fill: Color.orange,
                                title: (mainItem?.word ?? "Add your first word"),
                                subtitle: (mainItem == nil ? "Tap + to add a word." : (mainItem?.sentence ?? "")),
                                date: (mainItem?.dateText ?? ""),
                                titleSize: 26,
                                bodySize: 16,
                                textColor: .white
                            )
                            .position(x: w * 0.68, y: 215)
                            .onTapGesture {
                                if let mainItem { selectedWord = mainItem }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    .frame(height: 420)

                    // ✅ Yeni eklenen kelimeler aşağıda yeni 6gen
                    VStack(spacing: 18) {
                        ForEach(Array(items.dropFirst().enumerated()), id: \.element.id) { idx, it in
                            HStack {
                                if idx.isMultiple(of: 2) { Spacer() }

                                WSHexTextCard(
                                    size: min(UIScreen.main.bounds.width * 0.60, 280),
                                    fill: Color.orange,
                                    title: it.word,
                                    subtitle: it.meaning,
                                    date: it.dateText,
                                    titleSize: 20,
                                    bodySize: 14,
                                    textColor: .white
                                )
                                .onTapGesture { selectedWord = it }

                                if !idx.isMultiple(of: 2) { Spacer() }
                            }
                            .padding(.horizontal, 18)
                        }
                    }
                    .padding(.top, 10)

                    Color.clear.frame(height: 260)
                }
            }

            // sağ üst + butonu
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
            WSAddWordView { newItem in
                items.insert(newItem, at: 0)
            }
        }
        .sheet(item: $selectedWord) { it in
            WSWordDetailView(item: it)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("WordSnap")
                    .font(.system(size: 40, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                HStack(spacing: 6) {
                    Text("\(items.count)")
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

// MARK: - Add Word
private struct WSAddWordView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var word = ""
    @State private var meaning = ""
    @State private var sentence = ""

    var onSave: (WSWordItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Word") {
                    TextField("English word", text: $word)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section("Meaning") {
                    TextField("Turkish meaning", text: $meaning)
                }
                Section("Sentence") {
                    TextField("Example sentence", text: $sentence, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Word")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = WSWordItem(
                            id: UUID().uuidString,
                            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
                            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
                            sentence: sentence.trimmingCharacters(in: .whitespacesAndNewlines),
                            dateText: wsDateText()
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func wsDateText() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f.string(from: Date())
    }
}

// MARK: - Detail
private struct WSWordDetailView: View {
    let item: WSWordItem
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

// MARK: - Hex Card (benzersiz isimler)
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

// MARK: - Scroll Offset Reader
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
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

private func wsClamp(_ x: CGFloat, _ a: CGFloat, _ b: CGFloat) -> CGFloat { min(max(x, a), b) }
private func wsLerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat { a + (b - a) * t }

