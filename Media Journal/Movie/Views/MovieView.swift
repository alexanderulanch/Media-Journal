//
//  MovieDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI
import ColorKit

struct MovieView: View {
    @ObservedObject var vm: MovieViewModel
    @State private var isLoading = true
    
    let id: Int
    
    init(id: Int) {
        self.id = id
        self.vm = MovieViewModel(movieId: id)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if vm.movie != nil {
                VStack(alignment: .leading) {
                    MovieHeaderView(vm)
                    Group {
                        if let videos = vm.youtubeVideos, !videos.isEmpty {
                            Text("Videos")
                                .font(.title2)
                                .bold()
                            
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    MovieView(id: 20760)
}



