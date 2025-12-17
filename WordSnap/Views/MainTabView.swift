import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WordsView()
                .tabItem { Label("Words", systemImage: "hexagon") }

            MyLifeView()
                .tabItem { Label("MyLife", systemImage: "photo") }

            QuizView()
                .tabItem { Label("Quiz", systemImage: "questionmark.circle") }
        }
    }
}

