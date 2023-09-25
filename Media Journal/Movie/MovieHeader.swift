//
//  Header.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/23/23.
//

import SwiftUI

import SwiftUI

struct MovieHeader: View {
    @ObservedObject var vm = MovieViewModel()
    let id: Int
    
    var body: some View {
        VStack {
            if let movie = vm.movie {
                ScrollView {
                    StretchableHeader(movie: movie)
                }
                
            }
        }
        .onAppear {
            vm.getMovie(id)
        }
        .ignoresSafeArea()
    }
}

struct StretchableHeader: View {
    var movie: Movie
    var initialHeaderHeight: CGFloat = UIScreen.main.bounds.height * 0.4

    var body: some View {
        GeometryReader(content: { geometry in
            let minY = geometry.frame(in: .global).minY
            AsyncImage(url: movie.backdropURL) { image in
                VStack(spacing: 0) {
                    image
                        .resizable()
                        .scaledToFill()
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(x: 1, y: -1)
//                        .offset(y: 60)
//                        .frame(height: 100)
                        .clipped()
                }
                .frame(width: geometry.size.width, height: minY > 0 ? initialHeaderHeight + minY : initialHeaderHeight)
                .offset(y: minY > 0 ? -minY : 0)
                
                
            } placeholder: {
                EmptyView()
            }
        })
        .frame(height: initialHeaderHeight)
    }
}

struct HeaderImage: View {
    let movie: Movie
    
    var body: some View {
        
        if let backdropURL = movie.backdropURL {
            AsyncImage(url: backdropURL) { image in
                VStack(spacing: 0) {
                    image
                        .resizable()
                        .scaledToFit()
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(x: 1, y: -1)
                        .offset(y: 60)
                        .frame(height: 100) // Adjust as needed
                        .clipped()
                }
                
            } placeholder: {
                EmptyView()
            }
            
        }
        
    }
}

#Preview {
    MovieHeader(id: 602)
}
