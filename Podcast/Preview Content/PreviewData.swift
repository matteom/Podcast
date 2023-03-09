//
//  PreviewData.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

extension Podcast {
	static var preview: Podcast {
		let url = Bundle.main.url(forResource: "Lookup", withExtension: "json")!
		let data = try! Data(contentsOf: url)
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return try! decoder.decode(Podcast.self, from: data)
	}
}

extension [Episode] {
	static var preview: [Episode] {
		Podcast.preview.episodes
	}
}

extension Episode {
	static var preview: Episode {
		var episode = [Episode].preview[0]
		episode.update(currentBytes: 25, totalBytes: 100)
		return episode
	}
}
