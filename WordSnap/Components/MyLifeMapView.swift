// ✅ Components/MyLifeMapView.swift  (TAMAMINI BUNUNLA DEĞİŞTİR)
import SwiftUI
import MapKit

struct MyLifeMapView: View {
    let latitude: Double
    let longitude: Double
    let title: String           // ✅ pin üstünde yazı
    let pinColor: Color         // ✅ kullanıcı rengi

    @State private var position: MapCameraPosition

    init(latitude: Double, longitude: Double, title: String, pinColor: Color) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.pinColor = pinColor

        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            )
        ))
    }

    var body: some View {
        let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        Map(position: $position) {
            Annotation(title, coordinate: coord, anchor: .bottom) {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 3, y: 2)

                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(pinColor)
                        .shadow(radius: 6, y: 4)
                }
            }
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
