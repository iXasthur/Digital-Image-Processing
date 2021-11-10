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
        
        let cgImage = image.cgImage!.copy()!
        
        let initialData = NSBitmapImageRep(cgImage: cgImage)
        let data = initialData.converting(to: .genericRGB, renderingIntent: .default)!
        
        for x in ds..<cgImage.width-ds {
            for y in ds..<cgImage.height-ds {
                if wi.isCancelled {
                    throw ImageProcessorError.cancelled("Box blur \(boxSize)x\(boxSize) was cancelled")
                }
                
                var rf: CGFloat = 0
                var gf: CGFloat = 0
                var bf: CGFloat = 0
                var af: CGFloat = 0

                for i in x-ds...x+ds {
                    for j in y-ds...y+ds {
                        let pixel = initialData.colorAt(x: i, y: j)!
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
                data.setColor(color, atX: x, y: y)
            }
        }
        
        let cropRect: CGRect = CGRect(
            x: ds,
            y: ds,
            width: Int(image.size.width) - (2 * ds),
            height: Int(image.size.height) - (2 * ds)
        )
        let cgProcessed = data.cgImage!.cropping(to: cropRect)!
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
