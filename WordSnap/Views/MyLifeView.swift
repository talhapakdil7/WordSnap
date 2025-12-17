import SwiftUI

struct MyLifeView: View {
    var body: some View {
        ZStack {
            SoftHexBackground()
            Text("MyLife")
                .font(.largeTitle).bold()
        }
    }
}

