//
//  UnzipIntent.swift
//  UnzipIntent
//
//  Created by Ben Gottlieb on 2/15/24.
//

import AppIntents
import ZIPFoundation

struct UnzipIntent: AppIntent {
	static var title: LocalizedStringResource = "Unzip File"
	
	@Parameter(
			 title: "ZIP File",
			 description: "File to unzip",
			 supportedTypeIdentifiers: ["public.zip-archive"],
			 inputConnectionBehavior: .connectToPreviousIntentResult
		)
		var file: IntentFile
	
	func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> {
		if let url = file.fileURL {
			let dest = URL.documentsDirectory.appendingPathComponent("unzipped", conformingTo: .directory)
			try? FileManager.default.removeItem(at: dest)
			try FileManager.default.unzipItem(at: url, to: dest)
			let results = try FileManager.default.contentsOfDirectory(at: dest, includingPropertiesForKeys: [], options: [])
			return .result(value: results.map { IntentFile(fileURL: $0) })
		}
		return .result(value: [file])
	}
	
//	var debugDescription: String { "DebugDescription" }
}
