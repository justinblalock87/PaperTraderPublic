//
//  ProfileView.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/4/23.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ProfileView: View {
    
    @State var currentUser: User?
    @State var newProfilePicture = UIImage()
    @State var isShowingImagePicker = false
    
    var segueToAccounts: (() -> Void)?
    
    var body: some View {
        ZStack {
            DarkColorTheme.darkBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    profilePictureView
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        .onTapGesture {
                            isShowingImagePicker = true
                        }
                        .sheet(isPresented: $isShowingImagePicker, content: {
                            ProfilePhotoPicker(profileImage: $newProfilePicture)
                        })
                        .onChange(of: newProfilePicture, perform: { _ in
                            saveEdits()
                        })
                    
                    paperAccounts
                        .padding(.bottom, 30)
                    
                    PortfolioChartView(viewModel: PortfolioViewModel())
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
            }
            .task(priority: .userInitiated, {
                currentUser = try? await UserManager.getCurrentUser()
                try? await StockManager.fetchPortfolioHistory()
            })
        }
        .analyticsScreen(name: "Profile")
    }
    
    private var profilePictureView: some View {
        VStack(spacing: 10) {
            ZStack {
                if newProfilePicture != UIImage() {
                    Image(uiImage: newProfilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(150)
                        .clipped()
                } else {
                    KFImage(URL(string: currentUser?.profilePictureURL ?? ""))
                        .resizable()
                        .placeholder {
                            Circle()
                                .foregroundColor(ColorTheme.lightGray)
                        }
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(150)
                        .clipped()
                }
                
                Image(systemName: "pencil.circle")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(8)
                    .background(ColorTheme.newGray.opacity(0.7))
                    .clipShape(Circle())
                    .padding(10)
                    .offset(x: 50, y: -50)
            }
            VStack(spacing: 6) {
                Text("\(currentUser?.name ?? "")")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .frame(alignment: .center)
                Text("\(currentUser?.username ?? "")")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .frame(alignment: .center)
            }
        }
        .padding(.top, 20)
    }
    
    private var paperAccounts: some View {
        VStack {
            Divider()
            HStack(alignment: .center) {
                Text("Active Paper Account")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(currentUser?.activePaperAccount ?? "")")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.vertical, 10)
            .onTapGesture {
                segueToAccounts?()
            }
            .padding(.horizontal)
            Divider()
        }
    }
    private func saveEdits() {
        Task.init {
            try? await UserManager.updateProfilePicture(image: newProfilePicture)
        }
    }
}

struct ProfilePhotoPicker: UIViewControllerRepresentable {
    
    @Binding var profileImage: UIImage
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
    
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
    
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ProfilePhotoPicker

        init(_ parent: ProfilePhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                picker.dismiss(animated: true)
                return
            }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    Task.init {
                        await MainActor.run {
                            picker.dismiss(animated: true)
                            guard let image = image as? UIImage else {
                                return
                            }
                            self?.parent.profileImage = image
                        }
                    }
                }
            }
        }
        
        private func cropToCircle(_ image: UIImage) -> UIImage {
            let imageSize = image.size
            let shortestSide = min(imageSize.width, imageSize.height)
            let size = CGSize(width: shortestSide, height: shortestSide)
            let origin = CGPoint(x: (imageSize.width - shortestSide) / 2, y: (imageSize.height - shortestSide) / 2)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
            let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            path.addClip()
            image.draw(at: CGPoint(x: -origin.x, y: -origin.y))
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return croppedImage ?? image
        }
    }
}

#Preview {
    ProfileView()
}
