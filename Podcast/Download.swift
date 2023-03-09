//
//  Download.swift
//  Podcast
//
//  Created by Matteo Manferdini on 18/02/23.
//

import Foundation

class Download: NSObject {
	let url: URL
	let downloadSession: URLSession

	private lazy var task: URLSessionDownloadTask = {
		let task = downloadSession.downloadTask(with: url)
		return task
	}()

	init(url: URL, downloadSession: URLSession) {
		self.url = url
		self.downloadSession = downloadSession
	}

	var isDownloading: Bool {
		task.state == .running
	}

	func pause() {
		task.suspend()
	}

	func resume() {
		task.resume()
	}
}
