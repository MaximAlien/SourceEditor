//
//  SortImportsCommand.swift
//  SourceEditorExtension
//
//  Created by Maxim Makhun on 3/14/26.
//

import Foundation
import XcodeKit

class SortImportsCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        let buffer = invocation.buffer
        guard let lines = buffer.lines as? [String] else {
            return
        }

        var i = 0
        while i < lines.count {
            let trimmed = lines[i].trimmingCharacters(in: .whitespaces)
            if isImportLine(trimmed) {
                let blockStart = i
                while i < lines.count && isImportLine(lines[i].trimmingCharacters(in: .whitespaces)) {
                    i += 1
                }
                let sorted = lines[blockStart..<i].sorted {
                    $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
                }
                for (offset, line) in sorted.enumerated() {
                    buffer.lines[blockStart + offset] = line
                }
            } else {
                i += 1
            }
        }

        completionHandler(nil)
    }

    private func isImportLine(_ trimmed: String) -> Bool {
        trimmed.hasPrefix("import ") || trimmed.hasPrefix("@testable import ")
    }
}
