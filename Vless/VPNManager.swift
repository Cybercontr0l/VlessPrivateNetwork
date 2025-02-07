import Foundation
import NetworkExtension

class VPNManager {
    static let shared = VPNManager()
    private var providerManager: NETunnelProviderManager?

    // MARK: - Initialization
    private init() {
        loadProviderManager()
    }

    // MARK: - Load VPN Configuration
    public func loadProviderManager() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] (managers, error) in
            if let error = error {
                print("Error: load VPN config: \(error.localizedDescription)")
                return
            }

            let manager: NETunnelProviderManager
            if let existingManager = managers?.first {
                manager = existingManager
                print("VPN config exist")
            } else {
                manager = NETunnelProviderManager()
                print("Creating new VPN config")
                self?.setupVPNConfiguration(manager)
            }

            self?.providerManager = manager
        }
    }

    // MARK: - Setup VPN Configuration
    private func setupVPNConfiguration(_ manager: NETunnelProviderManager) {
        let vlessURL = VlessConfigURL.url

        guard let config = VPNConfigurator.createConfiguration(from: vlessURL) else {
            print("Error: creating VPN config")
            return
        }

        let tunnelProtocol = VPNConfigurator.configureTunnelProtocol(with: config)
        manager.protocolConfiguration = tunnelProtocol
        manager.localizedDescription = VPNConstants.vpnDescription
        manager.isEnabled = true

        saveConfiguration(manager)
    }

    // MARK: - Save Configuration
    private func saveConfiguration(_ manager: NETunnelProviderManager) {
        print("Save config...")
        manager.saveToPreferences { [weak self] error in
            if let error = error {
                print("Error: save config: \(error.localizedDescription)")
                return
            }
            print("VPN config saved")
            self?.reloadConfiguration()
        }
    }

    // MARK: - Reload Configuration
    private func reloadConfiguration() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            if let error = error {
                print("Error: reloading configuration: \(error.localizedDescription)")
                return
            }

            if let updatedManager = managers?.first {
                self?.providerManager = updatedManager
                print("VPN config updated")
            }
        }
    }

    // MARK: - Start VPN
    func startVPN() {
        guard let manager = providerManager else {
            print("VPN not configured")
            return
        }
        do {
            try manager.connection.startVPNTunnel()
            print("VPN ON!")
        } catch {
            print("Error: VPN Starting: \(error.localizedDescription)")
        }
    }

    // MARK: - Stop VPN
    func stopVPN() {
        providerManager?.connection.stopVPNTunnel()
        print("VPN off")
    }
}
