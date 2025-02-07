import Foundation
import NetworkExtension

class VPNConfigurator {
    // MARK: - Configuration Creation
    static func createConfiguration(from vlessURL: String) -> VlessConfig? {
        guard let vlessConfig = VlessConfig(from: vlessURL) else {
            print("Error: VLESS-parsing")
            return nil
        }
        return vlessConfig
    }

    // MARK: - Tunnel Protocol Configuration
    static func configureTunnelProtocol(with config: VlessConfig) -> NETunnelProviderProtocol {
        let tunnelProtocol = NETunnelProviderProtocol()
        tunnelProtocol.providerBundleIdentifier = VPNConstants.providerBundleIdentifier
        tunnelProtocol.serverAddress = config.host

        tunnelProtocol.providerConfiguration = [
            "UUID": config.id,
            "host": config.host,
            "port": config.port,
            "security": config.security,
            "type": config.type,
            "flow": config.flow ?? "",
            "sni": config.sni ?? "",
            "fingerprint": config.fingerprint ?? "",
            "publicKey": config.publicKey ?? "",
            "IPSettings": VPNConstants.defaultIPSettings,
            "AlwaysOn": true,
            "OnDemandEnabled": true,
            "OnDemandRules": VPNConstants.defaultOnDemandRules
        ]

        tunnelProtocol.disconnectOnSleep = false
        return tunnelProtocol
    }
}
