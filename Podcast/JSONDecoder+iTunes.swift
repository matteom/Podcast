//
//  JSONDecoder+iTunes.swift
//  Podcast
//
//  Created by Matteo Manferdini on 18/09/24.
//

import Foundation

extension JSONDecoder {
	static let iTunes: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
}
