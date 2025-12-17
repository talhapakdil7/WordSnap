import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        let p1 = CGPoint(x: w * 0.5, y: 0)
        let p2 = CGPoint(x: w, y: h * 0.25)
        let p3 = CGPoint(x: w, y: h * 0.75)
        let p4 = CGPoint(x: w * 0.5, y: h)
        let p5 = CGPoint(x: 0, y: h * 0.75)
        let p6 = CGPoint(x: 0, y: h * 0.25)

        var path = Path()
        path.move(to: p1)
        path.addLines([p2, p3, p4, p5, p6, p1])
        return path
    }
}

