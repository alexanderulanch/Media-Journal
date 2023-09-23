//
//  MovieDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: SearchResult
    
    var body: some View {
        Text(movie.name ?? movie.title ?? "")
    }
}

//#Preview {
//    MovieDetailView()
//}

