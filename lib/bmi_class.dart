import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bmi_calculator/components/icon_content.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:bmi_calculator/constants.dart';
import 'package:bmi_calculator/screens/results_page.dart';
import 'package:bmi_calculator/components/bottom_button.dart';
import 'package:bmi_calculator/components/round_icon_button.dart';
import 'package:bmi_calculator/calculator_brain.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:io';

// ****************** DEGERLER ******************
String battery = '-999';
String battery_temperature = '-999';
String speed = '-999';
Timer? timer;
String x_accel = '-999', y_accel = '-999', z_accel = '-999';
String x_slope = '-999', y_slope = '-999', z_slope = '-999';
// **********************************************

class BMICalculator extends StatelessWidget {
  final BluetoothDevice server;

  const BMICalculator({required this.server});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: InputPage(server: server),
    );
  }
}

enum Speed {
  none,
  speed5,
  speed10,
  speed15,
}

class InputPage extends StatefulWidget {
  final BluetoothDevice server;

  const InputPage({required this.server});
  @override
  _InputPageState createState() => _InputPageState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _InputPageState extends State<InputPage> {
  // YENİ TANIMLAMALAR
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  // ESKİ TANIMLAMALAR
  Speed selectedSpeed = Speed.none;
  int height = 8;
  int weight = 60;
  int age = 30;
  int temperature = 30;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      timer = Timer.periodic(
          Duration(milliseconds: 2300), (Timer t) => _sendMessage());
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {}
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      x_accel = event.x.toStringAsFixed(2);
      y_accel = event.y.toStringAsFixed(2);
      z_accel = event.z.toStringAsFixed(2);
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      x_slope = event.x.toStringAsFixed(2);
      y_slope = event.y.toStringAsFixed(2);
      z_slope = event.z.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMS IS THE BEST :)'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ReusableCard(
              onPress: () => {},
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'SPEED',
                    style: kLabelTextStyle,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        speed.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        'km/h',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'BATTERY',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          "%" + battery.toString(),
                          style: kNumberTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'TEMPERATURE',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          battery_temperature.toString() + ' °C',
                          style: kNumberTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () => {
                      _sendSpeed('speed5');
                      setState(() {
                        selectedSpeed = Speed.speed5;
                      })
                    },
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '5',
                          style: kNumberTextStyle,
                        ),
                        Text(
                          "km/h",
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () => {_sendSpeed('speed10')},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '10',
                          style: kNumberTextStyle,
                        ),
                        Text(
                          "km/h",
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () => {_sendSpeed('speed15')},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '15',
                          style: kNumberTextStyle,
                        ),
                        Text(
                          "km/h",
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    String actualData = backspacesCounter > 0
        ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
        : _messageBuffer + dataString.substring(0, index);
    Map<String, dynamic> values = jsonDecode(actualData);
    if (~index != 0) {
      setState(() {
        battery = values['batvolt'].toString();
        battery_temperature = values['temp'].toString();
        speed = values['speed'].toString();
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendSpeed(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {});

        Future.delayed(Duration(milliseconds: 333)).then((_) {});
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  _sendMessage() async {
    String message_json = 'xacl:' +
        x_accel +
        '--yacl:' +
        y_accel +
        '--zacl:' +
        z_accel +
        '--xslp:' +
        x_slope +
        '--yslp:' +
        y_slope +
        '--zslp:' +
        z_slope;
    if (message_json.length > 0) {
      try {
        connection!.output
            .add(Uint8List.fromList(utf8.encode(message_json + "\r\n")));
        await connection!.output.allSent;

        Future.delayed(Duration(milliseconds: 333));
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
