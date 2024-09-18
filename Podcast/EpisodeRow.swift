//
//  EpisodeRow.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import SwiftUI

struct EpisodeRow: View {
	let episode: Episode
	let onButtonPressed: () -> Void

	var body: some View {
		HStack(alignment: .top, spacing: 16.0) {
			Button(action: onButtonPressed) {
				Image(systemName: buttonImageName)
					.font(.title3)
					.frame(width: 24.0, height: 32.0)
			}
			.buttonStyle(.borderedProminent)
			VStack(alignment: .leading, spacing: 6.0) {
				Text(episode.title)
					.font(.headline)
				Text(details ?? "Episode Details")
					.font(.subheadline)
					.foregroundColor(.secondary)
				if episode.progress > 0 && !episode.isDownloadCompleted {
					ProgressView(value: episode.progress)
				}
			}
		}
		.padding(.top, 8.0)
		.padding(.bottom, 4.0)
	}
}

private extension EpisodeRow {
	var details: String? {
		episode.date.formatted(date: .long, time: .omitted)
		+ " - "
		+ episode.duration.formatted()
	}

	var buttonImageName: String {
		switch (episode.isDownloadCompleted, episode.state) {
			case (true, _): return "checkmark.circle.fill"
			case (false, .dowloading): return "pause.fill"
			case (false, _): return "tray.and.arrow.down"
		}
	}
}

#Preview {
	List {
		EpisodeRow(episode: .preview, onButtonPressed: {})
	}
	.listStyle(.plain)
}
