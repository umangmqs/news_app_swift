//
//  NetworkMonitor.swift
//
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    @Published var isReachable: Bool = true
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task {
                await MainActor.run { [weak self] in
                    guard let self else {
                        return
                    }
                    status = path.status
                    isReachableOnCellular = path.isExpensive

                    if path.status == .satisfied {
                        isReachable = true
                        AppPrint.debugPrint("We're connected!")
                    } else {
                        isReachable = false
                        AppPrint.debugPrint("No connection.")
                        AppPrint.debugPrint("Oppps...you are not connected to internet")
                    }
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
