//
//  AssociateVehicleViewController.swift
//  ZendriveSDKDemoSwift
//
//  Created by Abhishek Aggarwal on 20/05/20.
//  Copyright © 2020 zendrive. All rights reserved.
//

import UIKit
import AVFoundation
import ZendriveSDKSwift

final class AssociateVehicleViewController: UIViewController,
                                            UITableViewDelegate,
                                            UITableViewDataSource {
    private var vehicleId: String?
    private var bluetoothId: String?
    private var connectedDevicesArray: [BluetoothDevice] = []

    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshUI()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: AVAudioSession.routeChangeNotification, object: nil)
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedDevicesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "associate")
        let bluetoothId =
            connectedDevicesArray[indexPath.row].identifier
        cell.textLabel?.text = connectedDevicesArray[indexPath.row].name
        cell.detailTextLabel?.text = bluetoothId
        if self.bluetoothId == bluetoothId {
            cell.accessoryType = .checkmark
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Retrieving mac address from uid.
        let bluetoothId =
            connectedDevicesArray[indexPath.row].identifier
        if self.bluetoothId == bluetoothId {
            self.vehicleId = nil
            self.bluetoothId = nil
        } else {
            // Removing disallowed characters from vehicle id.
            self.vehicleId =
                connectedDevicesArray[indexPath.row].name
                    .replacingOccurrences(of: " ", with: "_")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "? &/\\;#\n")) +
                String(format: "_%04d", arc4random_uniform(10000))

            self.bluetoothId = bluetoothId
        }
        refreshUI()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (connectedDevicesArray.count == 0) ? 250 : 0
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return (connectedDevicesArray.count == 0) ? "Please connect to car's stereo" : ""
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.textLabel?.textAlignment = .center
        footer?.textLabel?.textColor = UIColor.darkGray
        footer?.textLabel?.sizeToFit()
        footer?.textLabel?.font = UIFont(name: (footer?.textLabel?.font.familyName)!, size: 20)
    }

    private func getConnectedDevices() -> [BluetoothDevice] {
        if let bluetoothDevice = ZendriveVehicleTagging.getActiveBluetoothDevice() {
            return [bluetoothDevice]
        } else {
            return []
        }
    }

    @objc private func refreshUI() {
        DispatchQueue.main.async {
            self.confirmButton.isEnabled = false
            self.confirmButton.alpha = 0.3
            self.connectedDevicesArray = self.getConnectedDevices()
            self.confirmButton.isHidden = (self.connectedDevicesArray.count == 0)
            self.tableView.reloadData()
        }
    }

    @IBAction private func confirmButtonClicked() {
        let vehicleIdAlertController = UIAlertController(
            title: "Please enter your vehicleId",
            message: nil,
            preferredStyle: .alert)

        vehicleIdAlertController.addAction(UIAlertAction(title: "Cancel",
                                                         style: .cancel,
                                                         handler: nil))
        vehicleIdAlertController.addAction(
            UIAlertAction(
                title: "Submit",
                style: .default) { _ in
                    let vehicleId = vehicleIdAlertController.textFields?.first?.text
                    let vehicleInfo =
                        VehicleInfo(vehicleId: vehicleId ?? "",
                                    bluetoothId: self.bluetoothId ?? "")
                    self.associateVehicle(vehicleInfo)
        })
        vehicleIdAlertController.addTextField { (textField) in
            textField.placeholder = "Enter VehicleId"
            textField.text = self.vehicleId
        }
        self.present(vehicleIdAlertController, animated: true, completion: nil)
    }

    private func associateVehicle(_ vehicleInfo: VehicleInfo) {
        do {
            try ZendriveVehicleTagging.associateVehicle(
                VehicleInfo(vehicleId: vehicleInfo.vehicleId,
                            bluetoothId: vehicleInfo.bluetoothId))
            let successAlertController =
                UIAlertController(title: "Hooray!",
                                  message: "Your vehicle \(vehicleInfo.vehicleId) registered successfully",
                                  preferredStyle: .alert)
            successAlertController.addAction(
                UIAlertAction(title: "OK",
                              style: .default,
                              handler: { (_) in
                                self.navigationController?
                                    .popViewController(animated: true)
            }))

            self.present(successAlertController, animated: true, completion: nil)
        } catch {
            let errorAlertController =
                UIAlertController(title: "Error Occurred",
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: "OK",
                                                         style: .default,
                                                         handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
        }
    }
}

