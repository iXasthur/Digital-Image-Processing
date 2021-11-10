//
//  BoxBlurImageProcessor.swift.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

class BoxBlurImageProcessor: ImageProcessor {
    let boxSize: Int
    
    init(boxSize: Int) {
        if boxSize % 2 == 0 {
            fatalError()
        }
        
        self.boxSize = boxSize
    }
    
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage {
        let ds = boxSize / 2
        
        let initialWidth = image.cgImage!.width
        let initialHeight = image.cgImage!.height
        let initialBitmap = image.getBitmapCopy(colorSpace: .sRGB)
        let processedBitmap = initialBitmap.copy() as! NSBitmapImageRep
        
        for x in ds..<initialWidth-ds {
            for y in ds..<initialHeight-ds {
                if wi.isCancelled {
                    throw ImageProcessorError.cancelled("Box blur \(boxSize)x\(boxSize) was cancelled")
                }
                
                var rf: CGFloat = 0
                var gf: CGFloat = 0
                var bf: CGFloat = 0
                var af: CGFloat = 0

                for i in x-ds...x+ds {
                    for j in y-ds...y+ds {
                        let pixel = initialBitmap.colorAt(x: i, y: j)!
                        rf += pixel.redComponent
                        gf += pixel.greenComponent
                        bf += pixel.blueComponent
                        af += pixel.alphaComponent
                    }
                }

                rf /= CGFloat(boxSize * boxSize)
                gf /= CGFloat(boxSize * boxSize)
                bf /= CGFloat(boxSize * boxSize)
                af /= CGFloat(boxSize * boxSize)

                let color = NSColor(calibratedRed: rf, green: gf, blue: bf, alpha: af)
                processedBitmap.setColor(color, atX: x, y: y)
            }
        }
        
        let cgProcessed = processedBitmap.cgImage!.withCroppedBorder(ds: ds)
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
