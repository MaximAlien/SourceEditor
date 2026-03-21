//
//  BlockCommentCommand.swift
//  SourceEditorExtension
//
//  Created by Maxim Makhun on 3/14/26.
//

import XcodeKit
import Foundation

class BlockCommentCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        let buffer = invocation.buffer

        guard let selection = (buffer.selections as? [XCSourceTextRange])?.first else {
            completionHandler(nil)
            return
        }

        let startLine = selection.start.line
        let endLine = selection.end.line

        if startLine == endLine, let line = buffer.lines[startLine] as? String {
            let start = line.index(line.startIndex, offsetBy: selection.start.column, limitedBy: line.endIndex) ?? line.startIndex
            let end = line.index(line.startIndex, offsetBy: selection.end.column, limitedBy: line.endIndex) ?? line.endIndex
            let text = String(line[start..<end])

            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                completionHandler(nil)
                return
            }

            buffer.lines[startLine] = line.replacingCharacters(in: start..<end, with: "/* \(text) */")
        } else {
            // When selection ends at column 0, the last line isn't visually included.
            let actualEndLine = selection.end.column == 0 ? endLine - 1 : endLine

            // Insert closing marker first to avoid index shift affecting the opening insertion.
            buffer.lines.insert("*/\n", at: actualEndLine + 1)
            buffer.lines.insert("/*\n", at: startLine)
        }

        completionHandler(nil)
    }
}
