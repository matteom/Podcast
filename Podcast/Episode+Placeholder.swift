//
//  Episode+Placeholder.swift
//  Podcast
//
//  Created by Matteo Manferdini on 18/09/24.
//

import Foundation

extension Episode {
	static var placeholder: Episode {
		Episode(
			id: 0,
			podcastID: 0,
			duration: .seconds(0),
			title: "xxxxxx xxxxx xx xxxxx",
			date: .distantPast,
			url: URL(string: "https://example.com")!
		)
	}
}
