//
//  Model.swift
//  TestAppshero
//
//  Created by Дмитрий Билинский on 22.01.25.
//

import SwiftData
import SwiftUI

@Model
final class ImageModal {
    @Attribute(.unique) var id: UUID
    var imageData: String
    var name: String
    
    init(imageData: String, name: String) {
        self.id = UUID()
        self.imageData = imageData
        self.name = name
    }
}

