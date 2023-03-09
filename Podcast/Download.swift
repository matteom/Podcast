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

	private var continuation: AsyncStream<Event>.Continuation?

	private lazy var task: URLSessionDownloadTask = {
		let task = downloadSession.downloadTask(with: url)
		task.delegate = self
		return task
	}()

	init(url: URL, downloadSession: URLSession) {
		self.url = url
		self.downloadSession = downloadSession
	}

	var isDownloading: Bool {
		task.state == .running
	}

	var events: AsyncStream<Event> {
		AsyncStream { continuation in
			self.continuation = continuation
			task.resume()
			continuation.onTermination = { @Sendable [weak self] _ in
				self?.task.cancel()
			}
		}
	}

	func pause() {
		task.suspend()
	}

	func resume() {
		task.resume()
	}
}

extension Download {
	enum Event {
		case progress(currentBytes: Int64, totalBytes: Int64)
		case success(url: URL)
	}
}

extension Download: URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		continuation?.yield(
			.progress(
				currentBytes: totalBytesWritten,
				totalBytes: totalBytesExpectedToWrite))
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		continuation?.yield(.success(url: location))
		continuation?.finish()
	}
}
