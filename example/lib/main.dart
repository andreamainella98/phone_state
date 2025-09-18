import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

main() {
  runApp(const MaterialApp(home: Example()));
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied => false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone State'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                        });
                      }
                    : null,
                child: const Text(
                  'Request permission of Phone and start listener',
                ),
              ),
            StreamBuilder(
              stream: PhoneState.stream,
              builder: (context, snapshot) {
                PhoneState? status = snapshot.data;
                if (status == null) {
                  return Text('Phone State not available');
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        'Status of call: ${status.status}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      if (status.status == PhoneStateStatus.CALL_INCOMING ||
                          status.status == PhoneStateStatus.CALL_STARTED)
                        Text(
                          'Number: ${status.number}',
                          style: const TextStyle(fontSize: 24),
                        ),
                      if (status.duration != null)
                        Text(
                          'Duration of call: ${_formatDuration(status.duration!)}',
                          style: const TextStyle(fontSize: 24),
                        ),
                      Icon(
                        getIcons(status.status),
                        color: getColor(status.status),
                        size: 80,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = duration.inHours > 0
        ? '${twoDigits(duration.inHours)}:'
        : '';
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours$minutes:$seconds';
  }

  IconData getIcons(PhoneStateStatus status) {
    return switch (status) {
      PhoneStateStatus.NOTHING => Icons.clear,
      PhoneStateStatus.CALL_INCOMING ||
      PhoneStateStatus.CALL_OUTGOING => Icons.add_call,
      PhoneStateStatus.CALL_STARTED => Icons.call,
      PhoneStateStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor(PhoneStateStatus status) {
    return switch (status) {
      PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
      PhoneStateStatus.CALL_INCOMING ||
      PhoneStateStatus.CALL_OUTGOING => Colors.green,
      PhoneStateStatus.CALL_STARTED => Colors.orange,
    };
  }
}
