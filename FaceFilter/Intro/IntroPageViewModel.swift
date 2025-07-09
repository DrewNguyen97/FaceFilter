//
//  IntroPageViewModel.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI

class IntroViewModel: ObservableObject {
    @Published var currentPage = 0
    @AppStorage(AppStorageKeys.firstTimeLaunch) var firstTimeLaunch = true

    let pages: [IntroPage] = [
        IntroPage(title: "Welcome", description: "Discover and learn how to use the app's features", imageName: "camera.filters"),
        IntroPage(title: "Stay Organized", description: "Upload or take your best picture", imageName: "photo.artframe"),
        IntroPage(title: "Achieve Goals", description: "Choose the best color for your lips", imageName: "person.crop.circle.badge.checkmark")
    ]

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    func nextPage() {
        if isLastPage {
            firstTimeLaunch = false
        } else {
            currentPage += 1
        }
    }
}
