import SwiftUI

struct RootView: View {
    
    @StateObject private var authVM = AuthViewModel()

    
    var body: some View {
        Group {
            if authVM.user != nil {
                MainTabView()
            } else {
                AuthView()
            }
        }
        .environmentObject(authVM)
    }
}

