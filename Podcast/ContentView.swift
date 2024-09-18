//
//  ContentView.swift
//  Podcast
//
//  Created by Matteo Manferdini on 22/02/23.
//

import SwiftUI

struct ContentView: View {
	@State private var viewModel = ViewModel()

	var body: some View {
		List {
			if let podcast = viewModel.podcast {
				Header(podcast: podcast)
				ForEach(podcast.episodes) { episode in
					EpisodeRow(episode: episode) {
						toggleDownload(for: episode)
					}
				}
			} else {
				Group {
				Header(podcast: .placeholder)
					ForEach(0..<5) { _ in
						EpisodeRow(episode: .placeholder, onButtonPressed: {})
					}
				}
				.redacted(reason: .placeholder)
			}
		}
		.listStyle(.plain)
		.task { try? await viewModel.fetchPodcast() }
	}
}

private extension ContentView {
	func toggleDownload(for episode: Episode) {
		if episode.state == .dowloading {
			viewModel.cancelDownload(for: episode)
		} else {
			Task { try? await viewModel.download(episode) }
		}
	}
}

#Preview {
	ContentView()
}
