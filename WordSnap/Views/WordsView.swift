
import SwiftUI

struct WordsView: View {

    @StateObject private var vm = WordsViewModel()

    @State private var showAddWord = false
    @State private var selectedWord: WSWord? = nil
    @State private var activeIndex: Int = 0

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 10)

                    if let msg = vm.errorMessage, !msg.isEmpty {
                        Text(msg)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 18)
                            .padding(.top, 8)
                    }

                    Color.clear.frame(height: 30)

                    // ✅ ÜSTTEKİ SABİT HEX KALDIRILDI
                    // Artık sadece aşağıdaki hex listesi var.

                    VStack(spacing: 18) {
                        ForEach(Array(vm.items.enumerated()), id: \.element.id) { idx, it in
                            let isActive = idx == activeIndex

                            HStack {
                                if idx.isMultiple(of: 2) { Spacer() }

                                WSHexTextCard(
                                    size: isActive ? 280 : 230,
                                    fill: Color.orange.opacity(isActive ? 1.0 : 0.55),
                                    title: it.word,
                                    subtitle: it.meaning,
                                    date: it.dateText,
                                    titleSize: isActive ? 22 : 18,
                                    bodySize: 14,
                                    textColor: .white
                                )
                                .scaleEffect(isActive ? 1.08 : 1.0)
                                .shadow(radius: isActive ? 22 : 12, x: 0, y: isActive ? 14 : 8)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.40, dampingFraction: 0.75)) {
                                        activeIndex = idx
                                    }
                                    selectedWord = it
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        Task { await vm.deleteWord(id: it.id) }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }

                                if !idx.isMultiple(of: 2) { Spacer() }
                            }
                            .padding(.horizontal, 18)
                        }
                    }
                    .padding(.top, 8)

                    Color.clear.frame(height: 260)
                }
            }

            // sağ üst + butonu
            VStack {
                HStack {
                    Spacer()
                    Button { showAddWord = true } label: {
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
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
        .sheet(isPresented: $showAddWord) {
            WSAddWordSheetFirestore { word, meaning, sentence, dateText in
                Task {
                    await vm.addWord(word: word, meaning: meaning, sentence: sentence, dateText: dateText)
                    activeIndex = 0
                }
            }
        }
        // ✅ POPUP YARI SAYFA (medium)
        .sheet(item: $selectedWord) { it in
            WSWordDetailSheet(item: it)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
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
                    Text("\(vm.items.count)")
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
