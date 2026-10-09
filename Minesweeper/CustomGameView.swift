//
//  CustomGameView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/2/25.
//

import SwiftUI

struct CustomGameView: View {

    var onDismiss: (() -> Void)?

    @State private var rows: String = ""
    @State private var columns: String = ""
    @State private var mines: Double = 0

    @State private var rowsError: Bool = false
    @State private var colsError: Bool = false

    var maxMines: Double {
        guard let r = Int(rows), let c = Int(columns) else {
            return 0
        }

        guard r > 0, c > 0 else {
            return 0
        }
        return Double(r * c)
    }

    var difficultyLabel: String {
        guard let r = Int(rows), let c = Int(columns) else {
            return "Unknown"
        }

        guard r > 0, c > 0 else {
            return "Unknown"
        }

        let ratio = maxMines / mines

        if ratio <= 1 {
            return "Impossible"
        } else if ratio < 5 {
            return "Hard"
        } else if ratio < 8 {
            return "Intermediate"
        } else {
            return "Easy"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Game")
                .font(.headline)
            Text("Difficulty: \(difficultyLabel)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                TextField("Rows", text: $rows)
                    .onChangeCompat(of: rows) { input in
                        if let val = Int(input), val > 0 {
                            rowsError = false
                        } else {
                            rowsError = true
                        }
                    }
                if rowsError {
                    Text("Invalid number of rows")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                TextField("Columns", text: $columns)
                    .onChangeCompat(of: columns) { input in
                        if let val = Int(input), val > 0 {
                            colsError = false
                        } else {
                            colsError = true
                        }
                    }
                if colsError {
                    Text("Invalid number of columns")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            Slider(value: $mines, in: 0...max(maxMines, 0)) {
                Text("\(Int(mines)) Mines")
            }

            Divider()

            HStack {
                Button("Random") {
                    rows = String(Int.random(in: 1..<40))
                    columns = String(Int.random(in: 1..<40))
                    let max = maxMines
                    mines = max > 1 ? .random(in: 1..<max) : 0
                }
                Spacer()
                Button("Cancel") {
                    self.onDismiss?()
                }
                Button("Generate") {
                    if rows == "" || columns == "" {
                        return
                    }
                    if rowsError || colsError {
                        return
                    }

                    NotificationCenter.default.post(
                        name: .newCustomGame,
                        object: [
                            Int(rows), Int(columns), Int(mines),
                        ], userInfo: nil)

                    self.onDismiss?()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 350)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private extension View {
    /// `onChange(of:perform:)` is available on Catalina; keep a single call site style.
    @ViewBuilder
    func onChangeCompat(of value: String, perform action: @escaping (String) -> Void) -> some View {
        self.onChange(of: value, perform: action)
    }
}
