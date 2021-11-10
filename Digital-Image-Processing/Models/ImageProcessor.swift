//
//  ImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

enum ImageProcessorError: Error {
    case cancelled(String)
}

protocol ImageProcessor {
    func process(image: NSImage, wi: DispatchWorkItem) throws -> NSImage
}
