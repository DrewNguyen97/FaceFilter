//
//  PhotoView.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI
import UIKit

struct PhotoView: View {
    @StateObject private var viewModel = PhotoViewModel()

    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                GeometryReader { geo in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .onAppear {
                                viewModel.detectLips()
                            }

                        if !viewModel.outerLipPoints.isEmpty {
                            LipOverlayView(
                                points: viewModel.outerLipPoints,
                                imageSize: image.size,
                                containerSize: geo.size,
                                color: viewModel.lipColor
                            )
                        }
                    }
                }
                .frame(height: 600)
                if let detected = viewModel.didDetectLips {
                    Text(detected ? "Lips have been detected" : "No lips were detected in the image")
                        .foregroundColor(detected ? .green : .red)
                        .font(.subheadline)
                        .padding(.top, 4)
                    if detected {
                        ColorPicker("Lip Color", selection: $viewModel.lipColor)
                            .padding()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(Text("No image selected"))
                    .padding()
            }
            CustomButton(title: "Pick a photo") {
                viewModel.choosePhoto()
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker, onDismiss: {
            viewModel.detectLips()
        }) {
            ImagePicker(sourceType: viewModel.sourceType, selectedImage: $viewModel.selectedImage)
        }
        .alert(isPresented: $viewModel.showPermissionAlert) {
            Alert(
                title: Text("Access denied"),
                message: Text(viewModel.alertMessage),
                primaryButton: .default(Text("Open setting")) {
                    viewModel.openSettings()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}
