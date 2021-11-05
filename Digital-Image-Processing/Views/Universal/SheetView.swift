//
//  SheetView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

struct SheetView: View {
    @Binding var isPresented: Bool
    
    let title: String
    let view: AnyView
    let onCancel: (() -> Void)?
    let onAccept: (() -> Void)?
    let idealWidth: CGFloat?
    let idealHeight: CGFloat?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    onCancel?()
                    
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .opacity(onCancel == nil ? 0 : 1)
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
               
                Button {
                    onAccept?()
                    
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.top, .horizontal])
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 12)
            
            ScrollView {
                view
                    .padding([.bottom, .horizontal])
            }
        }
        .frame(minWidth: 500, idealWidth: idealWidth, minHeight: 200, idealHeight: idealHeight)
    }
}
