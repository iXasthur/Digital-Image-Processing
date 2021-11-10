//
//  GaussianBlurImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

class GaussianBlurImageProcessor: ImageProcessor {
    let stDev: Int
    
    init(stDev: Int) {
        self.stDev = stDev
    }
    
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage {
        let cgImage = image.cgImage!
        let initialData = NSBitmapImageRep(cgImage: cgImage)
        let data = initialData.converting(to: .sRGB, renderingIntent: .default)!
        
        let radius = stDev
        
        // We scale the sigma value in proportion to the radius
        // Setting the minimum standard deviation as a baseline
        let sigma = max(Double(radius / 2), 1)
        
        // Enforces odd width kernel which ensures a center pixel is always available
        let kernelWidth = (2 * radius) + 1
        
        // Initializing the 2D array for the kernel
        var kernel = Array(repeating: Array(repeating: 0.0, count: kernelWidth), count: kernelWidth)
        var sum = 0.0
        
        // Populate every position in the kernel with the respective Gaussian distribution value
        // Remember that x and y represent how far we are away from the CENTER pixel
        for x in -radius...radius {
            for y in -radius...radius {
                let exponentNumerator = Double(-(x * x + y * y))
                let exponentDenominator = (2 * sigma * sigma)
                
                let eExpression = pow(M_E, exponentNumerator / exponentDenominator)
                let kernelValue = (eExpression / (2 * Double.pi * sigma * sigma))
                
                // We add radius to the indices to prevent out of bound issues because x and y can be negative
                kernel[x + radius][y + radius] = kernelValue
                sum += kernelValue
            }
        }
        
        // Normalize the kernel
        // This ensures that all of the values in the kernel together add up to 1
        for x in 0..<kernelWidth {
            for y in 0..<kernelWidth {
                kernel[x][y] /= sum
            }
        }
        
        // Ignoring the edges for ease of implementation
        // This will cause a thin border around the image that won't be processed
        for x in radius..<(cgImage.width - radius) {
            for y in radius..<(cgImage.height - radius) {
                if wi.isCancelled {
                    throw ImageProcessorError.cancelled("Gaussian blur r\(stDev) was cancelled")
                }
                
                var redValue = 0.0
                var greenValue = 0.0
                var blueValue = 0.0
                var alphaValue = 0.0
                
                // This is the convolution step
                // We run the kernel over this grouping of pixels centered around the pixel at (x,y)
                for kernelX in -radius...radius {
                    for kernelY in -radius...radius {
                        
                        // Load the weight for this pixel from the convolution matrix
                        let kernelValue = kernel[kernelX + radius][kernelY + radius]
                        
                        // Multiply each channel by the weight of the pixel as specified by the kernel
                        let px = x - kernelX
                        let py = y - kernelY
                        let pcolor = initialData.colorAt(x: px, y: py)!
                        redValue += pcolor.redComponent * kernelValue
                        greenValue += pcolor.greenComponent * kernelValue
                        blueValue += pcolor.blueComponent * kernelValue
                        alphaValue += pcolor.alphaComponent * kernelValue
                    }
                }
                
                // New RGB value for output image at position (x,y)
                let color = NSColor(calibratedRed: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
                data.setColor(color, atX: x, y: y)
            }
        }
        
        let cgProcessed = data.cgImage!
        return NSImage(
            cgImage: cgProcessed,
            size: NSSize(width: cgProcessed.width, height: cgProcessed.height)
        )
    }
}
