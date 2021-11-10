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
    static private let defaultBlurBoxSize = 3
    static private let defaultGaussianStDev = 1
    
    @State private var checkedSampleImage: Bool = false
    
    @State private var selectedFilterType: ImageFilterType = .boxBlur
    @State private var selectedImage: NSImage? = nil
    @State private var filteredImage: NSImage? = nil
    
    @State private var boxBlurBoxSizeD: Double = Double(defaultBlurBoxSize)
    @State private var gaussianStDevD: Double = Double(defaultGaussianStDev)
    
    @State private var filterWorkItem: DispatchWorkItem? = nil
    
    func filterImage() {
        filterWorkItem?.cancel()
        filterWorkItem = nil
        filteredImage = nil
        
        if let selectedImage = selectedImage {
            var wi: DispatchWorkItem? = nil
            wi = DispatchWorkItem {
                do {
                    let filtered = try imageProcessor.process(image: selectedImage, wi: wi!)
                    DispatchQueue.main.async {
                        self.filteredImage = filtered
                    }
                } catch {
                    print("Error processing image: \(error)")
                }
            }
            
            filterWorkItem = wi
            
            DispatchQueue.global(qos: .default).asyncAfter(
                deadline: .now() + 0.5,
                execute: wi!
            )
        }
    }
    
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
                    self.filterImage()
                }
            }
        })
    }
    
    var filterConfiguratorBody: AnyView {
        switch selectedFilterType {
        case .boxBlur:
            return AnyView(
                VStack(alignment: .leading) {
                    Text("Box Size")
                    HStack {
                        Slider(
                            value: $boxBlurBoxSizeD,
                            in: 3...15,
                            step: 2
                        ).onChange(of: boxBlurBoxSizeD) { _ in
                            filterImage()
                        }
                        Text("\(Int(boxBlurBoxSizeD))")
                            .frame(minWidth: 20, alignment: .trailing)
                    }
                }
                    .padding(.top)
            )
        case .gaussianBlur:
            return AnyView(
                VStack(alignment: .leading) {
                    Text("Radius")
                    HStack {
                        Slider(
                            value: $gaussianStDevD,
                            in: 1...10,
                            step: 1
                        ).onChange(of: gaussianStDevD) { _ in
                            filterImage()
                        }
                        Text("\(Int(gaussianStDevD))")
                            .frame(minWidth: 20, alignment: .trailing)
                    }
                }
                    .padding(.top)
            )
        case .median:
            return AnyView(EmptyView())
        case .sobel:
            return AnyView(EmptyView())
        }
    }
    
    var imageProcessor: ImageProcessor {
        switch selectedFilterType {
        case .boxBlur:
            return BoxBlurImageProcessor(boxSize: Int(boxBlurBoxSizeD))
        case .gaussianBlur:
            return GaussianBlurImageProcessor(stDev: Int(gaussianStDevD))
        case .median:
            return MedianFilterImageProcessor()
        case .sobel:
            return SobelFilterImageProcessor()
        }
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
            .onChange(of: selectedFilterType) { _ in
                filterImage()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    imageSelectionButtonBody
                    filterConfiguratorBody
                    Spacer()
                }
                .frame(width: 180, alignment: .leading)
                
                Divider()
                
                Spacer()
                
                if selectedImage != nil {
                    VStack {
                        HStack {
                            Text("Initial")
                                .font(.headline)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Text("Processed")
                                .font(.headline)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack {
                            ImageView(image: selectedImage!)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                if filteredImage != nil {
                                    ImageView(image: filteredImage!)
                                } else {
                                    Spacer()
                                    ProgressView()
                                        .scaleEffect(0.75, anchor: .center)
                                    Spacer()
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
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
        .onAppear {
            if !checkedSampleImage {
                checkedSampleImage = true
                
                let samplePath = "/Users/ro/Downloads/filter-sample.png"
                if FileManager.default.fileExists(atPath: samplePath) {
                    selectedImage = NSImage(byReferencingFile: samplePath)!
                    filterImage()
                }
            }
        }
    }
}
