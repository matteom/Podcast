//
//  Download.swift
//  Podcast
//
//  Created by Matteo Manferdini on 18/02/23.
//

import Foundation

final class Download: NSObject {
	let events: AsyncStream<Event>
	private let continuation: AsyncStream<Event>.Continuation
	private let task: URLSessionDownloadTask

	enum Event {
		case progress(currentBytes: Int64, totalBytes: Int64)
		case completed(url: URL)
		case canceled(data: Data?)
	}

	convenience init(url: URL) {
		self.init(task: URLSession.shared.downloadTask(with: url))
	}

	convenience init(resumeData data: Data) {
		self.init(task: URLSession.shared.downloadTask(withResumeData: data))
	}

	private init(task: URLSessionDownloadTask) {
		self.task = task
		(self.events, self.continuation) = AsyncStream.makeStream(of: Event.self)
		super.init()
		continuation.onTermination = { @Sendable [weak self] _ in
			self?.cancel()
		}
	}

	func start() {
		task.delegate = self
		task.resume()
	}

	func cancel() {
		task.cancel { data in
			self.continuation.yield(.canceled(data: data))
			self.continuation.finish()
		}
	}
}

extension Download: URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		continuation.yield(.completed(url: location))
		continuation.finish()
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		continuation.yield(
			.progress(
				currentBytes: totalBytesWritten,
				totalBytes: totalBytesExpectedToWrite))
	}
}
