//
//  EpisodeRow.swift
//  Podcast
//
//  Created by Matteo Manferdini on 17/02/23.
//

import SwiftUI

struct EpisodeRow: View {
	let episode: Episode?
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
				Text(episode?.title ?? "Episode Title")
					.font(.headline)
				Text(details ?? "Episode Details")
					.font(.subheadline)
					.foregroundColor(.secondary)
				if progress > 0 && progress < 1.0 {
					ProgressView(value: progress)
				}
			}
		}
		.padding(.top, 8.0)
		.padding(.bottom, 4.0)
		.redacted(reason: episode == nil ? .placeholder : [])
	}
}

private extension EpisodeRow {
	var details: String? {
		guard let episode else { return nil }
		return episode.date.formatted(date: .long, time: .omitted)
		+ " - " + episode.duration.formatted()
	}

	var progress: Double {
		episode?.progress ?? 0.0
	}

	var buttonImageName: String {
		switch (progress, episode?.isDownloading ?? false) {
			case (1.0, _): return "checkmark.circle.fill"
			case (_, true): return "pause.fill"
			default: return "tray.and.arrow.down"
		}
	}
}

struct Episode_Previews: PreviewProvider {
    static var previews: some View {
		List {
			EpisodeRow(episode: .preview, onButtonPressed: {})
			EpisodeRow(episode: nil, onButtonPressed: {})
		}
		.listStyle(.plain)
    }
}
