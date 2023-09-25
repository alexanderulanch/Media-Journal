//
//  MovieDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct MovieView: View {
    @ObservedObject var vm = MovieViewModel.shared
    let id: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let movie = vm.movie {
                VStack(alignment: .leading) {
                    Header(movie: movie, credits: vm.credits ?? nil)
                    Text("Trailers")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            vm.getMovie(id)
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    func load(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}

struct Header: View {
    let movie: Movie
    let credits: Credits?
    var initialHeight: CGFloat = UIScreen.main.bounds.height * 0.35
    var initialWidth: CGFloat = UIScreen.main.bounds.width
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                GeometryReader(content: { geometry in
                    let minY = geometry.frame(in: .global).minY
                    imageLoader.image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: minY > 0 ? initialHeight + minY : initialHeight)
                        .clipped()
                        .offset(y: minY > 0 ? -minY : 0)
                })
                .frame(height: initialHeight)
                
                imageLoader.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(CGSize(width: 1.3, height: -10))
                    .offset(y: 1000)
                    .blur(radius: 20)
                    .frame(height: 200)
                    .clipped()
            }
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .background(Material.ultraThin)
                    .frame(height: 300)
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [
                            Color.black.opacity(1),
                            Color.black.opacity(1),
                            Color.black.opacity(1),
                            Color.black.opacity(1),
                            Color.black.opacity(1),
                            Color.black.opacity(1),
                            Color.black.opacity(0.65),
                            Color.black.opacity(0)
                        ]), startPoint: .bottom, endPoint: .top)
                    )
                VStack(spacing: 15) {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(movie.title ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                            HStack(spacing: 0) {
                                if let genre = movie.genres.first?.name {
                                    Text(genre)
                                        .font(.subheadline)
                                }
                                
                                if let releaseDate = movie.releaseDate, let year = releaseDate.split(separator: "-").first {
                                    Text(" • \(String(year))")
                                        .font(.subheadline)
                                }
                                
                                if let runtime = movie.runtime {
                                    let hours = runtime / 60
                                    let minutes = runtime % 60

                                    if hours == 0 {
                                        Text(" • \(minutes) min")
                                            .font(.subheadline)
                                    } else {
                                        Text(" • \(hours) hr \(minutes) min")
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .foregroundStyle(Color.secondary)
                            if let credits = credits {
                                HStack(alignment: .firstTextBaseline) {
                                    let directors = credits.crew?.filter { $0.job == "Director" }
                                    if let directors = directors, !directors.isEmpty {
                                        ForEach(directors) { director in
                                            Text("DIRECTED BY")
                                                .font(.subheadline)
                                                .fontWeight(.light)
                                                .foregroundStyle(.secondary)
                                            if let name = director.name {
                                                Text(name)
                                                    .font(.subheadline)
                                                    .bold()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image.resizable()
                            } placeholder: {
                                Rectangle().foregroundColor(.gray)
                            }
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                    
                    Text(movie.overview ?? "")
                        .lineLimit(3)
                        .padding(.vertical, 5)
                }
                .padding()
                
            }
            .frame(width: initialWidth)
        }
        .frame(width: initialWidth)
        .environment(\.colorScheme, .dark)
        .onAppear {
            if let backdropURL = movie.backdropURL {
                imageLoader.load(from: backdropURL)
            }
        }
    }
}



#Preview {
    MovieView(id: 11544)
}



