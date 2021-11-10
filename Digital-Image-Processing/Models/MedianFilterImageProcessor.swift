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
        
        let windowSideSize = (2 * radius) + 1
        var window: [NSColor] = []
        for _ in 0..<(windowSideSize * windowSideSize) {
            window.append(.black)
        }
        
        for x in radius..<(initialWidth - radius) {
            for y in radius..<(initialHeight - radius) {
                if wi.isCancelled {
                    throw ImageProcessorError.cancelled("Median filter r\(radius) was cancelled")
                }
                
                var i = 0
                for fx in 0..<windowSideSize {
                    for fy in 0..<windowSideSize {
                        window[i] = initialBitmap.colorAt(x: x + fx - radius, y: y + fy - radius)!
                        i += 1
                    }
                }
                
                window.sort { color0, color1 in
                    return color0.brightnessComponent < color1.brightnessComponent
                }
                
                processedBitmap.setColor(window[windowSideSize * windowSideSize / 2], atX: x, y: y)
            }
        }
        
        let cgProcessed = processedBitmap.cgImage!.withCroppedBorder(ds: radius)
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
