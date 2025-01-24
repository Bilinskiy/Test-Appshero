//
//  HomeView.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 22.01.25.
//

import SwiftUI
import SwiftData
import PhotosUI
import PinterestLikeGrid

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query() private var allImageDB: [ImageModal]
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if allImageDB.isEmpty {
                    HomeViewEmpty(select: $viewModel.selectedItem,
                                  hasPhotoAccess: $viewModel.hasPhotoAccess,
                                  isPresentedPhotosPicker: $viewModel.isPresentedPhotosPicker,
                                  alertHasPhotoAccess: $viewModel.alertHasPhotoAccess)
                } else {
                    ZStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            PinterestLikeGrid($viewModel.filterImage, columns: 2, spacing: 8) { item, index in
                                ImageCardView(item: item,
                                              hasPhotoAccess: $viewModel.hasPhotoAccess,
                                              sensoryFeedbackSaveImage: $viewModel.sensoryFeedbackSaveImage,
                                              alertHasPhotoAccess: $viewModel.alertHasPhotoAccess)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.hasPhotoAccess ? viewModel.isPresentedPhotosPicker.toggle() : viewModel.alertHasPhotoAccess.toggle()
                    } label: {
                        Image(.buttonImageAdd)
                            .renderingMode(.template)
                            .foregroundColor(.buttonAdd)
                    }
                }
            }
            .task(id: viewModel.selectedItem) {
                if let item = viewModel.selectedItem {
                    await saveData(pickerItem: item)
                    viewModel.selectedItem = nil
                }
            }
            .searchable(text: $viewModel.searchText)
        }
        .task {
            viewModel.requestPhotoLibraryAccess()
            viewModel.checkPhotoLibraryAccess()
            
            viewModel.updateData(data: allImageDB)
        }
        .photosPicker(isPresented: $viewModel.isPresentedPhotosPicker, selection: $viewModel.selectedItem)
        .sensoryFeedback(.success, trigger: viewModel.sensoryFeedbackSaveImage)
        .alert("Доступ запрещен", isPresented: $viewModel.alertHasPhotoAccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Вы запретили доступ к галерее. Пожалуйста, включите его в настройках устройства.")
        }
    }
    
    private func saveData(pickerItem: PhotosPickerItem) async {
        if let data = try? await pickerItem.loadTransferable(type: Data.self) {
            let image = viewModel.saveImageURL(data: data)
            
            modelContext.insert(image)
            
            viewModel.updateData(data: allImageDB)
        }
    }

}

#Preview {
    HomeView()
}

