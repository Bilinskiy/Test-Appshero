//
//  ImageCardViewModel.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 24.01.25.
//

import Foundation
import PhotosUI

class ImageCardViewModel: ObservableObject {
    
    //MARK: Function exportImage
    func exportImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
