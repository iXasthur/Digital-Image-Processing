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
        let initialBitmap = image.getBitmapCopy(colorSpace: .genericGray)
        let processedBitmap = initialBitmap.copy() as! NSBitmapImageRep
        
        let kernelX: [[CGFloat]] = [
            [-1, 0, 1],
            [-2, 0, 2],
            [-1, 0, 1]
        ]
        
        let kernelY: [[CGFloat]] = [
            [-1, -2, -1],
            [ 0,  0,  0],
            [ 1,  2,  1]
        ]
        
        for x in 1..<(initialWidth - 1) {
            for y in 1..<(initialHeight - 1) {
                if wi.isCancelled {
                    throw ImageProcessorError.cancelled("Sobel filter was cancelled")
                }
                
                var pixelX: CGFloat = 0
                var pixelY: CGFloat = 0
                for i in 0..<3 {
                    for j in 0..<3 {
                        let px = x + (i - 1)
                        let py = y + (j - 1)
                        let brV: CGFloat = initialBitmap.colorAt(x: px, y: py)!.whiteComponent
                        pixelX += kernelX[i][j] * brV
                        pixelY += kernelY[i][j] * brV
                    }
                }
                
                let pixel = hypot(pixelX, pixelY)
                processedBitmap.setColor(NSColor(calibratedWhite: pixel, alpha: 1), atX: x, y: y)
            }
        }
        
        let cgProcessed = processedBitmap.cgImage!.withCroppedBorder(ds: 1)
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
