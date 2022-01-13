import 'package:flutter/cupertino.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrinciaplState createState() => _PrinciaplState();
}

class _PrinciaplState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("hello Wold"),
      ),
    );
  }
}
