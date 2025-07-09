//
//  PhotoViewModel.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI
import AVFoundation
import Photos
import Vision

class PhotoViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showPermissionAlert = false
    @Published var alertMessage = ""
    @Published var mouthRect: CGRect?
    @Published var outerLipPoints: [CGPoint] = []
    @Published var lipColor: Color = .red
    @Published var didDetectLips: Bool? = false

    func choosePhoto() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.sourceType = .photoLibrary
                    self.showImagePicker = true
                } else {
                    self.alertMessage = "The app needs access to the photo library to select an image"
                    self.showPermissionAlert = true
                }
            }
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func detectLips() {
        guard let image = selectedImage, let cgImage = image.cgImage else {
            self.outerLipPoints = []
            self.didDetectLips = false
            return
        }
        let request = VNDetectFaceLandmarksRequest { request, error in
            guard let results = request.results as? [VNFaceObservation],
                  let face = results.first,
                  let landmarks = face.landmarks,
                  let outerLips = landmarks.outerLips else {
                DispatchQueue.main.async {
                    self.outerLipPoints = []
                    self.didDetectLips = false
                }
                return
            }
            let boundingBox = face.boundingBox
            let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
            let points = outerLips.normalizedPoints.map { point -> CGPoint in
                let x = boundingBox.origin.x + point.x * boundingBox.size.width
                let y = boundingBox.origin.y + point.y * boundingBox.size.height
                return CGPoint(x: x * imageSize.width, y: (1 - y) * imageSize.height)
            }
            DispatchQueue.main.async {
                self.outerLipPoints = points
                self.didDetectLips = !points.isEmpty
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            try? handler.perform([request])
        }
    }
}
