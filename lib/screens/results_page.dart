import 'package:flutter/material.dart';
import 'package:bmi_calculator/constants.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bmi_calculator/components/icon_content.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:bmi_calculator/components/bottom_button.dart';
import 'package:bmi_calculator/components/round_icon_button.dart';
import 'package:bmi_calculator/calculator_brain.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// ****************** DEGERLER ******************
String voltage0 = '-999';
String voltage1 = '-999';
String voltage2 = '-999';
String voltage3 = '-999';
String voltage4 = '-999';
String voltage5 = '-999';
String voltage6 = '-999';
String voltage7 = '-999';
String voltage8 = '-999';
String voltage9 = '-999';

// **********************************************

enum Gender {
  male,
  female,
}

class ResultsPage extends StatelessWidget {
  final BluetoothDevice server;

  ResultsPage({required this.server});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: OutputPage(server: server),
    );
  }
}

class OutputPage extends StatefulWidget {
  final BluetoothDevice server;

  const OutputPage({required this.server});
  @override
  _OutputPage createState() => _OutputPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _OutputPage extends State<OutputPage> {
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
  Gender selectedGender = Gender.male;
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
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
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
                          'VOLTAGE 1',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //weight.toString() + ' V',
                          voltage0.toString() + ' V',
                          style: kVoltageTextStyle,
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
                          'VOLTAGE 2',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage1.toString() + ' V',
                          style: kVoltageTextStyle,
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
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'VOLTAGE 3',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage2.toString() + ' V',
                          style: kVoltageTextStyle,
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
                          'VOLTAGE 4',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage3.toString() + ' V',
                          style: kVoltageTextStyle,
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
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'VOLTAGE 5',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage4.toString() + ' V',
                          style: kVoltageTextStyle,
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
                          'VOLTAGE 6',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage5.toString() + ' V',
                          style: kVoltageTextStyle,
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
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'VOLTAGE 7',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage6.toString() + ' V',
                          style: kVoltageTextStyle,
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
                          'VOLTAGE 8',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage7.toString() + ' V',
                          style: kVoltageTextStyle,
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
                    onPress: () => {},
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'VOLTAGE 9',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage8.toString() + ' V',
                          style: kVoltageTextStyle,
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
                          'VOLTAGE 10',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          //age.toString() + ' V',
                          voltage9.toString() + ' V',
                          style: kVoltageTextStyle,
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
        voltage0 = values['voltage0'].toString();
        voltage1 = values['voltage1'].toString();
        voltage2 = values['voltage2'].toString();
        voltage3 = values['voltage3'].toString();
        voltage4 = values['voltage4'].toString();
        voltage5 = values['voltage5'].toString();
        voltage6 = values['voltage6'].toString();
        voltage7 = values['voltage7'].toString();
        voltage8 = values['voltage8'].toString();
        voltage9 = values['voltage9'].toString();
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
