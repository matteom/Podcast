//
//  Episode.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

struct Episode: Identifiable {
	let id: Int
	let podcastID: Int
	let duration: Duration
	let title: String
	let date: Date
	let url: URL
	var state: State = .idle
	private(set) var currentBytes: Int64 = 0
	private(set) var totalBytes: Int64 = 0

	enum State: Equatable {
		case idle
		case dowloading
		case completed
		case canceled(resumeData: Data)
	}

	var progress: Double {
		guard totalBytes > 0 else { return 0 }
		return Double(currentBytes) / Double(totalBytes)
	}

	var isDownloadCompleted: Bool {
		currentBytes == totalBytes && totalBytes > 0
	}

	mutating func update(currentBytes: Int64, totalBytes: Int64) {
		self.currentBytes = currentBytes
		self.totalBytes = totalBytes
	}
}

extension Episode: Decodable {
	enum CodingKeys: String, CodingKey {
		case id = "trackId"
		case podcastID = "collectionId"
		case duration = "trackTimeMillis"
		case title = "trackName"
		case date = "releaseDate"
		case url = "episodeUrl"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.podcastID = try container.decode(Int.self, forKey: .podcastID)
		let duration = try container.decode(Int.self, forKey: .duration)
		self.duration = .milliseconds(duration)
		self.title = try container.decode(String.self, forKey: .title)
		self.date = try container.decode(Date.self, forKey: .date)
		self.url = try container.decode(URL.self, forKey: .url)
	}
}

extension Episode {
	var fileURL: URL {
		URL.documentsDirectory
			.appending(path: "\(podcastID)")
			.appending(path: "\(id)")
			.appendingPathExtension("mp3")
	}
}
