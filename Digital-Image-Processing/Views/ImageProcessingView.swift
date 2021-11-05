//
//  ImageProcessingView.swift
//  Digital-Image-Processing
//
//  Created by Михаил Ковалевский on 05.11.2021.
//

import SwiftUI
import Quartz

fileprivate enum ImageFilterType: String, CaseIterable, Identifiable {
    case boxBlur = "Box Blur"
    case gaussianBlur = "Gaussian Blur"
    case median = "Median Filter"
    case sobel = "Sobel Filter"
    
    var id: String { self.rawValue }
}

struct ImageProcessingView: View {
    @State private var selectedFilterType: ImageFilterType = .boxBlur
    @State private var selectedImage: NSImage? = nil
    
    var imageSelectionButtonBody: some View {
        return Button("Open Image", action: {
            let openPanel = NSOpenPanel()
            openPanel.prompt = "Open Image"
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseDirectories = false
            openPanel.canCreateDirectories = false
            openPanel.canChooseFiles = true
            openPanel.allowedContentTypes = [.image]
            openPanel.begin { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    let selectedPath = openPanel.url!.path
                    self.selectedImage = NSImage(byReferencingFile: selectedPath)!
                }
            }
        })
    }
    
    var filterConfiguratorBody: AnyView {
        let view: AnyView = AnyView(EmptyView())
        
        switch selectedFilterType {
        case .boxBlur:
            break
        case .gaussianBlur:
            break
        case .median:
            break
        case .sobel:
            break
        }
        
        return view
    }
    
    var imageProcessor: ImageProcessor {
        switch selectedFilterType {
        case .boxBlur:
            return BoxBlurImageProcessor()
        case .gaussianBlur:
            return GaussianBlurImageProcessor()
        case .median:
            return MedianFilterImageProcessor()
        case .sobel:
            return SobelFilterImageProcessor()
        }
    }
    
    var filteredImage: NSImage? {
        if let selectedImage = selectedImage {
            return imageProcessor.process(image: selectedImage)
        }
        
        return nil
    }
    
    var body: some View {
        VStack {
            Picker("Filter Type", selection: $selectedFilterType) {
                ForEach(ImageFilterType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .font(.headline)
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                VStack(alignment: .leading) {
                    imageSelectionButtonBody
                    filterConfiguratorBody
                    Spacer()
                }
                .frame(minWidth: 180, alignment: .leading)
                
                Divider()
                
                Spacer()
                
                if selectedImage != nil {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Initial")
                                .font(.headline)
                            ImageView(image: selectedImage!)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Processed")
                                .font(.headline)
                            ImageView(image: filteredImage!)
                        }
                        
                        Spacer()
                    }
                } else {
                    Text("There is no image selected")
                }

                Spacer()
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}
