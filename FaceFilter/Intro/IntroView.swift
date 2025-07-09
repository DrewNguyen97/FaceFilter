//
//  IntroView.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI

struct IntroView: View {
    @StateObject private var viewModel = IntroViewModel()

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                    VStack(spacing: 20) {
                        Image(systemName: page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding()
                        Text(page.title)
                            .font(.largeTitle)
                            .bold()
                        Text(page.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .padding()
            
            CustomButton(title: viewModel.isLastPage ? "Get Started" : "Next") {
                viewModel.nextPage()
            }
        }
    }
}
