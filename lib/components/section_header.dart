import 'package:flutter/material.dart';

class SectionHeader extends StatefulWidget {
  final String sectionTitle;

  SectionHeader({Key key, this.sectionTitle}) : super(key: key);

  @override
  _SectionHeaderState createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Row(
          children: [
            Text(
                widget.sectionTitle,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)
            ),
            //Stylized divider
            Expanded(
              child: Padding(
                padding:EdgeInsets.only(left: 10.0),
                child:Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color:Colors.black,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}