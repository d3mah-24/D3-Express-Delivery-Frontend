import 'package:flutter/material.dart';

import '../main.dart';
import 'Home.dart';

class Add_order extends StatefulWidget {
  const Add_order({super.key});

  @override
  State<Add_order> createState() => _Add_orderState();
}

class _Add_orderState extends State<Add_order> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerSenderName = TextEditingController();

  final TextEditingController _controllerSenderTelephone =
      TextEditingController();
  final TextEditingController _controllerReceiverName = TextEditingController();

  final TextEditingController _controllerReceiverTelephone =
      TextEditingController();
  final TextEditingController _controllerWayBillNo = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  var address=<String>['Option 1', 'Option 2', 'Option 3'];
  var payment=<String>['CASH', 'COD'] ;

  String selectedValueSenderAddress = 'Option 1';
  String selectedValueReceiverAddress = 'Option 1';
  String selectedValuePayment= 'CASH';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: CustomAppBar(type: "1"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                "Enter Full Order Information",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              // 1
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(height: 1),
                controller: _controllerSenderName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Sender Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Sender Name.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(height: 1),
                controller: _controllerSenderTelephone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Sender Phone No",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Sender Phone No.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: 8),
                  const Text(
                    "Sender Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValueSenderAddress,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedValueSenderAddress = newValue;
                          });
                        }
                      },
                      items: address.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),


              // 2
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(height: 1),
                controller: _controllerReceiverName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Receiver Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Receiver Name.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(height: 1),
                controller: _controllerReceiverTelephone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Receiver Phone No",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Receiver Phone No.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(height: 1),
                controller: _controllerReceiverTelephone,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Price",
                  prefixIcon: const Icon(Icons.price_check_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Receiver Phone No.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: 8),
                  const Text(
                    "Receiver Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValueReceiverAddress,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedValueReceiverAddress = newValue;
                          });
                        }
                      },
                      items:  address.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.payment_rounded),
                  const SizedBox(width: 8),
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValuePayment,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedValuePayment = newValue;
                          });
                        }
                      },
                      items:  payment.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),



              const SizedBox(height: 16),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // if (_controllerUsername.text.isNotEmpty){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const MyHomePage();
                          },
                        ),
                      );
                    },

                    // },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
