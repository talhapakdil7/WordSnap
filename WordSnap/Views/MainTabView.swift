import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        TabView {
            WordsView()
                .tabItem { Label("Words", systemImage: "hexagon") }

            MyLifeView()
                .tabItem { Label("MyLife", systemImage: "photo") }

            QuizView()
                .tabItem { Label("Quiz", systemImage: "questionmark.circle") }
        }
        .overlay(alignment: .topTrailing) {
            Button("Sign Out") { authVM.signOut() }
                .font(.footnote)
                .padding(10)
        }
    }
}

