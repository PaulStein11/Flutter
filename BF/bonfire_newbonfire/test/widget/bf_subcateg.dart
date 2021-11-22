import 'package:flutter/material.dart';


Widget BF_SubCateg_Widget(
    {String data, IconData icon, Color color1, Color color2, @required bool isSelected = false}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color1, color2]),
      border: Border.all(color: Colors.white24),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color(0XFF333333),
                        borderRadius: BorderRadius.circular(100.0),
                        /*gradient: LinearGradient(colors: [color1, color2]),*/
                        /*image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/flame_icon1.png")),*/
                        //Theme.of(context).accentColor,
                      ),
                      child: Icon(
                        icon,
                        size: 35.0,
                        color: Color(0XFF333333),//Colors.white70,
                      ),
                    ),

                  ),
                ),
              ),
            ),
            Text(
              data,
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isSelected ? Icon(Icons.check_circle_outline, size: 40.0, color: Colors.green,) : Text ("")
            ],
          ),
        )
      ],
    )
  );
}
