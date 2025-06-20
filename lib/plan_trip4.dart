import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'plan_trip5.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider

class TravelDatesScreen extends StatefulWidget {
  const TravelDatesScreen({Key? key}) : super(key: key);

  @override
  _TravelDatesScreenState createState() => _TravelDatesScreenState();
}

class _TravelDatesScreenState extends State<TravelDatesScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  
  // Get current date for minimum selectable date
  final DateTime _today = DateTime.now();
  // Maximum selectable date (1 year from now)
  final DateTime _maxDate = DateTime.now().add(const Duration(days: 365));
  // Minimum viewable date (1 year before now)
  final DateTime _minViewDate = DateTime.now().subtract(const Duration(days: 365));
  
  // Flag to show warning message
  bool _showWarning = false;
  
  // Function to format date for display
  String _getMonthYear(DateTime date) {
    return DateFormat.yMMMM().format(date); // "June 2024"
  }
  
  // Check if we're trying to view a month before the minimum viewable date
  bool _isBeforeMinViewDate(DateTime date) {
    return date.isBefore(DateTime(_minViewDate.year, _minViewDate.month, 1));
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              
              const SizedBox(height: 16),
              
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Travel Dates",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              
              // Fixed space to position calendar in the middle
              const SizedBox(height: 60),
              
              // Month navigation row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        final previousMonth = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                        if (_isBeforeMinViewDate(previousMonth)) {
                          setState(() {
                            _showWarning = true;
                          });
                          // Hide warning after 3 seconds
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                _showWarning = false;
                              });
                            }
                          });
                        } else {
                          setState(() {
                            _focusedDay = previousMonth;
                            _showWarning = false;
                          });
                        }
                      },
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      _getMonthYear(_focusedDay),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                          _showWarning = false;
                        });
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Warning message
              if (_showWarning)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "You cannot go back more than a year",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Calendar in a fixed height container
              SizedBox(
                height: 350, // Fixed height for calendar
                child: TableCalendar(
                  firstDay: _minViewDate, // Allow viewing past year
                  lastDay: _maxDate,
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  headerVisible: false, // Hide the default header
                  
                  // Style the calendar
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.black),
                    weekendTextStyle: const TextStyle(color: Colors.black),
                    outsideTextStyle: const TextStyle(color: Colors.grey),
                    disabledTextStyle: const TextStyle(color: Colors.grey),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF6C63FF), // Purple for selected
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6C63FF), width: 1),
                    ),
                    todayTextStyle: const TextStyle(color: Colors.black),
                    rangeStartDecoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: const Color(0xFF6C63FF).withOpacity(0.2),
                    rangeStartTextStyle: const TextStyle(color: Colors.white),
                    rangeEndTextStyle: const TextStyle(color: Colors.white),
                  ),
                  
                  selectedDayPredicate: (day) {
                    // Use for single date selection or to highlight start/end dates
                    return isSameDay(_selectedStartDate, day) || 
                          (_selectedEndDate != null && isSameDay(_selectedEndDate, day));
                  },
                  
                  // Enable range selection
                  rangeStartDay: _selectedStartDate,
                  rangeEndDay: _selectedEndDate,
                  rangeSelectionMode: RangeSelectionMode.enforced,
                  
                  // Handle day selection
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  
                  // Handle range selection
                  onRangeSelected: (start, end, focusedDay) {
                    setState(() {
                      _selectedStartDate = start;
                      _selectedEndDate = end;
                      _focusedDay = focusedDay;
                    });
                  },
                  
                  // Ensure the calendar is updated when the focused day changes
                  onPageChanged: (focusedDay) {
                    // Check if we're trying to go before the minimum viewable date
                    if (_isBeforeMinViewDate(focusedDay)) {
                      setState(() {
                        _focusedDay = DateTime(_minViewDate.year, _minViewDate.month, 1);
                        _showWarning = true;
                      });
                      // Hide warning after 3 seconds
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() {
                            _showWarning = false;
                          });
                        }
                      });
                    } else {
                      setState(() {
                        _focusedDay = focusedDay;
                        _showWarning = false;
                      });
                    }
                  },
                  
                  // Disable days before today
                  enabledDayPredicate: (day) {
                    return !day.isBefore(_today);
                  },
                ),
              ),
              
              // Display selected dates - always show the container, even if empty
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedStartDate != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d, yyyy').format(_selectedStartDate!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (_selectedEndDate != null) ...[
                            const Icon(Icons.arrow_forward, color: Colors.black54),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'End Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM d, yyyy').format(_selectedEndDate!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Please select your travel dates",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
              
              const Spacer(), // Push everything up and the button down
              
              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_selectedStartDate != null) ? () {
                      int numberOfDays = _selectedEndDate!.difference(_selectedStartDate!).inDays;
                      int day = _selectedStartDate!.day;
                      int month = _selectedStartDate!.month;
                      int year = _selectedStartDate!.year;
                      provider.setDays(numberOfDays);
                      provider.setDay(day);
                      provider.setMonth(month);
                      provider.setYear(year);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BudgetSelectionScreen()),
                        );
                      // Navigate to next screen or handle date selection
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF), // Purple
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}