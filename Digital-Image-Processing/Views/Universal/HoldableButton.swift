//
//  HoldableButton.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 25.09.2021.
//

import SwiftUI

struct HoldableButton: View {
    
    @State private var holding = false
    
    var icon0: String
    var icon1: String
    
    var onTap: () -> Void
    var onRelease: () -> Void
    
    var isHolding: Bool {
        return holding
    }
    
    var body: some View {
        Button {
            // Do nothing
        } label: {
            Image(systemName: holding ? icon1 : icon0)
                .font(.headline)
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20, alignment: .trailing)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if !holding {
                        holding = true
                        onTap()
                    }
                })
                .onEnded({ _ in
                    holding = false
                    onRelease()
                })
        )
    }
}
