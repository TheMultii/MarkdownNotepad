import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:collection/collection.dart';

class InitSetupPage extends StatefulWidget {
  const InitSetupPage({super.key});

  @override
  State<InitSetupPage> createState() => _InitSetupPageState();
}

class _InitSetupPageState extends State<InitSetupPage> {
  final LanScanner? scanner = kIsWeb ? null : LanScanner();
  List<Host>? availableHosts;
  Host? selectedHost;
  String? selectedAddress;
  String? selectedPort;
  Socket? socketBeingChecked;

  bool advancedMode = false;
  bool hasSuccessfullyConnectedToHost = false;

  String customServerAddress = "",
      customServerPort = "",
      customServerError = "";

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();
    scan();
  }

  void scan() async {
    String ipAddress = "";

    if (kIsWeb) {
      setState(() {
        advancedMode = true;
      });
      return;
    }

    if (!kIsWeb) {
      var wifiIP = await NetworkInfo().getWifiIP();
      debugPrint("Wifi IP: $wifiIP");
      ipAddress = wifiIP ?? "";
    }

    if (ipAddress.isEmpty) {
      try {
        for (var interface in await NetworkInterface.list()) {
          for (var addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              ipAddress = addr.address;
              break;
            }
          }
        }
      } catch (e) {
        debugPrint('Error getting private IP address: $e');
      }
    }

    if (ipAddress.isEmpty) {
      return;
    }

    var subnet = ipToCSubnet(ipAddress);
    debugPrint("Scanning subnet $subnet");
    List<Host> hosts = await scanner!.quickIcmpScanAsync(subnet);

    hosts = await checkHosts(hosts);

    if (!mounted) {
      return;
    }

    setState(() {
      availableHosts = hosts;
    });

    if (availableHosts?.isEmpty ?? true) {
      setState(() {
        advancedMode = true;
      });
    }

    debugPrint("Found ${hosts.length} hosts");
  }

  Future<List<Host>> checkHosts(List<Host> hosts) async {
    final List<Future<Host?>> futures = [];

    for (var host in hosts) {
      futures.add(checkHost(host));
    }

    final List<Host?> reachableHosts = await Future.wait(futures);

    return reachableHosts.whereType<Host>().toList();
  }

  Future<Host?> checkHost(Host host, {int port = 3000}) async {
    try {
      socketBeingChecked = await Socket.connect(
        host.internetAddress,
        port,
        timeout: const Duration(milliseconds: 500),
      );

      socketBeingChecked?.destroy();
      socketBeingChecked = null;
      return host;
    } catch (e) {
      return null;
    }
  }

  Future<void> validateCustomHost() async {
    if (customServerAddress.isEmpty || customServerPort.isEmpty) {
      return;
    }

    if (MDNValidator.validateIPAddress(customServerAddress) != null ||
        MDNValidator.validatePort(customServerPort) != null) {
      return;
    }

    if (kIsWeb) {
      final Dio dio = Dio();
      final url = Uri.parse("http://$customServerAddress:$customServerPort/");
      final response = await dio.get(
        url.toString(),
      );

      if (response.statusCode != 200) {
        setState(() {
          customServerError = "Nie można połączyć się z serwerem";
          hasSuccessfullyConnectedToHost = false;
          selectedHost = null;
        });
        return;
      }

      setState(() {
        customServerError = "";
        selectedAddress = customServerAddress;
        selectedPort = customServerPort;
        hasSuccessfullyConnectedToHost = true;
      });
      return;
    }

    final hostToCheck = Host(
      internetAddress: InternetAddress(customServerAddress),
    );
    Host? host = await checkHost(
      hostToCheck,
      port: int.parse(customServerPort),
    );

    if (host == null) {
      //make sure we've not received a response from an old host request
      if (hostToCheck.internetAddress.address != customServerAddress) {
        validateCustomHost();
        return;
      }

      //make sure we're not currently checking a host (it could result in script stating that valid host is inaccesible)
      if (socketBeingChecked != null) {
        return;
      }

      setState(() {
        customServerError = "Nie można połączyć się z serwerem";
        hasSuccessfullyConnectedToHost = false;
        selectedHost = null;
      });
      return;
    }

    setState(() {
      customServerError = "";
      selectedHost = host;
      selectedAddress = customServerAddress;
      selectedPort = customServerPort;
      hasSuccessfullyConnectedToHost = true;
    });
  }

  void completeSetup() {
    if (selectedHost == null && !kIsWeb) {
      return;
    }
    if (kIsWeb && !hasSuccessfullyConnectedToHost) {
      return;
    }

    final serverSettingsBox = Hive.box<ServerSettings>('server_settings');
    serverSettingsBox.clear();
    serverSettingsBox.put(
      'server_settings',
      ServerSettings(
        ipAddress: selectedAddress!,
        port: int.parse(selectedPort ?? "3000"),
      ),
    );

    Modular.to.pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon.png",
                      width: 125,
                      height: 125,
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .scale(
                          duration: 2500.ms,
                          begin: const Offset(1, 1),
                          end: const Offset(1.025, 1.025),
                        )
                        .then()
                        .scale(
                          duration: 2500.ms,
                          begin: const Offset(1.025, 1.025),
                          end: const Offset(1, 1),
                        ),
                    const Text(
                      "Markdown Notepad",
                      style: TextStyle(
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          duration: 4.seconds,
                          color: const Color(0xFF80DDFF).withOpacity(.75),
                        ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: availableHosts != null
                          ? [
                              Text(
                                availableHosts!.isNotEmpty
                                    ? "Dostępne serwery w sieci lokalnej:"
                                    : "Nie znaleziono serwerów w sieci lokalnej",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ).animate().fadeIn(
                                    duration: 150.ms,
                                  ),
                              ...(availableHosts!.length > 10
                                      ? availableHosts!.sublist(0, 10)
                                      : availableHosts!)
                                  .mapIndexed(
                                (index, host) => Container(
                                  margin: EdgeInsets.only(
                                    top: index == 0 ? 8 : 0,
                                    bottom: index == availableHosts!.length - 1
                                        ? 0
                                        : 8,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedHost =
                                            selectedHost == host ? null : host;
                                        selectedAddress = selectedHost
                                            ?.internetAddress.address;
                                        selectedPort = customServerPort.isEmpty
                                            ? "3000"
                                            : customServerPort;
                                        hasSuccessfullyConnectedToHost =
                                            selectedHost != null;
                                        customServerError = "";
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                        horizontal: 8.0,
                                      ),
                                      child: Text.rich(TextSpan(children: [
                                        if (selectedHost
                                                ?.internetAddress.address ==
                                            host.internetAddress.address)
                                          const WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.baseline,
                                            baseline: TextBaseline.ideographic,
                                            child: Baseline(
                                              baseline: 10,
                                              baselineType:
                                                  TextBaseline.ideographic,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 6.0,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                        TextSpan(
                                            text:
                                                "${host.internetAddress.address} — ${host.pingTime?.inMilliseconds.toString()}ms")
                                      ])),
                                    ),
                                  ),
                                ).animate().fadeIn(
                                      duration: 150.ms,
                                    ),
                              )
                            ]
                          : kIsWeb
                              ? []
                              : [
                                  const Text(
                                    "Skanowanie sieci lokalnej...",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                                ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      onPressed: () {
                        setState(() {
                          advancedMode = !advancedMode;
                        });
                      },
                      child: const Text('Tryb zaawansowany'),
                    ),
                    SizedBox(height: advancedMode ? 16 : 8),
                    if (advancedMode)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        width: Responsive.isTablet(context) ||
                                Responsive.isMobile(context)
                            ? double.infinity
                            : 300.0,
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: customServerAddress,
                                onChanged: (value) {
                                  setState(() {
                                    customServerAddress = value;
                                    hasSuccessfullyConnectedToHost = false;
                                  });
                                  validateCustomHost();
                                },
                                onFieldSubmitted: (value) =>
                                    validateCustomHost(),
                                validator: (v) =>
                                    MDNValidator.validateIPAddress(v),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Adres serwera",
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: customServerPort,
                                onChanged: (value) {
                                  setState(() {
                                    customServerPort = value;
                                    hasSuccessfullyConnectedToHost = false;
                                  });
                                  validateCustomHost();
                                },
                                onFieldSubmitted: (value) =>
                                    validateCustomHost(),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (v) => MDNValidator.validatePort(v),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Port serwera (domyślnie 3000)",
                                ),
                              ),
                              if (customServerError.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    customServerError,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ).animate().fadeIn(
                                      duration: 150.ms,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(
                                hasSuccessfullyConnectedToHost ? 1 : .5),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      onPressed: () {
                        if (!hasSuccessfullyConnectedToHost) return;

                        completeSetup();
                      },
                      child: const Text('Przejdź dalej'),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 250.ms)
            ],
          ),
        ),
      ),
    );
  }
}
