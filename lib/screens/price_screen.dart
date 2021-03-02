import 'package:flutter/material.dart';
import '../services/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  var btcRate;
  var ethRate;
  var ltcRate;

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      dropDownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        // print(value);
        setState(() {
          selectedCurrency = value;
          getData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(
          currency,
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData(selectedCurrency);
        });
      },
      children: pickerItems,
    );
  }

  //TODO: Create a method here called getData() to get the coin data from coin_data.dart

  bool isWaiting = false;

  void getData(currency) async {
    isWaiting = true;
    var coinMapValues = await coinData.getCoinData(currency);
    isWaiting = false;
    setState(() {
      if (coinMapValues['BTC'] == null) {
        btcRate = '?';
        ethRate = '?';
        ltcRate = '?';
        return;
      }
      btcRate = coinMapValues['BTC']['rate'].toInt();
      ethRate = coinMapValues['ETH']['rate'].toInt();
      ltcRate = coinMapValues['LTC']['rate'].toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    //TODO: Call getData() when the screen loads up.
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                coinType: 'BTC',
                coinRate: isWaiting ? '?' : btcRate,
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                coinType: 'ETH',
                coinRate: isWaiting ? '?' : ethRate,
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                coinType: 'LTC',
                coinRate: isWaiting ? '?' : ltcRate,
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.coinType,
    @required this.coinRate,
    @required this.selectedCurrency,
  });

  final String coinType;
  final coinRate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            //TODO: Update the Text Widget with the live bitcoin data here.
            '1 $coinType = $coinRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
