import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String sectionTitle;

  SectionHeader({Key key, this.sectionTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 50.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Row(
            children: [
              Text(
                  sectionTitle,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)
              ),
              //Stylized divider
              Expanded(
                child: Column(
                  children: [
                    Padding(
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
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}