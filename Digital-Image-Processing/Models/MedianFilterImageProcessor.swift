//
//  MedianFilterImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

class MedianFilterImageProcessor: ImageProcessor {
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage {
        let cgImage = image.cgImage!
        let initialData = NSBitmapImageRep(cgImage: cgImage)
        let data = initialData.converting(to: .sRGB, renderingIntent: .default)!
        
        throw ImageProcessorError.cancelled("Median filter is not implemented")
        
        let cgProcessed = data.cgImage!
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
