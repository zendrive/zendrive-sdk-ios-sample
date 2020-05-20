//
//  DissociateVehicleViewController.swift
//  ZendriveSDKDemoSwift
//
//  Created by Abhishek Aggarwal on 21/05/20.
//  Copyright © 2020 zendrive. All rights reserved.
//

import UIKit
import ZendriveSDKSwift

class DissociateVehicleViewController: UIViewController,
                                       UITableViewDelegate,
                                       UITableViewDataSource {
    private var vehicleId: String?
    private var associatedVehiclesArray: [VehicleInfo] = []

    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshUI()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return associatedVehiclesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "dissociate")
        cell.textLabel?.text = associatedVehiclesArray[indexPath.row].vehicleId
        cell.detailTextLabel?.text = associatedVehiclesArray[indexPath.row].bluetoothId
        if let vehicleId = vehicleId,
            associatedVehiclesArray[indexPath.row].vehicleId == vehicleId {
            cell.accessoryType = .checkmark
            confirmButton.isHidden = false
            confirmButton.alpha = 1
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.vehicleId == associatedVehiclesArray[indexPath.row].vehicleId {
            self.vehicleId = nil
        } else {
            self.vehicleId = associatedVehiclesArray[indexPath.row].vehicleId
        }
        refreshUI()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (associatedVehiclesArray.count == 0) ? 250 : 0
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return (associatedVehiclesArray.count == 0) ? "No vehicles registered" : ""
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.textLabel?.textAlignment = .center
        footer?.textLabel?.textColor = UIColor.darkGray
        footer?.textLabel?.sizeToFit()
        footer?.textLabel?.font = UIFont(name: (footer?.textLabel?.font.familyName)!, size: 20)
    }

    @IBAction private func confirmButtonClicked() {
        self.dissociateVehicle(self.vehicleId ?? "")
    }

    private func refreshUI() {
        DispatchQueue.main.async {
            self.confirmButton.isHidden = true
            self.confirmButton.alpha = 0.3
            self.associatedVehiclesArray = ZendriveVehicleTagging.getAssociatedVehicles() ?? []
            self.confirmButton.isHidden = (self.associatedVehiclesArray.count == 0)
            self.tableView.reloadData()
        }
    }

    private func dissociateVehicle(_ vehicleId: String) {
        do {
            try ZendriveVehicleTagging.dissociateVehicle(vehicleId)
            let successAlertController =
                UIAlertController(
                    title: "Hooray!",
                    message: "Your vehicle \(vehicleId) is deregistered successfully",
                    preferredStyle: .alert)
            successAlertController.addAction(
                UIAlertAction(title: "OK",
                              style: .default,
                              handler: { (_) in
                                self.refreshUI()
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
