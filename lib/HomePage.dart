import 'package:dapp/models/EthereumUtils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EthereumUtils ethereumUtils = EthereumUtils();
  var _data;
  bool loading = false;
  TextEditingController yourNameController = TextEditingController();
  @override
  void initState() {
    ethereumUtils.initial();
    ethereumUtils.getBalance().then((value) {
      _data = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Flutter DApp Wallet",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: _data == null
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Your Balance: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  Text(
                                    _data.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: yourNameController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Amount",
                                      hintText: "Enter Amount",),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  height: height * 0.085,
                                  width: width / 1.5,
                                  child: FilledButton.tonal(
                                    child: const Text(
                                      'Get Balance',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    onPressed: () {
                                      loading = true;
                                      setState(() {});
                                      ethereumUtils.getBalance().then((value) {
                                        _data = value;
                                        loading = false;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  height: height * 0.085,
                                  width: width / 1.5,
                                  child: FilledButton.tonal(
                                    onPressed: () {
                                      loading = true;
                                      setState(() {});
                                      ethereumUtils.deposit(
                                          BigInt.parse(yourNameController.text));
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                            loading = false;
                                            setState(() {});
                                            Fluttertoast.showToast(
                                              msg: "Amount Deposited",
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0,
                                            );
                                      });
                                      yourNameController.clear();
                                    },
                                    child: const Text(
                                      'Deposit',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  height: height * 0.085,
                                  width: width / 1.5,
                                  child: FilledButton.tonal(
                                    onPressed: () {
                                      loading = true;
                                      setState(() {});
                                      ethereumUtils.withdraw(
                                          BigInt.parse(yourNameController.text));
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                            loading = false;
                                            setState(() {});
                                            Fluttertoast.showToast(
                                              msg: "Withdrawal Success",
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0,
                                            );
                                      });
                                      yourNameController.clear();
                                    },
                                    child: const Text(
                                      'Withdraw',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
