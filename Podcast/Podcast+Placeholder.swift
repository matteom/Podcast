//
//  Podcast+Placeholder.swift
//  Podcast
//
//  Created by Matteo Manferdini on 18/09/24.
//

import Foundation

extension Podcast {
	public static let placeholder: Podcast = .init(
		id: 0,
		title: "xxxxxx xxxx xx",
		artist: "xxxxxx xxxx xx",
		imageURL: URL(string: "example.com/image.jpg")!,
		episodes: []
	)
}
