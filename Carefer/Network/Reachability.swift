//
//  Reachability.swift
//  Carefer
//
//  Created by Muhammad Kamal on 06/12/2022.
//

import Foundation
import SystemConfiguration
import CoreTelephony

class Reachability {
    var hostname: String?
    var isRunning = false
    var isReachableOnWWAN: Bool
    var reachability: SCNetworkReachability?
    var reachabilityFlags = SCNetworkReachabilityFlags()
    let reachabilitySerialQueue = DispatchQueue(label: "ReachabilityQueue")
    init?(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw Network.Error.failedToCreateWith(hostname)
        }
        self.reachability = reachability
        self.hostname = hostname
        isReachableOnWWAN = true
    }
    init?() throws {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }}) else {
                throw Network.Error.failedToInitializeWith(zeroAddress)
        }
        self.reachability = reachability
        isReachableOnWWAN = true
    }
    var status: Network.Status {
        return  !isConnectedToNetwork ? .unreachable :
            isReachableViaWiFi    ? .wifi :
            isRunningOnDevice     ? .wwan : .wwan
    }
    var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()
    deinit { stop() }
}

extension Reachability {
    func start() throws {
        guard let reachability = reachability, !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        guard SCNetworkReachabilitySetCallback(reachability, callout, &context) else { stop()
            throw Network.Error.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) else { stop()
            throw Network.Error.failedToSetDispatchQueue
        }
        reachabilitySerialQueue.async { self.flagsChanged() }
        isRunning = true
    }
    func stop() {
        defer { isRunning = false }
        guard let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        self.reachability = nil
    }
    var isConnectedToNetwork: Bool {
        return isReachable &&
            !isConnectionRequiredAndTransient &&
            !(isRunningOnDevice && isWWAN && !isReachableOnWWAN)
    }
    var isReachableViaWiFi: Bool {
        return isReachable && isRunningOnDevice && !isWWAN
    }

    /// Flags that indicate the reachability of a network node name or address, including whether a connection is required, and whether some user intervention might be required when establishing a connection.
    var flags: SCNetworkReachabilityFlags? {
        guard let reachability = reachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))
            } ? flags : nil
    }

    /// compares the current flags with the previous flags and if changed posts a flagsChanged notification
    func flagsChanged() {
        guard let flags = flags, flags != reachabilityFlags else { return }
        reachabilityFlags = flags
        NotificationCenter.default.post(name: .flagsChanged, object: self)
    }

    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var transientConnection: Bool { return flags?.contains(.transientConnection) == true }

    /// The specified node name or address can be reached using the current network configuration.
    var isReachable: Bool { return flags?.contains(.reachable) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set, the kSCNetworkReachabilityFlagsConnectionOnTraffic flag, kSCNetworkReachabilityFlagsConnectionOnDemand flag, or kSCNetworkReachabilityFlagsIsWWAN flag is also typically set to indicate the type of connection required. If the user must manually make the connection, the kSCNetworkReachabilityFlagsInterventionRequired flag is also set.
    var connectionRequired: Bool { return flags?.contains(.connectionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
    var connectionOnTraffic: Bool { return flags?.contains(.connectionOnTraffic) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established.
    var interventionRequired: Bool { return flags?.contains(.interventionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand" by the CFSocketStream programming interface (see CFStream Socket Additions for information on this). Other functions will not establish the connection.
    var connectionOnDemand: Bool { return flags?.contains(.connectionOnDemand) == true }

    /// The specified node name or address is one that is associated with a network interface on the current system.
    var isLocalAddress: Bool { return flags?.contains(.isLocalAddress) == true }

    /// Network traffic to the specified node name or address will not go through a gateway, but is routed directly to one of the interfaces in the system.
    var isDirect: Bool { return flags?.contains(.isDirect) == true }

    /// The specified node name or address can be reached via a cellular connection, such as EDGE or GPRS.
    var isWWAN: Bool { return flags?.contains(.isWWAN) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set
    /// The specified node name or address can be reached via a transient connection, such as PPP.
    var isConnectionRequiredAndTransient: Bool {
        return (flags?.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]) == true
    }
}

func callout(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    guard let info = info else { return }
    DispatchQueue.main.async {
        Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue().flagsChanged()
    }
}

extension Notification.Name {
    static let flagsChanged = Notification.Name("FlagsChanged")
}

struct Network {
    static var reachability: Reachability?
    enum Status: String, CustomStringConvertible {
        case unreachable, wifi, wwan
        var description: String { return rawValue }
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}

enum NetworkType {
    case unknown
    case noConnection
    case wifi
    case wwan2g
    case wwan3g
    case wwan4g
    case unknownTechnology(name: String)

    var trackingId: String {
        switch self {
        case .unknown:                      return "Unknown"
        case .noConnection:                 return "No Connection"
        case .wifi:                         return "Wifi"
        case .wwan2g:                       return "2G"
        case .wwan3g:                       return "3G"
        case .wwan4g:                       return "4G"
        case .unknownTechnology(let name):  return "Unknown Technology: \"\(name)\""
        }
    }
}

extension Reachability {

    static func getNetworkType() -> NetworkType {
        do {
            let reachability  = try Reachability()
            try reachability?.start()
            switch reachability?.status {
            case .unreachable?: return .noConnection
            case .wifi?: return .wifi
            case .wwan?: return Reachability.getWWANNetworkType()
            default: return .unknown
            }
        } catch {
            return .unknown
        }
    }

    static func getWWANNetworkType() -> NetworkType {
        guard let currentRadioAccessTechnology = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology else { return .unknown }
        switch currentRadioAccessTechnology.first?.value {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            return .wwan2g
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .wwan3g
        case CTRadioAccessTechnologyLTE:
            return .wwan4g
        default:
            return .unknownTechnology(name: currentRadioAccessTechnology.first?.value ?? "Unknown")
        }
    }

}