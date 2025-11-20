import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = "";
  String result = "";

  // Custom widget
  Widget NumberButton(
      String text, Color color,
      {IconData? icon, Color? iconColor,
        Color? textColor, Function()? onTap}
      ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: icon == null
                ? Text(
              text,
              style: TextStyle(
                  color: textColor ?? Colors.black, fontSize: 16
              ),
            )
                : Icon(
                icon, color: iconColor ?? Colors.black
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle input logic
  // void _handleButtonPress(String value) {
  //   setState(() {
  //     if (value == "AC") {
  //       input = "";
  //       result = "";
  //     } else if (value == "⌫") {
  //       if (input.isNotEmpty) {
  //         input = input.substring(0, input.length - 1);
  //       }
  //     } else if (value == "=") {
  //       try {
  //         result = _evaluate(input);
  //       } catch (e) {
  //         result = "Error";
  //       }
  //     } else {
  //       input += value;
  //     }
  //   });
  // }
  //
  // String _evaluate(String expression) {
  //   // Replace symbols
  //   expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
  //
  //   // Remove invalid trailing operators
  //   if (RegExp(r'[\+\-\*/]$').hasMatch(expression)) {
  //     expression = expression.substring(0, expression.length - 1);
  //   }
  //
  //   try {
  //     List<String> tokens = _tokenize(expression);
  //     double result = _calculate(tokens);
  //     return result.toString();
  //   } catch (e) {
  //     return "Error";
  //   }
  // }
  //
  //
  // List<String> _tokenize(String exp) {
  //   List<String> tokens = [];
  //   String numberBuffer = "";
  //
  //   for (int i = 0; i < exp.length; i++) {
  //     String char = exp[i];
  //
  //     if ('0123456789.'.contains(char)) {
  //       numberBuffer += char;
  //     } else if ('+-*/'.contains(char)) {
  //       if (numberBuffer.isNotEmpty) {
  //         tokens.add(numberBuffer);
  //         numberBuffer = "";
  //       }
  //       tokens.add(char);
  //     }
  //   }
  //
  //   if (numberBuffer.isNotEmpty) {
  //     tokens.add(numberBuffer);
  //   }
  //
  //   return tokens;
  // }
  //
  // double _calculate(List<String> tokens) {
  //   // First pass: *, /
  //   for (int i = 0; i < tokens.length; i++) {
  //     if (tokens[i] == '*' || tokens[i] == '/') {
  //       double left = double.parse(tokens[i - 1]);
  //       double right = double.parse(tokens[i + 1]);
  //       double temp = tokens[i] == '*' ? left * right : left / right;
  //
  //       tokens[i - 1] = temp.toString();
  //       tokens.removeAt(i); // operator
  //       tokens.removeAt(i); // right operand
  //       i--; // step back
  //     }
  //   }
  //
  //   // Second pass: +, -
  //   double result = double.parse(tokens[0]);
  //   for (int i = 1; i < tokens.length; i += 2) {
  //     String op = tokens[i];
  //     double num = double.parse(tokens[i + 1]);
  //
  //     if (op == '+') {
  //       result += num;
  //     } else if (op == '-') {
  //       result -= num;
  //     }
  //   }
  //
  //   return result;
  // }

  void handleButtonPress(String value) {
    setState(() {
      if (value == "AC") {
        input = "";
        result = "";
      } else if (value == "Backspace") {
        input = input.isNotEmpty
            ? input.substring(0, input.length - 1)
            : "";
      } else if (value == "=") {
        result = evaluate(input);
      } else {
        //19725
        input += value;
      }
    });
  }

  String evaluate(String exp) {
    try {

      exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
      if (RegExp(r'[+\-*/]$').hasMatch(exp)) {
        exp = exp.substring(0, exp.length - 1);
      }

      //exp = "789*25-96"
      List<String> tokens = [];
      String num = '';

      for (var c in exp.split('')) {
        //c="7"
        if ('0123456789.'.contains(c)) {
          num += c;
          //num = "25"

          //num = "789"
        } else if ('+-*/'.contains(c)) {
          //num = "25"
          if (num.isNotEmpty) tokens.add(num);
          //tokens = ["789","*","25","-"]
          tokens.add(c);
          //tokens = ["789","*"]
          num = '';
        }
      }

      if (num.isNotEmpty) tokens.add(num);
      //tokens = ["789","*","25","-","96"]

      // First pass: * /
      for (int i = 0; i < tokens.length; i++) {
        //i = 1
        if (tokens[i] == '*' || tokens[i] == '/') {
          double a = double.parse(tokens[i - 1]);
          // a = 789
          double b = double.parse(tokens[i + 1]);
          // b = 25
          double res = tokens[i] == '*' ? a * b : a / b;
          // res = 789 * 25
          // res = 8160
          tokens[i - 1] = res.toString();
          //tokens = ["8160","*","96","+","91"]
          tokens.removeAt(i);
          //tokens = ["8160","96","+","91"]
          tokens.removeAt(i);
          //tokens = ["8160","-","96"]
          i--;
        }
      }

      // Second pass: + -
      double total = double.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        double next = double.parse(tokens[i + 1]);
        //total = 8160
        //next = 96
        //i = 1
        total = tokens[i] == '+' ? total + next : total - next;
        //total = 19629
      }

      return total.toString();
    } catch (e) {
      print(e);
      return "Error";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      input,
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Column(
              children: [
                Row(
                  children: [
                    NumberButton("AC", Colors.white,
                        onTap: () => handleButtonPress("AC")),
                    NumberButton("%", Colors.white,
                        onTap: () => handleButtonPress("%")),
                    NumberButton("÷", Colors.white,
                        onTap: () => handleButtonPress("÷")),
                    NumberButton("", Colors.orange,
                        icon: Icons.backspace_outlined,
                        iconColor: Colors.white,
                        onTap: () => handleButtonPress("Backspace")),
                  ],
                ),
                Row(
                  children: [
                    NumberButton("7", Colors.white,
                        onTap: () => handleButtonPress("7")),
                    NumberButton("8", Colors.white,
                        onTap: () => handleButtonPress("8")),
                    NumberButton("9", Colors.white,
                        onTap: () => handleButtonPress("9")),
                    NumberButton("×", Colors.orange,
                        textColor: Colors.white,
                        onTap: () => handleButtonPress("×")),
                  ],
                ),
                Row(
                  children: [
                    NumberButton("4", Colors.white,
                        onTap: () => handleButtonPress("4")),
                    NumberButton("5", Colors.white,
                        onTap: () => handleButtonPress("5")),
                    NumberButton("6", Colors.white,
                        onTap: () => handleButtonPress("6")),
                    NumberButton("-", Colors.orange,
                        textColor: Colors.white,
                        onTap: () => handleButtonPress("-")),
                  ],
                ),
                Row(
                  children: [
                    NumberButton("1", Colors.white,
                        onTap: () => handleButtonPress("1")),
                    NumberButton("2", Colors.white,
                        onTap: () => handleButtonPress("2")),
                    NumberButton("3", Colors.white,
                        onTap: () => handleButtonPress("3")),
                    NumberButton("+", Colors.orange,
                        textColor: Colors.white,
                        onTap: () => handleButtonPress("+")),
                  ],
                ),
                Row(
                  children: [
                    NumberButton(".", Colors.white, onTap: () => handleButtonPress(".")),
                    NumberButton("0", Colors.white, onTap: () => handleButtonPress("0")),
                    NumberButton("÷", Colors.white, onTap: () => handleButtonPress("÷")),
                    NumberButton("=", Colors.green,
                        textColor: Colors.white, onTap: () => handleButtonPress("=")),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
