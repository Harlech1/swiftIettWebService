//
//  ViewController+UI.swift
//  iett
//
//  Created by Türker Kızılcık on 30.03.2024.
//

import Foundation
import UIKit

extension ViewController {

    func addSubviews() {
        view.addSubview(verticalStackView)
        view.addSubview(horizontalStackView)
        view.addSubview(horizontalStackView1)

        horizontalStackView.addArrangedSubview(callAPIButton)
        horizontalStackView.addArrangedSubview(showAllStationsButton)
        horizontalStackView.addArrangedSubview(showOneStationButton)

        horizontalStackView1.addArrangedSubview(urlTextField)
        horizontalStackView1.addArrangedSubview(stationTextField)

        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView1)

        verticalStackView.addArrangedSubview(responselabel)
        verticalStackView.addArrangedSubview(mapView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
