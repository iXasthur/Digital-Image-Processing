//
//  MedianFilterImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

class MedianFilterImageProcessor: ImageProcessor {
    let radius: Int
    
    init(radius: Int) {
        self.radius = radius
    }
    
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage {
        let initialWidth = image.cgImage!.width
        let initialHeight = image.cgImage!.height
        let initialBitmap = image.getBitmapCopy(colorSpace: .sRGB)
        let processedBitmap = initialBitmap.copy() as! NSBitmapImageRep
        
//        if wi.isCancelled {
//            throw ImageProcessorError.cancelled("Median filter r\(radius) was cancelled")
//        }
        
        let cgProcessed = processedBitmap.cgImage!.withCroppedBorder(ds: radius)
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
