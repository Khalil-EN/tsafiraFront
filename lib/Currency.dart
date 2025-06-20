import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white, // Set scaffold background color
      ),
      home: CurrencyPickerPage(), // Specify CurrencyPickerPage as the home page
    );
  }
}

// Add a stateful widget to track the selected currency
class CurrencyPickerPage extends StatefulWidget {
  @override
  _CurrencyPickerPageState createState() => _CurrencyPickerPageState();
}

class _CurrencyPickerPageState extends State<CurrencyPickerPage> {
  Currency? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Select currency',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  height: 330,
                  child: Image.asset(
                    'assets/logo2.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Choosing your currency helps us make your travel even better!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                // Separate the picker from the submit button
                ElevatedButton(
                  onPressed: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      onSelect: (Currency currency) {
                        setState(() {
                          selectedCurrency = currency;
                        });
                        print('Selected currency: ${currency.name}');
                      },
                      theme: CurrencyPickerThemeData(
                        flagSize: 25,
                        titleTextStyle: TextStyle(fontSize: 17),
                        subtitleTextStyle: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                        ),
                        bottomSheetHeight:
                        MediaQuery.of(context).size.height / 2,
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'Select Currency',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007AFF),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  selectedCurrency != null
                      ? 'Selected Currency: ${selectedCurrency!.name}'
                      : 'No Currency Selected',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

              ],
            ),
          ),
          SizedBox(height: 20),
          Container(margin: EdgeInsets.fromLTRB(250, 15, 10, 10) ,child: ElevatedButton(onPressed: (){},child: Text('>', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(shape: CircleBorder(),padding: EdgeInsets.all(15),backgroundColor: Colors.blue),))
          /*TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Skip for now',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 20),*/
        ],
      ),
    );
  }
}

