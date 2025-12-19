import SwiftUI

struct MyLifeDetailView: View {
    let item: MyLifeItem

    private var uiImage: UIImage? {
        guard let data = item.imageData else { return nil }
        return UIImage(data: data)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {

                if let lat = item.latitude, let lon = item.longitude {
                    ZStack(alignment: .top) {
                        MyLifeMapView(
                            latitude: lat,
                            longitude: lon,
                            title: item.wordEN,
                            pinColor: Color(hex: item.pinHex)
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 10)

                        if let img = uiImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: 6))
                                .shadow(radius: 8, y: 6)
                                .padding(.top, 180)
                        }
                    }
                } else {
                    if let img = uiImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 6))
                            .shadow(radius: 8, y: 6)
                            .padding(.top, 14)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(item.wordEN)
                        .font(.system(size: 28, weight: .bold))

                    Text(item.wordTR)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.secondary)

                   

                    Divider().padding(.vertical, 4)

                    Text("My meaning")
                        .font(.headline)
                    Text(item.personalMeaning)

                    Divider().padding(.vertical, 4)

                    Text("Example")
                        .font(.headline)
                    Text("• \(item.example)")

                    Text(item.createdAtText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, uiImage == nil ? 10 : 4)

                Color.clear.frame(height: 30)
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

