//
//  Compatibility.swift
//  Minesweeper
//
//  Helpers for macOS Catalina (10.15) through current releases.
//

import AppKit

enum Compatibility {

    /// SF Symbols exist only on macOS 11+. Older systems get nil (title-only UI).
    static func symbolImage(_ name: String) -> NSImage? {
        if #available(macOS 11.0, *) {
            return NSImage(systemSymbolName: name, accessibilityDescription: nil)
        }
        return nil
    }

    /// `allowedFileTypes` works from Catalina forward; avoids UniformTypeIdentifiers (11+).
    static func configureOpenPanel(_ panel: NSOpenPanel, extensions: [String]) {
        panel.allowedFileTypes = extensions
    }

    static func configureSavePanel(_ panel: NSSavePanel, extensions: [String]) {
        panel.allowedFileTypes = extensions
    }
}
