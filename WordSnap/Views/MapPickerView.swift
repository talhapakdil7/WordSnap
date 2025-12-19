import SwiftUI
import MapKit

struct MapPickerResult: Equatable {
    let latitude: Double
    let longitude: Double
    let title: String
}

struct MapPickerView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784), // İstanbul
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    @State private var pickedCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)

    var onPick: (MapPickerResult) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $position) {
                    Annotation("Picked", coordinate: pickedCoord) {
                        ZStack {
                            Circle().fill(.white).frame(width: 30, height: 30)
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 26))
                                .foregroundStyle(.red)
                        }
                    }
                }
                .onMapCameraChange { ctx in
                    pickedCoord = ctx.region.center
                }
                .ignoresSafeArea()

                // Ortadaki hedef işareti (kamera merkezini seçiyoruz)
                VStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(.bottom, 26)
                }
                .allowsHitTesting(false)
            }
            .navigationTitle("Pick Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Use") {
                        let lat = pickedCoord.latitude
                        let lon = pickedCoord.longitude
                        let title = String(format: "%.5f, %.5f", lat, lon)
                        onPick(.init(latitude: lat, longitude: lon, title: title))
                        dismiss()
                    }
                }
            }
        }
    }
}

