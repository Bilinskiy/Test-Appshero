//
//  ImageCardView.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 23.01.25.
//

import SwiftUI

struct ImageCardView: View {
    
    @StateObject var viewModel: ImageCardViewModel = ImageCardViewModel()
    
    @State var item: ImageModal
    @State var animation: Bool = false
    
    @Binding var hasPhotoAccess: Bool
    @Binding var sensoryFeedbackSaveImage: Bool
    @Binding var alertHasPhotoAccess: Bool
    
    var body: some View {
   
            if let imageCompression = UIImage(contentsOfFile: item.imageData)?.jpegData(compressionQuality: 0.5), let image = UIImage(data: imageCompression) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: 30)
                            .overlay(
                                HStack(spacing: 0) {
                                    Text("\(item.name)")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.white)
                                        .padding(8)
                                    Spacer()
                                }
                            )
                            .clipShape(.rect(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
                    }
                    .onTapGesture {
                        if let image = UIImage(contentsOfFile: item.imageData), hasPhotoAccess {
                            animation = true
                            viewModel.exportImage(image: image)
                            sensoryFeedbackSaveImage.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                animation = false
                            }
                        } else {
                            alertHasPhotoAccess.toggle()
                        }
                    }
                    .overlay(alignment: .center) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.accentСolor)
                            .scaleEffect(animation ? 1.5 : 1)
                            .opacity(animation ? 1 : 0)
                            .animation(.bouncy, value: animation)
                    }
                
            
        }
        
    }
    
}
