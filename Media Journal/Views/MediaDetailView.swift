//
//  MediaDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct MediaDetailView: View {
    let mediaItem: Media
    var body: some View {
        Text(mediaItem.name ?? mediaItem.title!)
            .font(.title)
            .bold()
    }
}

//#Preview {
//    MediaDetailView()
//}



