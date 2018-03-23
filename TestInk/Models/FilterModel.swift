//
//  FilterModel.swift
//  TestInk
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
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
    
    public static func filterImage(_ image: UIImage, withFilter filter: Filter) -> UIImage {
        if
            let ciImage = CIImage(image: image), //create Core Image from UI Image so you can do CoreImage stuff to it
            let ciFilter = CIFilter(name: filter.rawValue), //create CoreImage filter from the name of filter passed in
            filter != .original
        {
            //set the ciImage as the value for the InputImagKey, which is a key the CI filter object uses to check which image to use for filtering
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = ciFilter.outputImage { //after filtering, the filtered image is stored in the "outputImage property"
                //convert CIImage back to UIImage
                let context = CIContext()
                //must convert CIImage to CGImage because the CIImage must be rendered into a UIImage
                    //UIImage needs bitmap-based image
                //source: https://stackoverflow.com/questions/32875114/why-cant-i-invert-my-image-back-to-original-with-cifilter-in-my-swift-ios-app
                if let cgImage = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)) {
                    let filteredImage = UIImage(cgImage: cgImage)
                    return filteredImage
                }
            }
        }
        return image
    }
}
