//
//  ContentView.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageKeys.firstTimeLaunch) private var firstTimeIntro = true
    
    var body: some View {
        if firstTimeIntro {
            IntroView()
        } else {
            PhotoView()
        }
        
    }
}

#Preview {
    ContentView()
}
