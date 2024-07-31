import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CarInsuranceService extends ChangeNotifier {
  final String _rpcUrl =
      'https://sepolia.infura.io/v3/${dotenv.env['INFURA_PROJECT_ID']}';
  final String _wsUrl =
      'wss://sepolia.infura.io/ws/v3/${dotenv.env['INFURA_PROJECT_ID']}';
  final String _privateKey = dotenv.env['PRIVATE_KEY']!;
  final String ca = dotenv.env['CONTRACT_ADDRESS']!;

  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  bool isInitialized = false;

  CarInsuranceService() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();

    isInitialized = true;
    notifyListeners();
  }

  Future<void> getAbi() async {
    final abiString =
        await rootBundle.loadString('assets/CarInsuranceTracker.json');
    final jsonAbi = jsonDecode(abiString);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress = EthereumAddress.fromHex(dotenv.env['CONTRACT_ADDRESS']!);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    var address = await _credentials.extractAddress();
    print('Using address: ${address.hex}');
  }

  Future<void> getDeployedContract() async {
    final abiJson = jsonDecode(_abiCode);
    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abiJson), 'CarInsuranceTracker'),
      _contractAddress,
    );
  }

  Future<String> setExpirationDate(DateTime date) async {
    var responseMsg = "Date set successfuly!";
    if (!isInitialized) await initiateSetup();
    final function = _contract.function('setExpirationDate');
    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: [BigInt.from(date.millisecondsSinceEpoch ~/ 1000)],
      );
      print('Estimated gas: ${await _client.estimateGas(
        sender: await _credentials.extractAddress(),
        to: _contractAddress,
        data: transaction.data,
      )}');
      final result = await _client.sendTransaction(
        _credentials,
        transaction,
        chainId: 11155111,
      );
      print('Transaction sent: ${result}');
      final receipt = await _client.getTransactionReceipt(result);
      print('Transaction receipt: ${receipt}');
    } catch (e) {
      responseMsg = e.toString();
      print('Error in setExpirationDate: $e');
      //rethrow;
    }
    notifyListeners();

    return responseMsg;
  }

  Future<DateTime> getExpirationDate() async {
    final function = _contract.function('getExpirationDate');
    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [],
    );
    return DateTime.fromMillisecondsSinceEpoch(
        (result[0] as BigInt).toInt() * 1000);
  }

  Future<bool> isInsuranceExpired() async {
    final function = _contract.function('isInsuranceExpired');
    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [],
    );
    return result[0] as bool;
  }
}
