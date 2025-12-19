// ✅ Views/AddMyLifeView.swift  (PIN RENGİ EKLİ – TAMAMINI BUNUNLA DEĞİŞTİR)
import SwiftUI

struct AddMyLifeView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var wordEN = ""
    @State private var wordTR = ""
    @State private var personalMeaning = ""
    @State private var example = ""

    @State private var showMapPicker = false
    @State private var pickedLat: Double?
    @State private var pickedLon: Double?
    @State private var pickedTitle: String?

    @State private var selectedUIImage: UIImage?
    @State private var showImageDialog = false
    @State private var showPickerSheet = false
    @State private var imageSource: WSImageSource = .photoLibrary

    // ✅ kullanıcı pin rengi
    @State private var pinColor: Color = .green

    var onSave: (MyLifeItem) -> Void

    var body: some View {
        NavigationStack {
            Form {

                Section("Photo") {
                    HStack {
                        Spacer()
                        Button { showImageDialog = true } label: {
                            ZStack(alignment: .bottomTrailing) {
                                if let img = selectedUIImage {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 110, height: 110)
                                        .overlay {
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 26))
                                                .foregroundStyle(.secondary)
                                        }
                                }

                                Circle()
                                    .fill(.white)
                                    .frame(width: 34, height: 34)
                                    .shadow(radius: 3)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .offset(x: 6, y: 6)
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                }

                Section("Word") {
                    TextField("English", text: $wordEN)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Turkish meaning", text: $wordTR)
                }

                Section("My association") {
                    TextField("What does this word mean to you?", text: $personalMeaning, axis: .vertical)
                }

                Section("Example sentence") {
                    TextField("Example", text: $example, axis: .vertical)
                }

                // ✅ pin rengi seç
                Section("Pin color") {
                    ColorPicker("Choose pin color", selection: $pinColor, supportsOpacity: false)
                }

                Section("Location") {
                    HStack {
                        Text(pickedTitle ?? "No location selected")
                            .foregroundStyle(pickedTitle == nil ? .secondary : .primary)
                        Spacer()
                        Button("Pick") { showMapPicker = true }
                    }
                }
            }
            .navigationTitle("Add MyLife")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = MyLifeItem(
                            id: UUID().uuidString,
                            wordEN: wordEN,
                            wordTR: wordTR,
                            personalMeaning: personalMeaning,
                            example: example,
                            imageData: selectedUIImage?.jpegData(compressionQuality: 0.85),
                            latitude: pickedLat,
                            longitude: pickedLon,
                            locationTitle: pickedTitle,
                            pinHex: pinColor.toHexFallback(), // ✅ şimdilik default
                            createdAtText: dateText()
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(wordEN.isEmpty || wordTR.isEmpty || personalMeaning.isEmpty || example.isEmpty)
                }
            }
            .confirmationDialog("Add Photo", isPresented: $showImageDialog) {
                Button("Take Photo") { imageSource = .camera; showPickerSheet = true }
                Button("Choose from Gallery") { imageSource = .photoLibrary; showPickerSheet = true }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showPickerSheet) {
                WSImagePicker(source: imageSource, selectedImage: $selectedUIImage)
            }
            .sheet(isPresented: $showMapPicker) {
                MapPickerView { result in
                    pickedLat = result.latitude
                    pickedLon = result.longitude
                    pickedTitle = result.title
                }
                .presentationDetents([.large])
            }
        }
    }

    private func dateText() -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f.string(from: Date())
    }
}

