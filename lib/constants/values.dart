import 'package:flutter/material.dart';

class Values {
  static const String backendUri = "http://10.0.2.2:3000";
  static const List<String> daysOfWeek = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  static const List<String> hoursOfDay = [
    "0:00 a.m.",
    "1:00 a.m.",
    "2:00 a.m.",
    "3:00 a.m.",
    "4:00 a.m.",
    "5:00 a.m.",
    "6:00 a.m.",
    "7:00 a.m.",
    "8:00 a.m.",
    "9:00 a.m.",
    "10:00 a.m.",
    "11:00 a.m.",
    "12:00 p.m.",
    "1:00 p.m.",
    "2:00 p.m.",
    "3:00 p.m.",
    "4:00 p.m.",
    "5:00 p.m.",
    "6:00 p.m.",
    "7:00 p.m.",
    "8:00 p.m.",
    "9:00 p.m.",
    "10:00 p.m.",
    "11:00 p.m.",
  ];
  static const periodsOfDay = ["Mañana", "Tarde", "Noche"];
  static const dayTypes = ["Días laborales", "Fin de semana"];
  static const Map<int, Color> colorCodes = {
    50: Color.fromARGB(255, 255, 150, 30),
    100: Color.fromARGB(255, 255, 160, 55),
    200: Color.fromARGB(255, 255, 170, 80),
    300: Color.fromARGB(255, 255, 180, 105),
    400: Color.fromARGB(255, 255, 190, 130),
    500: Color.fromARGB(255, 255, 200, 155),
    600: Color.fromARGB(255, 255, 210, 180),
    700: Color.fromARGB(255, 255, 220, 205),
    800: Color.fromARGB(255, 255, 230, 220),
    900: Color.fromARGB(255, 255, 240, 235),
  };
}
