//
//  ImageProcessor.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import AppKit

protocol ImageProcessor {
    func process(image: NSImage) -> NSImage
}
