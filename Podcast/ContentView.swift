//
//  ContentView.swift
//  Podcast
//
//  Created by Matteo Manferdini on 22/02/23.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = ViewModel()

	var body: some View {
		List {
			Header(podcast: viewModel.podcast)
			if let podcast = viewModel.podcast {
				ForEach(podcast.episodes) { episode in
					EpisodeRow(episode: episode) {
						toggleDownload(for: episode)
					}
				}
			} else {
				ForEach(0..<5) { _ in
					EpisodeRow(episode: nil, onButtonPressed: {})
				}
			}
		}
		.listStyle(.plain)
		.task { try? await viewModel.fetchPodcast() }
	}
}

private extension ContentView {
	func toggleDownload(for episode: Episode) {
		if episode.isDownloading {
			viewModel.pauseDownload(for: episode)
		} else {
			if episode.progress > 0 {
				viewModel.resumeDownload(for: episode)
			} else {
				Task { try? await viewModel.download(episode) }
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ContentView()
		}
	}
}
