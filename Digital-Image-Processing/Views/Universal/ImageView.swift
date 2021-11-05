//
//  ImageView.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import SwiftUI

struct ImageView: View {
    let image: NSImage
    
    var body: some View {
        Image(nsImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
