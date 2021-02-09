import 'package:flutter/material.dart';

class SectionHeader extends StatefulWidget {
  final String sectionTitle;
  final int headerIndex;
  final ValueChanged<int> collapseHeaderCallBack;

  SectionHeader({Key key, this.sectionTitle, this.headerIndex, this.collapseHeaderCallBack}) : super(key: key);

  @override
  _SectionHeaderState createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool isExpanded = true;

  @override
  void initState(){
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(
        begin: isExpanded ? 0.25:0,
        end: isExpanded ? 0:0.25
    ).animate(_controller);

    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
              RotationTransition(
                turns: _animation,
                child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_sharp),
                    onPressed: () {
                      //TODO: figure out why first click doesn't adjust properly
                      setState(() {
                        _controller.forward(from: isExpanded ? 0.25:0);
                        isExpanded = !isExpanded;
                      });
                      widget.collapseHeaderCallBack(widget.headerIndex);
                    },
                ),
              )
            ]
        ),
      ),
    );
  }
}