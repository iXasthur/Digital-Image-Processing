//
//  CGImageExtensions.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 10.11.2021.
//

import AppKit

extension CGImage {
    func withCroppedBorder(ds: Int) -> CGImage {
        let cropRect: CGRect = CGRect(x: ds, y: ds, width: width - (2 * ds), height: height - (2 * ds))
        return cropping(to: cropRect)!
    }
}
