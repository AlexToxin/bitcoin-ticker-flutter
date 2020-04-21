import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

import 'constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, Map<String, double>> exchangeRate = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> data = [];

    currenciesList.forEach((item) {
      data.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    });

    return DropdownButton<String>(
      value: selectedCurrency,
      items: data,
      onChanged: (String value) {
        setState(() {
          selectedCurrency = value;
          requestExchangeRate(forCurrency: selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> data = [];
    for (String item in currenciesList)
      data.add(
        Text(
          item,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

    return CupertinoPicker(
      children: data,
      itemExtent: 32,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (int value) {
        setState(() {
          selectedCurrency = value.toString();
          requestExchangeRate(forCurrency: selectedCurrency);
        });
      },
    );
  }

  List<Widget> cryptoWidgetList() {
    List<Widget> result = [];
    for (String currency in cryptoList)
      result.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $currency = ${getExchangeRate(
                    currency, selectedCurrency)} $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    return result;
  }

  String getExchangeRate(from, to) {
    try {
      return exchangeRate[from][to].toStringAsFixed(2);
    } catch (e) {
      print(e);
      return '?';
    }
  }

  void requestExchangeRate({forCurrency}) async {
    for (String cryptoCurrency in cryptoList) {
      Http.Response response = await Http.get(
          '$coinApiExchangeUrl/$cryptoCurrency${forCurrency != null
              ? '/$forCurrency'
              : ''}?apiKey=$apiKey');

      if (response.statusCode != 200) return;

      var data = jsonDecode(response.body);

      if (forCurrency != null) {
        writeExchangeRate(cryptoCurrency, data);
        continue;
      }

      for (Map dataCurrency in data['rates']) {
        writeExchangeRate(cryptoCurrency, dataCurrency);
      }
    }
    setState(() {});
  }

  void writeExchangeRate(cryptoCurrencyName, data) {
    try {
      String currencyName = data["asset_id_quote"];
      double currencyExchangeRate = data["rate"].toDouble();

      exchangeRate[cryptoCurrencyName] ??= {};
      exchangeRate[cryptoCurrencyName][currencyName] = currencyExchangeRate;
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    requestExchangeRate();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoWidgetList() +
            <Widget>[
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iOSPicker() : androidDropdown(),
              ),
            ],
      ),
    );
  }
}
