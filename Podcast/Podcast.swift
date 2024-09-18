//
//  Podcast.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

struct Podcast {
	let id: Int
	let title: String
	let artist: String
	let imageURL: URL
	var episodes: [Episode]

	subscript(episodeID: Episode.ID) -> Episode {
		get { episodes.first { $0.id == episodeID }! }
		set {
			guard let index = episodes.firstIndex(where: { $0.id == episodeID }) else { return }
			episodes[index] = newValue
		}
	}
}

extension Podcast: Decodable {
	enum CodingKeys: String, CodingKey {
		case id = "collectionId"
		case title = "collectionName"
		case artist = "artistName"
		case imageURL = "artworkUrl600"
	}

	enum LookupCodingKeys: CodingKey {
		case results
	}

	init(from decoder: Decoder) throws {
		let lookupContainer = try decoder.container(keyedBy: LookupCodingKeys.self)
		var resultsContainer = try lookupContainer.nestedUnkeyedContainer(forKey: LookupCodingKeys.results)
		let podcastContainer = try resultsContainer.nestedContainer(keyedBy: CodingKeys.self)
		self.id = try podcastContainer.decode(Int.self, forKey: .id)
		self.title = try podcastContainer.decode(String.self, forKey: .title)
		self.artist = try podcastContainer.decode(String.self, forKey: .artist)
		self.imageURL = try podcastContainer.decode(URL.self, forKey: .imageURL)
		var episodes: [Episode] = []
		while !resultsContainer.isAtEnd {
			let episode = try resultsContainer.decode(Episode.self)
			episodes.append(episode)
		}
		self.episodes = episodes
	}
}

extension Podcast {
	var directoryURL: URL {
		URL.documentsDirectory
			.appending(path: "\(id)", directoryHint: .isDirectory)
	}
}
