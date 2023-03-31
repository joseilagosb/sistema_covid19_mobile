import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/widgets/send_feedback/question.dart';

class SendFeedbackInputPage extends StatefulWidget {
  final int placeId;
  final String placeName;
  final List<Indicator> indicators;

  const SendFeedbackInputPage(
      {super.key,
      required this.placeId,
      required this.placeName,
      required this.indicators});

  @override
  _SendFeedbackInputPageState createState() => _SendFeedbackInputPageState();
}

class _SendFeedbackInputPageState extends State<SendFeedbackInputPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late int numberOfQuestions;
  late List<dynamic> userInput;

  int currentQuestionNo = 1;
  String? option;

  List<int> questionTypes = [];

  PageController pageController = PageController();

  @override
  void initState() {
    numberOfQuestions = widget.indicators.length;

    userInput = List<dynamic>.filled(numberOfQuestions, "");

    for (int i = 0; i < numberOfQuestions; i++) {
      if (widget.indicators[i].getType() == 0) {
        questionTypes.add(Constants.USERINPUT_RATING);
      } else if (widget.indicators[i].getType() == 1) {
        questionTypes.add(Constants.USERINPUT_NUMERIC);
      }
    }

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Deseas salir de la encuesta?'),
            content: const Text('Tu progreso se perderá.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.placeName,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: Tooltip(
            message: "Salir de la encuesta",
            child: IconButton(
              splashColor: Colors.grey,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30.0),
              SizedBox(
                height: 10.0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(numberOfQuestions, (int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: index < currentQuestionNo
                              ? Colors.orangeAccent
                              : Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2.0)),
                        ),
                        height: 10.0,
                        width: (MediaQuery.of(context).size.width - 40.0) /
                            numberOfQuestions,
                        margin: EdgeInsets.only(left: index == 0 ? 0.0 : 5.0),
                      );
                    })),
              ),
              const SizedBox(height: 34.0),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) => {},
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    numberOfQuestions,
                    (index) => Question(
                      questionNo: index + 1,
                      initialValue: userInput[index],
                      questionString: widget.indicators[index].name,
                      questionType: questionTypes[index],
                      questionHint: widget.indicators[index].description,
                      onChangeInput: (input) {
                        userInput[index] = input;
                      },
                    ),
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  currentQuestionNo > 1
                      ? SizedBox(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentQuestionNo -= 1;
                                pageController
                                    .jumpToPage(currentQuestionNo - 1);
                                userInput[currentQuestionNo] = null;
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Anterior',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.orangeAccent),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  const Spacer(),
                  SizedBox(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentQuestionNo < numberOfQuestions) {
                            if (userInput[currentQuestionNo - 1] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ingrese una opción antes de seguir con la siguiente pregunta',
                                  ),
                                ),
                              );
                              // _scaffoldKey.currentState.showSnackBar(SnackBar(
                              //   content: Text(
                              //       'Ingrese una opción antes de seguir con la siguiente pregunta'),
                              // ));
                            } else {
                              currentQuestionNo += 1;
                              pageController.jumpToPage(currentQuestionNo - 1);
                            }
                          } else {
                            print('encuesta terminada');
                          }
                        });
                      },
                      child: Center(
                        child: Text(
                          currentQuestionNo < numberOfQuestions
                              ? 'Siguiente'
                              : 'Finalizar',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
