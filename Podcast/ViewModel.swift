//
//  ViewModel.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import Foundation
import Observation

@Observable @MainActor
class ViewModel {
	var podcast: Podcast?
	private var downloads: [URL: Download] = [:]

	func fetchPodcast() async throws {
		let url = URL(string: "https://itunes.apple.com/lookup?id=1386867488&media=podcast&entity=podcastEpisode&limit=5")!
		let (data, _) = try await URLSession.shared.data(from: url)
		podcast = try JSONDecoder.iTunes.decode(Podcast.self, from: data)
	}

	func download(_ episode: Episode) async throws {
		guard downloads[episode.url] == nil,
			  !episode.isDownloadCompleted
		else { return }
		let download = if case let .canceled(data) = episode.state {
			Download(resumeData: data)
		} else {
			Download(url: episode.url)
		}
		downloads[episode.url] = download
		download.start()
		podcast?[episode.id].state = .dowloading
		for await event in download.events {
			process(event, for: episode)
		}
		downloads[episode.url] = nil
	}

	func cancelDownload(for episode: Episode) {
		downloads[episode.url]?.cancel()
		podcast?[episode.id].state = .idle
	}
}

private extension ViewModel {
	func process(_ event: Download.Event, for episode: Episode) {
		switch event {
			case let .progress(current, total):
				podcast?[episode.id].update(currentBytes: current, totalBytes: total)
			case let .completed(url):
				saveFile(for: episode, at: url)
				podcast?[episode.id].state = .completed
			case let .canceled(data):
				podcast?[episode.id].state = if let data {
					.canceled(resumeData: data)
				} else {
					.idle
				}
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
