import 'package:final_project/widgets/news_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

bool isReload = false;

class _NewsScreenState extends State<NewsScreen> {
  Map<String, String> _countries = {
    "India": 'in',
    "USA": 'us',
    "UK": 'gb',
    "Australia": 'au',
    "Japan": 'jp',
    "Mexico": 'mx',
  };

  Map<String, String> _categories = {
    "Top Headlines": '',
    "Business": 'business',
    "Technology": 'technology',
    "Entertainment": 'entertainment',
    "Science": 'science',
    "Sports": 'sports',
    "Health": 'health',
  };

  String getCountryKey(val) {
    String res = '';
    _countries.forEach((key, value) {
      if (value == val) {
        res = key;
        return;
      }
    });
    return res;
  }

  String getCategoryKey(val) {
    String res = '';
    _categories.forEach((key, value) {
      if (value == val) {
        res = key;
        return;
      }
    });
    return res;
  }

  String _currentCountryValue = "in";
  String _currentCategoryValue = "";
  TextStyle textStyle = TextStyle(color: Colors.white);

  List<DropdownMenuItem<String>>? createDdItem(Map<String, String> map) {
    List<DropdownMenuItem<String>>? res = [];
    map.forEach((key, value) {
      var item = DropdownMenuItem<String>(
        value: value,
        child: Text(key),
      );
      res.add(item);
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.blueAccent[400],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            countryDropDown(constraints),
            categoryDropDown(constraints),
            SizedBox(height: 25),
            NewsLists(
                _currentCountryValue,
                _currentCategoryValue,
                constraints,
                getCategoryKey(_currentCategoryValue),
                getCountryKey(_currentCountryValue)),
          ],
        ),
      );
    });
  }

  Widget countryDropDown(BoxConstraints constraints) {
    return Container(
      color: Colors.blueAccent[400],
      // color: Colors.blueAccent[400],
      // height: constraints.maxHeight * 0.09,
      margin: EdgeInsets.only(
        top: constraints.maxHeight * 0.02,
        left: constraints.maxHeight * 0.02,
        right: constraints.maxHeight * 0.02,
      ),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                labelStyle: textStyle,
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(5.0))),
            isEmpty: _currentCountryValue == "in",
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Colors.blueAccent[400]),
                child: DropdownButton<String>(
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18),
                  value: _currentCountryValue,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentCountryValue = newValue.toString();
                      state.didChange(newValue);
                      isReload = true;
                    });
                  },
                  items: createDdItem(_countries),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoryDropDown(BoxConstraints constraints) {
    return Container(
      // color: Colors.blue[100],
      color: Colors.blueAccent[400],
      // height: constraints.maxHeight * 0.09,
      margin: EdgeInsets.only(
        top: constraints.maxHeight * 0.02,
        left: constraints.maxHeight * 0.02,
        right: constraints.maxHeight * 0.02,
      ),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                labelStyle: textStyle,
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                // hintText: "Top Headlines",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(5.0))),
            isEmpty: _currentCategoryValue == "",
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Colors.blueAccent[400]),
                child: DropdownButton<String>(
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18),
                  value: _currentCategoryValue,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentCategoryValue = newValue.toString();
                      state.didChange(newValue);
                      isReload = true;
                    });
                  },
                  items: createDdItem(_categories),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
