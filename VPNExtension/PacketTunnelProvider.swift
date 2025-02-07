import NetworkExtension
import Network

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var tcpConnection: NWConnection?

    // MARK: - Start Tunnel
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        print("PacketTunnelProvider ON!")
        
        guard let config = (protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration else {
            completionHandler(NSError(domain: "VPNError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No config"]))
            return
        }
        
        let host = config["host"] as? String ?? ""
        let port = config["port"] as? Int ?? 0
        let uuid = config["UUID"] as? String ?? ""
        let security = config["security"] as? String ?? "none"
        let type = config["type"] as? String ?? "tcp"
        let sni = config["sni"] as? String ?? ""
        let publicKey = config["publicKey"] as? String ?? ""

        print("VPN settings loaded:")
        print("Host: \(host)")
        print("Port: \(port)")
        print("UUID: \(uuid)")
        print("Security: \(security)")
        print("Type: \(type)")
        print("SNI: \(sni)")
        print("Public Key: \(publicKey)")

        if host.isEmpty || uuid.isEmpty || port == 0 {
            print("Error: not enough connection data")
            completionHandler(NSError(domain: "VPNError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Incorrect VPN configuration"]))
            return
        }

        applyTunnelNetworkSettings(completionHandler: completionHandler)
    }

    // MARK: - Apply Tunnel Network Settings
    private func applyTunnelNetworkSettings(completionHandler: @escaping (Error?) -> Void) {
        let tunnelSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")

        let ipv4Settings = NEIPv4Settings(addresses: ["192.168.3.25"], subnetMasks: ["255.255.255.0"])
        
        ipv4Settings.includedRoutes = [NEIPv4Route.default()]
        
        tunnelSettings.ipv4Settings = ipv4Settings
        tunnelSettings.dnsSettings = NEDNSSettings(servers: ["8.8.8.8", "8.8.4.4"])

        setTunnelNetworkSettings(tunnelSettings) { error in
            if let error = error {
                print("Error: settings apply: \(error.localizedDescription)")
                completionHandler(error)
            } else {
                print("Tunnel settings successfully applied")
                completionHandler(nil)
            }
        }
    }

    // MARK: - Stop Tunnel
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        tcpConnection?.cancel()
        print("PacketTunnelProvider off")
        completionHandler()
    }
}
