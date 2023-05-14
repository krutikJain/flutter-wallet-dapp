import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class EthereumUtils {
  late Web3Client web3client;
  late Client client;

  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];

  void initial() {
    client = Client();
    String infuraApi =
        "https://sepolia.infura.io/v3/728bfc0e3fdd4cd28df127be231b145c";
    web3client = Web3Client(infuraApi, client);
  }

  Future getBalance() async {
    final contract = await getDeployedContract();
    final etherFunction = contract.function("balance");
    final result = await web3client
        .call(contract: contract, function: etherFunction, params: []);
    List<dynamic> res = result;
    return res[0];
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi = await rootBundle.loadString("./assets/abi.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Wallet"),
        EthereumAddress.fromHex(contractAddress!));
    return contract;
  }

  Future<String> deposit(BigInt amount) async {
    EthPrivateKey privateKeyCred =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function('deposit');
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
            contract: contract,
            function: etherFunction,
            parameters: [amount],
        ),
        chainId: 11155111,
        fetchChainIdFromNetworkId: false);
    print(result);
    return result;
  }

  Future<String> withdraw(BigInt amount) async {
    EthPrivateKey privateKeyCred =
    EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function('withdraw');
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
          contract: contract,
          function: etherFunction,
          parameters: [amount],
        ),
        chainId: 11155111,
        fetchChainIdFromNetworkId: false);
    print(result);
    return result;
  }
}
