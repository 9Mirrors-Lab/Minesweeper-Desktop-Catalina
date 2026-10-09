//
//  StatsViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 8/5/22.
//

import Cocoa

class StatsViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timerField: NSTextField!

    private let statKeys = ["3BV", "3BV/s", "Left", "Right", "Middle", "Estimated"]
    var stats: [String: Double] = [
        "3BV": 0,
        "3BV/s": 0.0,
        "Left": 0,
        "Right": 0,
        "Middle": 0,
        "Estimated": 0,
    ]

    var revealStats: Bool = false
    var elapsedTime: TimeInterval = 0
    var total3BV: Int = 0
    var totalClicks: Int = 0
    var effectiveClicks: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        // TODO: Change to default value
        view.layer?.backgroundColor = NSColor(red: 226, green: 226, blue: 226, alpha: 1).cgColor

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.updateStat(_:)), name: .updateStat, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.resetStats(_:)), name: .resetStats, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.revealStats(_:)), name: .revealStats, object: nil)
    }

    @objc func updateStat(_ notification: Notification) {
        let statName = notification.userInfo!.keys.first! as! String
        let statValue = notification.userInfo!.values.first! as! Int

        if statName == "NonEffective" {
            totalClicks += 1
        }
        if statName == "Effective" {
            totalClicks += 1
            effectiveClicks += 1
        }

        if statName == "Total3BV" {
            total3BV = statValue
        }

        if statName == "3BV" {
            stats["3BV"]! += Double(1)
        }

        if statName == "Left" {
            stats["Left"]! += 1
        }

        if statName == "Right" {
            stats["Right"]! += 1
        }

        if statName == "Middle" {
            stats["Middle"]! += 1
        }

        tableView.reloadData()
    }

    @objc func revealStats(_: Notification) {
        revealStats = true

        // Calculate time-based stats
        if elapsedTime.magnitude == 0 {
            stats["3BV/s"] = 0
            stats["Estimated"] = 0
        } else {
            stats["3BV/s"] = Double(
                round(1000 * (Double(effectiveClicks) / elapsedTime.magnitude)) / 1000)
            stats["Estimated"] = Double(total3BV) / (Double(totalClicks) / elapsedTime.magnitude)
        }

        tableView.reloadData()
    }

    @objc func resetStats(_: Notification) {
        totalClicks = 0
        effectiveClicks = 0

        for key in statKeys {
            stats[key] = 0
        }

        revealStats = false
    }
}

extension StatsViewController: GameTimerDelegate {

    func updateTime(_ time: TimeInterval) {
        elapsedTime = time
        let seconds = Int(elapsedTime)
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)

        timerField.stringValue = String(format: "%d.%02d", seconds, hundredths)
    }

}

extension StatsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return statKeys.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let key = statKeys[row]
        let value = stats[key] ?? 0

        if tableColumn == tableView.tableColumns[0] {
            guard
                let statsLabelCell = tableView.makeView(
                    withIdentifier: .init(rawValue: "statsLabelCell"),
                    owner: self) as? NSTableCellView
            else { return nil }
            statsLabelCell.textField!.stringValue = key
            return statsLabelCell
        } else {
            guard
                let statsValueCell = tableView.makeView(
                    withIdentifier: .init(rawValue: "statsValueCell"),
                    owner: self) as? NSTableCellView
            else { return nil }

            switch key {
            case "3BV":
                if revealStats {
                    statsValueCell.textField!.stringValue =
                        "\(Int(value))/\(total3BV)"
                } else {
                    statsValueCell.textField!.stringValue = "•/•"
                }
            case "3BV/s", "Estimated":
                if revealStats {
                    statsValueCell.textField!.stringValue = String(
                        format: "%.2f", value)
                } else {
                    statsValueCell.textField!.stringValue = "•••"
                }
            case "Left", "Middle", "Right":
                statsValueCell.textField!.stringValue = "\(Int(value))"
            default: break
            }

            return statsValueCell
        }
    }
}

extension StatsViewController: NSTableViewDelegate {

}
