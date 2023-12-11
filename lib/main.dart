import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

import 'settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

TextEditingController productCodeController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController commentController = TextEditingController();

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  _getPermission() async => await [
        Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  final MultiSelectController<String> _controller =
      MultiSelectController(deSelectPerpetualSelectedItems: true);
  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Paklausk boso'),
        ),
        endDrawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[300],
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                // use the new context to access the navigator
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: const Text('nustatymai'),
            ),
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Prekės kodas/barkodas',
                ),
                keyboardType: TextInputType.number,
                controller: productCodeController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'kaina',
                ),
                keyboardType: TextInputType.number,
                // The validator receives the text that the user has entered.
                controller: priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(hintText: 'Komentaras apie klientą'),
                controller: commentController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MultiSelectContainer(
                    controller: _controller,
                    items: [
                      MultiSelectCard(value: '862500815', label: 'Vytautas'),
                      MultiSelectCard(value: '867140728', label: 'Nerijus TV'),
                      MultiSelectCard(
                          value: '+37068567377', label: 'Vietoj Vilmanto'),
                    ],
                    onChange: (allSelectedItems, selectedItem) {
                      // Print the list of selected values to the console
                      print(allSelectedItems);
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.send),
          onPressed: () async {
            final list = _controller.getSelectedItems();
            if (await _isPermissionGranted()) {
              if ((await _supportCustomSim)!)
                // ignore: curly_braces_in_flow_control_structures
                for (String number in list) {
                  _sendMessage(number,
                      "Prekės kodas: ${productCodeController.text}\nPrekės kaina: ${priceController.text}\nKomentaras: ${commentController.text} ",
                      simSlot: 1);
                }
            } else
              _getPermission();
          },
        ),
      ),
    ));
  }
}
