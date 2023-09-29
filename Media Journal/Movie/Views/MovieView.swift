//
//  MovieDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI
import ColorKit

struct MovieView: View {
    @ObservedObject var vm = MovieViewModel()
    
    let id: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let movie = vm.movie {
                VStack(alignment: .leading) {
                    MovieHeaderView(vm)
                    Group {
                        if let videos = movie.videos, !videos.isEmpty {
                            Text("Videos")
                                .font(.title2)
                                .bold()
                            
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .safeAreaPadding(.vertical)
        .onAppear {
            vm.getMovie(id)
        }
    }
}

#Preview {
    MovieView(id: 20760)
}



