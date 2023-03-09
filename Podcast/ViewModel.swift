//
//  ViewModel.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

class ViewModel: NSObject, ObservableObject {
	@Published var podcast: Podcast?

	@MainActor
	func fetchPodcast() async throws {
		let url = URL(string: "https://itunes.apple.com/lookup?id=1386867488&media=podcast&entity=podcastEpisode&limit=5")!
		let (data, _) = try await URLSession.shared.data(from: url)
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		podcast = try decoder.decode(Podcast.self, from: data)
	}
}
