//
//  ViewModel.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation

class ViewModel: NSObject, ObservableObject {
	@Published var podcast: Podcast?
	private var downloads: [URL: Download] = [:]

	private lazy var downloadSession: URLSession = {
		let configuration = URLSessionConfiguration.default
		return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
	}()

	@MainActor
	func fetchPodcast() async throws {
		let url = URL(string: "https://itunes.apple.com/lookup?id=1386867488&media=podcast&entity=podcastEpisode&limit=5")!
		let (data, _) = try await URLSession.shared.data(from: url)
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		podcast = try decoder.decode(Podcast.self, from: data)
	}

	@MainActor
	func download(_ episode: Episode) async throws {
		guard downloads[episode.url] == nil else { return }
		let download = Download(url: episode.url, downloadSession: downloadSession)
		downloads[episode.url] = download
		podcast?[episode.id]?.isDownloading = true
		for await event in download.events {
			process(event, for: episode)
		}
		downloads[episode.url] = nil
	}

	func pauseDownload(for episode: Episode) {
		downloads[episode.url]?.pause()
		podcast?[episode.id]?.isDownloading = false
	}

	func resumeDownload(for episode: Episode) {
		downloads[episode.url]?.resume()
		podcast?[episode.id]?.isDownloading = true
	}
}

private extension ViewModel {
	func process(_ event: Download.Event, for episode: Episode) {
		switch event {
			case let .progress(current, total):
				podcast?[episode.id]?.update(currentBytes: current, totalBytes: total)
			case let .success(url):
				saveFile(for: episode, at: url)
		}
	}

	func saveFile(for episode: Episode, at url: URL) {
		guard let directoryURL = podcast?.directoryURL else { return }
		let filemanager = FileManager.default
		if !filemanager.fileExists(atPath: directoryURL.path()) {
			try? filemanager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
		}
		try? filemanager.moveItem(at: url, to: episode.fileURL)
	}
}

extension Podcast {
	var directoryURL: URL {
		URL.documentsDirectory
			.appending(path: "\(id)", directoryHint: .isDirectory)
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
