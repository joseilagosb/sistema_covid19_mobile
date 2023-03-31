import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/classes/service.dart';

class FilterPlaces extends StatefulWidget {
  const FilterPlaces(
      {super.key,
      required this.onApplyButtonClick,
      required this.listParameters});
  final List<String> listParameters;
  final Function(List<int>) onApplyButtonClick;
  @override
  _FilterPlacesState createState() => _FilterPlacesState();
}

class _FilterPlacesState extends State<FilterPlaces> {
  List<int> _selectedTextList = [];
  final ScrollController _scrollController = ScrollController();

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];
    for (int i = 0; i < widget.listParameters.length; i++) {
      var selectedText = _selectedTextList.contains(i + 1);
      choices.add(
        ChoiceChip(
          selected: selectedText,
          backgroundColor:
              selectedText ? Colors.orangeAccent : Colors.orange[50],
          selectedColor: selectedText ? Colors.orangeAccent : Colors.orange[50],
          label: Text(
            widget.listParameters[i],
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 14.0,
                color: selectedText ? Colors.white : Colors.black),
          ),
          onSelected: (selected) {
            setState(() {
              selectedText
                  ? _selectedTextList.remove(i + 1)
                  : _selectedTextList.add(i + 1);
              print(_selectedTextList);
            });
          },
        ),
      );
    }
    choices.add(
      SizedBox(
        height: 20,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.orangeAccent[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_PADDING),
      ),
      elevation: 0.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(DIALOG_PADDING),
              child: Text(
                'Selecciona los parámetros que deseas ver en el mapa',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DIALOG_PADDING),
              child: Text('${_selectedTextList.length} items seleccionados',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16.0)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .4,
              padding: const EdgeInsets.only(
                  left: DIALOG_PADDING, right: DIALOG_PADDING),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Wrap(
                    children: _buildChoiceList(),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Text(
                      'Todos',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _selectedTextList = List.generate(
                              widget.listParameters.length, (i) => i + 1);
                        },
                      );
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Text(
                      'Ninguno',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedTextList.clear();
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MaterialColor(
                        0xFF9687,
                        Constants.COLOR_CODES,
                      )[50],
                      padding: const EdgeInsets.all(10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Aplicar',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontSize: 14.0, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      widget.onApplyButtonClick(_selectedTextList);
                      Navigator.pop(context, _selectedTextList);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
