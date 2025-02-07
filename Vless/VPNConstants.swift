enum VPNConstants {
    // MARK: - Provider Info
    static let providerBundleIdentifier = "com.freecity.vpn.VPNExtension"
    static let vpnDescription = "Vless VPN"

    // MARK: - IP Settings
    static let defaultIPSettings: [String: Any] = [
        "IPv4": [
            "address": "192.168.3.25",
            "subnet": "255.255.255.0",
            "gateway": "192.168.3.1"
        ]
    ]

    // MARK: - On-Demand Rules
    static let defaultOnDemandRules: [[String: String]] = [
        ["Action": "Connect", "InterfaceTypeMatch": "WiFi"],
        ["Action": "Connect", "InterfaceTypeMatch": "Cellular"]
    ]
}
