//
//  MovieHeaderView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/27/23.
//

import SwiftUI
import ColorKit

struct MovieHeaderView: View {
    @ObservedObject var vm: MovieViewModel

    // MARK: - Computed Properties

    var backdropImage: UIImage? {
        vm.image(forKey: "backdrop")
    }

    var posterImage: UIImage? {
        vm.image(forKey: "poster")
    }
    
    var backgroundColor: Color {
        if let backdropImage = backdropImage {
            do {
                return try Color(backdropImage.averageColor())
            } catch {
                return Color.black
            }
        }
        return Color.black
    }

    var initialHeight: CGFloat = UIScreen.main.bounds.height * 0.3
    var initialWidth: CGFloat = UIScreen.main.bounds.width

    // MARK: - Initializer

    init(_ viewModel: MovieViewModel) {
        vm = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                backdropView
                detailsContent
            }
            posterOverlay
        }
        .environment(\.colorScheme, .dark)
        .frame(width: initialWidth)
    }

    // MARK: - View Components

    private var backdropView: some View {
        Group {
            if let backdropImage = backdropImage {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        GeometryReader(content: { geometry in
                            let minY = geometry.frame(in: .global).minY
                            Image(uiImage: backdropImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: initialWidth, height: minY > 0 ? initialHeight + minY : initialHeight)
                                .clipped()
                                .offset(y: minY > 0 ? -minY : 0)
                        })
                        fadingOverlay
                    }
                    .frame(height: initialHeight)
                }
            }
        }
    }

    private var fadingOverlay: some View {
        Rectangle()
            .frame(height: 50)
            .foregroundStyle(Material.regular)
            .background(.black)
            .mask(
                LinearGradient(gradient: Gradient(colors: [
                    Color.black,
                    Color.black.opacity(0.95),
                    Color.black.opacity(0.9),
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.55),
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.2),
                    Color.black.opacity(0)
                ]), startPoint: .bottom, endPoint: .top)
            )
    }

    private var detailsContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            detailsHeader
            directorInfo
            movieOverview
        }
        .background(
            Rectangle()
                .foregroundStyle(Material.regular)
                .background(.black)
        )
    }

    private var detailsHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                if let title = vm.movie?.details?.title {
                    Text(title)
                        .font(titleFont(for: title))
                        .fontWeight(.bold)
                }
                movieSubDetails
                actionButton
            }
            .frame(maxHeight: .infinity)
            if posterImage != nil {
                if backdropImage == nil {
                    Spacer()
                    if let posterImage {
                        Image(uiImage: posterImage)
                            .resizable()
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                            .shadow(radius: 20)
                    }
                }
                else {
                    Spacer()
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(width: 120)
                }
                
            }
        }
        .padding()
    }
    
    private var actionButton: some View {
        Button { } label: {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Material.bar)
                .frame(width: 100, height: 30)
        }
    }

    private var movieSubDetails: some View {
        let details: [String] = {
            var tempDetails: [String] = []
            
            if let genre = vm.movie?.details?.genres.first?.name {
                tempDetails.append(genre)
            }
            
            if let releaseDate = vm.movie?.details?.releaseDate, let year = releaseDate.split(separator: "-").first {
                tempDetails.append(String(year))
            }
            
            if let runtime = vm.movie?.details?.runtime, runtime > 0 {
                let hours = runtime / 60
                let minutes = runtime % 60
                
                let runtimeString: String
                if hours == 0 {
                    runtimeString = "\(minutes) min"
                } else if minutes == 0 {
                    runtimeString = "\(hours) hr"
                } else {
                    runtimeString = "\(hours) hr \(minutes) min"
                }
                
                tempDetails.append(runtimeString)
            }

            return tempDetails
        }()
        
        return HStack(spacing: 0) {
            Text(details.joined(separator: " • "))
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }


    private var directorInfo: some View {
        Group {
            if let credits = vm.movie?.credits {
                let directors = credits.crew?.filter { $0.job == "Director" }
                if let directors = directors, !directors.isEmpty {
                    let directorNames = directors.prefix(2).compactMap { $0.name }
                    if !directorNames.isEmpty {
                        Divider()
                        HStack(alignment: .firstTextBaseline) {
                            Text("DIRECTED BY")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .layoutPriority(1)
                            Text(directorNames.joined(separator: directorNames.count > 1 ? " & " : ""))
                                .font(.subheadline)
                                .bold()
                        }
                        .padding()
                    }
                }
            }
        }
    }

    
    private var movieOverview: some View {
        Group {
            if let overview = vm.movie?.details?.overview {
                if !overview.isEmpty {
                    Divider()
                    Text(overview)
                        .lineLimit(3)
                        .padding()
                }
            }
        }
    }

    private var posterOverlay: some View {
        Group {
            if backdropImage != nil, posterImage != nil {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    HStack {
                        Spacer()
                        if let posterImage = posterImage {
                            Image(uiImage: posterImage)
                                .resizable()
                                .frame(width: 120, height: 180)
                                .cornerRadius(8)
                                .shadow(radius: 20)
                                .padding()
                        }
                    }
                    Group {
                        directorInfo
                        movieOverview
                    }
                    .foregroundStyle(.clear)
                }
            }
        }
    }
    
    func titleFont(for title: String) -> Font {
        switch title.count {
        case ...11:
            return .largeTitle
        case 12...20:
            return .title
        default:
            return .title2
        }
    }
}

#Preview {
    ScrollView {
        MovieHeaderView(MovieViewModel(movieId: 872585))
    }
}
