import 'package:bitcoin_ticker/services/networking.dart';

const List<String> currenciesList = [
  'USD',
  'NGN',
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
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '582B8017-81BC-45BC-9B5E-8C8B7F4CE483';

class CoinData {
  //TODO: Create your getCoinData() method here.
  Future<dynamic> getCoinData(currency) async {
    Map cryptoMap = {};
    for (String coin in cryptoList) {
      var url = '$coinAPIURL/$coin/$currency?apikey=$apiKey';
      NetworkHelper networkHelper = NetworkHelper(url);
      var coinData = await networkHelper.getData();
      cryptoMap[coin] = coinData;
    }

    return cryptoMap;
  }
}
