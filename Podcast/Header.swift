//
//  Header.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import SwiftUI

struct Header: View {
	let podcast: Podcast

    var body: some View {
		VStack(spacing: 8.0) {
			AsyncImage(url: podcast.imageURL) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(16.0)
			} placeholder: {
				ProgressView()
			}
			.frame(width: 140.0, height: 140.0)
			Text(podcast.title)
				.font(.largeTitle)
				.bold()
			Text(podcast.artist)
				.foregroundColor(.secondary)
		}
		.frame(maxWidth: .infinity)
		.padding(.bottom)
		.alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

#Preview {
	List {
		Header(podcast: .preview)
	}
	.listStyle(.plain)
}
