//
//  SourceEditorCommand.swift
//  SourceEditorExtension
//
//  Created by Maxim Makhun on 3/3/26.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        let buffer = invocation.buffer
        
        guard let selection = (buffer.selections as? [XCSourceTextRange])?.first else {
            completionHandler(nil)
            return
        }
        
        let lineIndex = selection.start.line
        let line = buffer.lines[lineIndex] as! String
        let start = line.index(line.startIndex, offsetBy: selection.start.column, limitedBy: line.endIndex) ?? line.startIndex
        let end = line.index(line.startIndex, offsetBy: selection.end.column, limitedBy: line.endIndex) ?? line.endIndex
        let code = String(line[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !code.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let interpolation = code.contains("?") ? "String(describing: \(code))" : code
        buffer.lines[lineIndex] = line.replacingCharacters(in: start..<end, with: "print(\"!!! \\(\(interpolation))\")")
        
        completionHandler(nil)
    }
}
