//
//  HomeViewEmpty.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 22.01.25.
//

import SwiftUI
import PhotosUI

struct HomeViewEmpty: View {
    
    @Binding var select: PhotosPickerItem?
    @Binding var hasPhotoAccess: Bool
    @Binding var isPresentedPhotosPicker: Bool
    @Binding var alertHasPhotoAccess: Bool

    var body: some View {
        VStack(spacing: 0) {
            Image(.viewIsEmpty)
                .resizable()
                .frame(width: 48, height: 48)
            Text("No projects yet")
                .font(.system(size: 19))
                .fontWeight(.bold)
                .padding(.top, 14)
            Text("Start editing your photos now")
                .font(.system(size: 13))
                .padding(.top, 6)
            
            Button {
                hasPhotoAccess ? isPresentedPhotosPicker.toggle() : alertHasPhotoAccess.toggle()
            } label: {
                Text("Start editing")
                    .font(.system(size: 13))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(.accentСolor)
                    .clipShape(.rect(cornerRadius: 26))
                    .padding(.horizontal, 75.5)
                    .padding(.top, 20)
            }

        }
    }
}

