import 'package:expenztracker/Category/category_screen.dart';
import 'package:expenztracker/Database/model/model_transaction.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_text.dart';
import 'package:expenztracker/custom%20WIDGETS/custom_textInput.dart';
import 'package:expenztracker/screens/calculator/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//==================================================== calculator =====================================================
// screen calculator
class Calculator extends StatefulWidget {
  const Calculator(
      {super.key, required this.appTitle, required this.categoryType});
  //variables
  // receive apptitile and categorytype
  final String appTitle;
  final CategoryType categoryType;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // variable date
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(content: widget.appTitle.toUpperCase()),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF64ED08),
            Color.fromARGB(255, 0, 210, 108)
          ])),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: size.width,
                child: TextButton(
                    //==================  date button
                    onPressed: () {
                      dateShow(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.black,
                        ),
                        CustomText(
                          // date show here
                          content: date == null
                              ? 'Choose date'
                              : '${date!.day}'
                                  "-"
                                  '${date!.month}'
                                  "-"
                                  '${date!.year}',
                          colour: Colors.black,
                          weight: FontWeight.w600,
                        )
                      ],
                    )),
              ),
            ), //================navigate to calculator ==============
            CalculatorDisplay(
              date: date ?? DateTime.now(),
              appTitle: widget.appTitle,
              categoryType: widget.categoryType,
            )
          ],
        ),
      ),
    );
  }

//===== = for date picker
  Future<void> dateShow(BuildContext context) async {
    final DateTime? date1 = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999),
        lastDate: DateTime(2050));
    setState(() {
      date = date1;
    });
  }
}

//======================================================= here is calculator start ==================================
class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay(
      {super.key,
      required this.appTitle,
      required this.date,
      required this.categoryType});

  // variables
  //receive from calculator class
  final String appTitle;
  final DateTime date;
  final CategoryType categoryType;

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  // vaariables
  int? firstnum; //first  number
  int? secondNUm;
  String texttoDisply = '';
  String? res;
  String? operation;

  //=================  calculaor function ==============================

  void callBack(String text) {
    if (text == 'X' || text == '+' || text == '/' || text == '-') {
      firstnum = int.parse(texttoDisply);
      res = '';
      operation = text;
    } else if (text == '=') {
      secondNUm = int.parse(texttoDisply);
      if (operation == '-') {
        res = (firstnum! - secondNUm!).toString();
      }
      if (operation == '+') {
        if (firstnum != null && secondNUm != null) {
          res = (firstnum! + secondNUm!).toString();
        }
      }
      if (operation == 'X') {
        res = (firstnum! * secondNUm!).toString();
      }
      if (operation == '/') {
        res = (firstnum! / secondNUm!).toString();
      }
    } else if (text == '<') {
      res = texttoDisply.substring(0, texttoDisply.length - 1);
    } else {
      if (res != null) {
        if (res!.length <= 9) {
          res = texttoDisply + text;
        }
      } else {
        res = texttoDisply + text;
      }
    }
    setState(() {
      if (res != null) {
        texttoDisply = res!;
      }
    });
  }
  //===================== calculator function end here

  final note = TextEditingController(); // note textfield
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        //================================  calculator disply ========================
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green,
          ),
          width: size.width / 1.1,
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                content: texttoDisply,
                size: 30,
                colour: Colors.white,
              ),
              IconButton(
                  // backspace button
                  style: const ButtonStyle(),
                  onPressed: () {
                    callBack("<");
                  },
                  icon: const Icon(
                    Icons.backspace_rounded,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        //============================ calculator disply end==================
        //============= note section =======================================
        SizedBox(
          width: 300,
          height: 80,
          child: CustomTextfiled(
              controller: note,
              hint: 'note',
              icon: Icons.edit,
              limit: [LengthLimitingTextInputFormatter(50)]),
        ),
        //====================================================================
        //========================== calculator button start here =========================
        // working
        // custom wiget that recieve text and a function  of wich icon press
        // clicking time text pass into that funtion (callback)
        //so we can sense which button is pressed
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CalculatorButton(
              text: "1",
              callBack: callBack, //function receive value from onclik
            ),
            CalculatorButton(
              text: "2",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "3",
              callBack: callBack,
            ),
            CalculatorButton(
              widthBorder: 5,
              text: "+",
              callBack: callBack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CalculatorButton(
              text: "4",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "5",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "6",
              callBack: callBack,
            ),
            CalculatorButton(
              widthBorder: 5,
              text: "-",
              callBack: callBack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CalculatorButton(
              text: "7",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "8",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "9",
              callBack: callBack,
            ),
            CalculatorButton(
              widthBorder: 5,
              text: "X",
              callBack: callBack,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CalculatorButton(
              text: ".",
              callBack: callBack,
            ),
            CalculatorButton(
              text: "0",
              callBack: callBack,
            ),
            CalculatorButton(
              widthBorder: 5,
              text: "/",
              callBack: callBack,
            ),
            CalculatorButton(
              widthBorder: 5,
              text: "=",
              callBack: callBack,
            ),
          ],
        ),
        //=========================================================================================
        //========================================= chooose category button ===================================
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            width: 330,
            height: 70,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0XFF2CCD39), width: 5)),
                onPressed: () {
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          child: CategoryScreen(
                        //===================          navigate to category selection screeen
                        amount: double.parse(texttoDisply),
                        categoryType: widget.categoryType,
                        date: widget.date,
                        note: note.text,
                        appTitle: widget.appTitle.toUpperCase(),
                      )));
                },
                child: CustomText(
                  content: "Choose Category",
                  colour: Colors.black,
                  size: 28,
                  weight: FontWeight.w600,
                )),
          ),
        )
      ],
    );
  }
}
