//
//  SobelFilterImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

class SobelFilterImageProcessor: ImageProcessor {
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage {
        let initialWidth = image.cgImage!.width
        let initialHeight = image.cgImage!.height
        let initialBitmap = image.getBitmapCopy(colorSpace: .sRGB)
        let processedBitmap = initialBitmap.copy() as! NSBitmapImageRep
        
        throw ImageProcessorError.cancelled("Sobel filter is not implemented")
        
        let cgProcessed = processedBitmap.cgImage!
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
