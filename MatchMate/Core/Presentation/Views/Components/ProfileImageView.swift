//
//  ProfileImageView.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//


import SwiftUI

struct ProfileImageView: View {
    let imageURL: String
    let size: CGFloat
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var hasError = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(Color.gray.opacity(0.2))
                .frame(width: size, height: size)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.1))
            } else if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else if hasError {
                VStack(spacing: 4) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.gray)
                    
                    Text("Failed")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURL) else {
            hasError = true
            return
        }
        
        isLoading = true
        hasError = false
        
//        ImageCache.shared.image(for: url)
//            .sink { loadedImage in
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    if let loadedImage = loadedImage {
//                        self.image = loadedImage
//                    } else {
//                        self.hasError = true
//                    }
//                }
//            }
//            .store(in: &cancellables)
    }
    
//    @State private var cancellables = Set<AnyCancellable>()
}
