import SwiftUI

struct SoftHexBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.white, Color.white.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(.orange.opacity(0.18))
                .frame(width: 380, height: 380)
                .blur(radius: 30)
                .offset(x: 130, y: -230)

            Circle()
                .fill(.yellow.opacity(0.14))
                .frame(width: 420, height: 420)
                .blur(radius: 40)
                .offset(x: -150, y: -160)

            Circle()
                .fill(.blue.opacity(0.10))
                .frame(width: 460, height: 460)
                .blur(radius: 45)
                .offset(x: 0, y: 260)
        }
    }
}

