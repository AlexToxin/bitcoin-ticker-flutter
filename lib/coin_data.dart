import 'package:flutter/material.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  List<DropdownMenuItem<String>> toDropdownMenuItems() {
    List<DropdownMenuItem<String>> result = [];

//    currenciesList.forEach((item) {
    for (String item in currenciesList) {
      result.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    }

    return result;
  }
}
