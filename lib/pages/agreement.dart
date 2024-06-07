import 'package:flutter/material.dart';
import 'package:stepit/pages/Identification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Terms And Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Welcome to Stepit',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        // Wrap the SingleChildScrollView with a Container
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 219, 218,
                                  218), // Change this color as needed
                              spreadRadius: 2, // Change this value as needed
                              blurRadius: 100, // Change this value as needed
                              offset: Offset(0, 3), // Change this value as needed
                            ),
                          ],
                        ),
                        child: const SingleChildScrollView(
                          child: Text(
                            'This Agreement is entered into by and between the user, hereinafter referred to as "User", '
                            'and Stepit, hereinafter referred to as "Company". \n\n'
                            '1. Terms and Conditions: User agrees to abide by all terms and conditions of this Agreement, '
                            'as well as any additional terms and conditions presented by the Company.\n '
                            '2. Privacy: User acknowledges and agrees that the Company may collect and use personal information '
                            'from the User in accordance with the Company\'s privacy policy.\n '
                            '3. Intellectual Property: User acknowledges and agrees that all content provided by the Company '
                            'is the intellectual property of the Company and is protected by copyright, trademark, and other laws.\n '
                            '4. Limitation of Liability: User acknowledges and agrees that the Company will not be liable for '
                            'any direct, indirect, incidental, special, consequential or exemplary damages, including but not limited '
                            'to, damages for loss of profits, goodwill, use, data or other intangible losses resulting from the use of '
                            'or inability to use the service.\n '
                            '5. Termination: User acknowledges and agrees that the Company may terminate this Agreement at any time '
                            'for any reason, including but not limited to, breach of this Agreement by the User. '
                            '6. Governing Law: This Agreement shall be governed by and construed in accordance with the laws of the '
                            'jurisdiction in which the Company is located. \n'
                            'By using the services provided by the Company, the User agrees to be bound by this Agreement. '
                            'If the User does not agree to abide by the terms of this Agreement, the User is not authorized to use '
                            'or access the services provided by the Company.',
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: _agreed,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreed = value ?? false;
                            });
                          },
                        ),
                        const Text('I agree to the terms and conditions.'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _agreed ? () async
                          {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('first_time', false);
                
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdentificationPage()),
                              );
                            }
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
