//
//  PreviewData.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

extension Podcast {
	static let preview: Podcast = {
		let url = Bundle.main.url(forResource: "Lookup", withExtension: "json")!
		let data = try! Data(contentsOf: url)
		return try! JSONDecoder.iTunes.decode(Podcast.self, from: data)
	}()
}

extension [Episode] {
	static let preview: [Episode] = Podcast.preview.episodes
}

extension Episode {
	static let preview = [Episode].preview[0]
}
