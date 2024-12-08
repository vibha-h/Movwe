import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../viewmodels/lobby_viewmodel.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});

  @override
  _LobbyViewState createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final TextEditingController _joinCodeController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scannedJoinCode;


  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _joinCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Join Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final joinCode = int.tryParse(_joinCodeController.text);
                try {
                  if (joinCode != null) {
                    bool success =
                        await lobbyViewModel.joinLobby(context, joinCode);
                    String message =
                        success ? "Joined Lobby!" : "Failed to join lobby.";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid join code.")),
                    );
                  }
                } catch (e) {
                  String errorMessage = 'An error occurred';
                  if (e is Exception) {
                    errorMessage = e.toString();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
              child: const Text('Join Lobby'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await lobbyViewModel.createLobby(context);
                String message = success
                    ? "Created Lobby: ${lobbyViewModel.joinCode}"
                    : "Failed to create lobby.";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: const Text('Create New Lobby'),
            ),
            const SizedBox(height: 20),
          ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR Code'),
              onPressed: () async {
                // Navigate to the QR code scanner view
                final scannedCode = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerView(qrKey: qrKey),
                  ),
                );

                if (scannedCode != null) {
                  setState(() {
                    _joinCodeController.text = scannedCode; // Autofill join code
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Scanned Code: $scannedCode")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerView extends StatefulWidget {
  final GlobalKey qrKey;

  const QRScannerView({required this.qrKey, super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: QRView(
        key: widget.qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller!.scannedDataStream.listen((scanData) {
      Navigator.pop(context, scanData.code);
    });
  }
}