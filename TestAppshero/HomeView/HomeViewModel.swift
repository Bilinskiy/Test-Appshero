//
//  HomeViewModel.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 22.01.25.
//

import SwiftUI
import SwiftData
import PhotosUI
import Combine

class HomeViewModel: ObservableObject {
    
    //MARK: Property
    private var authorizationStatus = PHAuthorizationStatus.notDetermined
    
    private var subscription: Set<AnyCancellable> = []
    
    @Published var hasPhotoAccess: Bool = false
    @Published var alertHasPhotoAccess: Bool = false
    @Published var isPresentedPhotosPicker: Bool = false
    @Published var sensoryFeedbackSaveImage: Bool = false

    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var allImage = [ImageModal]()
    @Published var filterImage = [ImageModal]()
    @Published var searchText = ""
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink {  [weak self] searchText in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.filterImage = self.allImage
                } else {
                    self.filterImage = self.allImage.filter { $0.name.contains(searchText) }
                }
            }
            .store(in: &subscription)
    }
    
    private let namesImage = ["Sunset", "Mountain", "Beach", "Forest",
                              "Cityscape","Portrait", "Pet", "Food",
                              "Flower", "Building","Lake", "Art",
                              "Landscape", "Tree", "Cloud", "River",
                              "Snow", "Sand", "Road", "Horizon"]
    
    //MARK: Function createName
    func createName() -> String {
        if let name = namesImage.randomElement() {
            return "\(name)-\(allImage.count + 1)"
        }
        return ""
    }
    
    //MARK: Function saveImageURL
    func saveImageURL(data: Data) -> ImageModal {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print (documentsDirectory)
        
        let name = createName()
        let fileName = name + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error.localizedDescription)")
        }
        
        return ImageModal(imageData: fileURL.path(), name: name)
    }
    
    //MARK: Function updateData
    func updateData(data: [ImageModal]) {
        allImage = data
        filterImage = data
    }
    
    //MARK: Function checkPhotoLibraryAccess
    func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            hasPhotoAccess = true
        case .denied, .restricted:
            hasPhotoAccess = false
        case .notDetermined:
            hasPhotoAccess = false
        @unknown default:
            hasPhotoAccess = false
        }
    }
    
    //MARK: Function requestPhotoLibraryAccess
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                switch newStatus {
                case .authorized, .limited:
                    self.hasPhotoAccess = true
                case .denied, .restricted:
                    self.hasPhotoAccess = false
                case .notDetermined:
                    self.hasPhotoAccess = false
                @unknown default:
                    self.hasPhotoAccess = false
                }
            }
        }
    }
    
    
}

