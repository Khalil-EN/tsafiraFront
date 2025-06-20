import 'package:flutter/material.dart';
import 'package:table_calendar_example/Currency.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Budget(),
    );
  }
}

class Budget extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<Budget> {
  final TextEditingController _budgetController = TextEditingController(text: '0');
  final FocusNode _budgetFocusNode = FocusNode();
  double hotelPercentage = 25;
  double restaurantPercentage = 25;
  double activitiesPercentage = 25;
  double transportPercentage = 25;
  double hotelBudget = 0;
  double restaurantBudget = 0;
  double activitiesBudget = 0;
  double transportBudget = 0;
  bool _showAdvancedOptions = false;

  @override
  void initState() {
    super.initState();
    _budgetController.addListener(_handleBudgetChange);
    _budgetFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _budgetController.removeListener(_handleBudgetChange);
    _budgetFocusNode.removeListener(_handleFocusChange);
    _budgetController.dispose();
    _budgetFocusNode.dispose();
    super.dispose();
  }

  void _handleBudgetChange() {
    setState(() {});
  }

  void _handleFocusChange() {
    if (!_budgetFocusNode.hasFocus) {
      if (_budgetController.text.isEmpty) {
        setState(() {
          _budgetController.text = '0';
          _budgetController.selection = TextSelection.fromPosition(
            TextPosition(offset: _budgetController.text.length),
          );
        });
      }
    }
  }

  void _resetValues() {
    setState(() {
      _budgetController.text = '0';
      hotelPercentage = 25;
      restaurantPercentage = 25;
      activitiesPercentage = 25;
      transportPercentage = 25;
      hotelBudget = 0;
      restaurantBudget = 0;
      activitiesBudget = 0;
      transportBudget = 0;
    });
  }

  void _updatePercentage() {
    double totalBudget = double.tryParse(_budgetController.text) ?? 0;
    setState(() {
      hotelBudget = totalBudget * (hotelPercentage / 100);
      restaurantBudget = totalBudget * (restaurantPercentage / 100);
      activitiesBudget = totalBudget * (activitiesPercentage / 100);
      transportBudget = totalBudget * (transportPercentage / 100);
    });
  }

  bool get _isBudgetSet {
    return double.tryParse(_budgetController.text) != null && double.parse(_budgetController.text) > 0;
  }

  void _toggleAdvancedOptions() {
    if (_isBudgetSet) {
      setState(() {
        _showAdvancedOptions = !_showAdvancedOptions;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have to set a value first')),
      );
    }
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(3);
  }

  void _adjustPercentages(double newValue, Function(double) setPercentage) {
    double totalPercentage = hotelPercentage + restaurantPercentage + activitiesPercentage + transportPercentage;
    double remainingPercentage = 100 - (totalPercentage - newValue);
    if (remainingPercentage >= 0) {
      setState(() {
        setPercentage(newValue);
        _updatePercentage();
      });
    }
  }

  void _adjustBudgets(double newValue, Function(double) setBudget) {
    double totalBudget = double.tryParse(_budgetController.text) ?? 0;
    setState(() {
      setBudget(newValue);
      hotelPercentage = (hotelBudget / totalBudget) * 100;
      restaurantPercentage = (restaurantBudget / totalBudget) * 100;
      activitiesPercentage = (activitiesBudget / totalBudget) * 100;
      transportPercentage = (transportBudget / totalBudget) * 100;
      _updatePercentage();
    });
  }

  Widget _buildCategoryContainer(String category, Color color, double budget, double percentage, Function(double) setPercentage, Function(double) setBudget) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEFEFF1)),
        borderRadius: BorderRadius.circular(23.1),
        color: Color(0xFFFEFEFE),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F22183F),
            offset: Offset(0, 32.1),
            blurRadius: 25.7,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24.4, 24.4, 24.4, 29.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20.6, 0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    width: 57.8,
                    height: 57.8,
                    padding: EdgeInsets.fromLTRB(16.7, 15.4, 15.4, 15.4),
                    child: Center(
                    ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF303149),
                    ),
                  ),
                ],
              ),
              Text(
                '\$${_formatNumber(budget)}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF303149),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.4),
          Text(
            'Remaining budget',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF303149),
            ),
          ),
          SizedBox(height: 11.1),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                double newPercentage = (percentage + details.delta.dx / 3).clamp(0, 100);
                _adjustPercentages(newPercentage, setPercentage);
              });
            },
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3.35),
                  ),
                ),
                Container(
                  width: percentage / 100 * MediaQuery.of(context).size.width,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3.35),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: color),
                onPressed: () {
                  setState(() {
                    budget = (budget - 10).clamp(0, double.infinity);
                    setBudget(budget);
                    _updatePercentage();
                  });
                },
              ),
              Text(
                '\$${_formatNumber(budget)}',
                style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
              ),
              IconButton(
                icon: Icon(Icons.add, color: color),
                onPressed: () {
                  setState(() {
                    budget += 10;
                    setBudget(budget);
                    _updatePercentage();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 8), // Increase height by 8 pixels
        child: Container(
          padding: EdgeInsets.only(top: 8), // Move down by 8 pixels
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF303149)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Center(
              child: Text('Budget', style: TextStyle(color: Color(0xFF303149), fontFamily: 'Inter')),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.restart_alt, color: Color(0xFF303149)),
                onPressed: _resetValues,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.7),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C35405A),
                      offset: Offset(0, 20),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Text(
                            'Total Budget',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF303149),
                            ),
                          ),
                          TextField(
                            controller: _budgetController,
                            focusNode: _budgetFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _toggleAdvancedOptions,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.8)),
                        side: BorderSide(color: Color(0xFFEFEFF1)),
                      ),
                      child: Text(
                        'Advanced Options',
                        style: TextStyle(
                          color: Color(0xFF303149),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.7),
              Visibility(
                visible: _showAdvancedOptions,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFF4F4F6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advanced Options',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      SizedBox(height: 20),
                      _buildCategoryContainer('Hotel', Color(0xFFF25041), hotelBudget, hotelPercentage, (value) {
                        setState(() {
                          hotelPercentage = value;
                          _updatePercentage();
                        });
                      }, (value) {
                        setState(() {
                          hotelBudget = value;
                          _updatePercentage();
                        });
                      }),
                      _buildCategoryContainer('Restaurant', Color(0xFF56BBDB), restaurantBudget, restaurantPercentage, (value) {
                        setState(() {
                          restaurantPercentage = value;
                          _updatePercentage();
                        });
                      }, (value) {
                        setState(() {
                          restaurantBudget = value;
                          _updatePercentage();
                        });
                      }),
                      _buildCategoryContainer('Activities', Color(0xFFFFC0CB), activitiesBudget, activitiesPercentage, (value) {
                        setState(() {
                          activitiesPercentage = value;
                          _updatePercentage();
                        });
                      }, (value) {
                        setState(() {
                          activitiesBudget = value;
                          _updatePercentage();
                        });
                      }),
                      _buildCategoryContainer('Transport', Colors.orange, transportBudget, transportPercentage, (value) {
                        setState(() {
                          transportPercentage = value;
                          _updatePercentage();
                        });
                      }, (value) {
                        setState(() {
                          transportBudget = value;
                          _updatePercentage();
                        });
                      }),
                    ],
                  ),
                ),
              ),
              Container(margin: EdgeInsets.fromLTRB(250, 295, 10, 10) ,child: ElevatedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => CurrencyPickerPage()));},child: Text('>', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(shape: CircleBorder(),padding: EdgeInsets.all(15),backgroundColor: Colors.blue),))
            ],
          ),
        ),
      ),
    );
  }
}
