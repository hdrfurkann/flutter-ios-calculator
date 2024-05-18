import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:ios_calculator_iphone/models/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = '0';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //title: Text("iPhone Calculator", style: TextStyle(fontFamily: 'SF-UI-Display-Regular',)),
        actions: [
          //IconButton(
          //color: Colors.grey,
          //onPressed: () {
          //StoreRedirect.redirect(
          //androidAppId: "com.ios_calculator_pro",
          //);
          //},
          //icon: Icon(Icons.lock_open)
          //),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onHorizontalDragEnd: (details) => {_dragToDelete()},
              child: Text(
                _formatResult(result),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: result.length > 5 ? 60 : 100,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _buildButtonsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  void _dragToDelete() {
    setState(() {
      if (result.length > 1) {
        result = result.substring(0, result.length - 1);
        currentNumber = result;
      } else {
        result = '0';
        currentNumber = '';
      }
    });
  }

  String previousNumber = '';
  String currentNumber = '';
  String selectedOperation = '';

  void _onButtonPressed(String buttonText) {
    setState(
      () {
        switch (buttonText) {
          case '÷':
          case 'x':
          case '-':
          case '+':
            if (previousNumber != '') {
              _calculateResult();
            } else {
              previousNumber = currentNumber;
            }
            currentNumber = '';
            selectedOperation = buttonText;
            break;
          case '+/-':
            currentNumber = convertStringToDouble(currentNumber) < 0
                ? currentNumber.replaceAll('-', '')
                : "-$currentNumber";
            result = currentNumber;
            break;
          case '%':
            currentNumber =
                (convertStringToDouble(currentNumber) / 100).toString();
            result = currentNumber;
            break;
          case '=':
            _calculateResult();
            previousNumber = '';
            selectedOperation = '';
            break;
          case 'AC':
            _resetCalculator();
            break;
          default:
            currentNumber = currentNumber + buttonText;
            result = currentNumber;
        }
      },
    );
  }

  void _calculateResult() {
    double _previousNumber = convertStringToDouble(previousNumber);
    double _currentNumber = convertStringToDouble(currentNumber);

    switch (selectedOperation) {
      case '÷':
        _previousNumber = _previousNumber / _currentNumber;
        break;
      case 'x':
        _previousNumber = _previousNumber * _currentNumber;
        break;
      case '-':
        _previousNumber = _previousNumber - _currentNumber;
        break;
      case '+':
        _previousNumber = _previousNumber + _currentNumber;
        break;
      default:
        break;
    }

    currentNumber =
        (_previousNumber % 1 == 0 ? _previousNumber.toInt() : _previousNumber)
            .toString();
    result = currentNumber;
  }

  void _resetCalculator() {
    result = '0';
    previousNumber = '';
    currentNumber = '';
    selectedOperation = '';
  }

  double convertStringToDouble(String number) {
    return double.tryParse(number) ?? 0;
  }

  String _formatResult(String number) {
    var formatter = NumberFormat("###,###.##", "en_US");
    return formatter.format(convertStringToDouble(number));
  }

  Widget _buildButtonsGrid() {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.zero,
      crossAxisCount: 4,
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        final button = buttons[index];
        return MaterialButton(
          padding: button.value == '0'
              ? EdgeInsets.only(right: 100)
              : EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
          ),
          color: (button.value == selectedOperation && currentNumber == '')
              ? Color.fromARGB(255, 255, 255, 255)
              : button.bgColor,
          onPressed: () {
            _onButtonPressed(button.value);
          },
          child: Text(
            button.value,
            style: TextStyle(
                color:
                    (button.value == selectedOperation && currentNumber == '')
                        ? button.bgColor
                        : button.fgColor,
                fontFamily: 'SF-UI-Display-Regular',
                fontSize: 35),
          ),
        );
      },
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      staggeredTileBuilder: (index) =>
          StaggeredTile.count(buttons[index].value == '0' ? 2 : 1, 1),
    );
  }
}
