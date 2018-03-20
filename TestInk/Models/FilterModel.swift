//
//  FilterModel.swift
//  TestInk
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import CoreImage

public enum Filter: String {
    case original = "Original"
    case monochrome = "CIColorMonochrome"
    case photoEffect = "CIPhotoEffectChrome"
    case fadeEffect = "CIPhotoEffectFade"
    case vintage = "CIPhotoEffectInstant" //rename
    case blackAndWhiteLowContrast = "CIPhotoEffectMono" //rename
    case noir = "CIPhotoEffectNoir"
    case cool = "CIPhotoEffectProcess" //rename
    case blackAndWhiteNormalContrast = "CIPhotoEffectTonal" //rename
    case warm = "CIPhotoEffectTransfer" //rename
    case sepia = "CISepiaTone"
    case viginette = "CIViginette"
}

class FilterModel {
    public static func getFilters() -> [(String, Filter)] {
        return [
            (Filter.original.rawValue, Filter.original),
            ("Photo Effect", Filter.photoEffect),
            ("Fade Effect", Filter.fadeEffect),
            ("Vintage", Filter.vintage),
            ("Monochrome", Filter.monochrome),
            ("Black/White 1", Filter.blackAndWhiteLowContrast),
            ("Black/White 2", Filter.blackAndWhiteNormalContrast),
            ("Noir", Filter.noir),
            ("Cool", Filter.cool),
            ("Warm", Filter.warm),
            ("Sepia Tone", Filter.sepia),
            ("Viginette", Filter.viginette)
        ]
    }
}
