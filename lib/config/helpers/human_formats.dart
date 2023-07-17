
//clase para formatear numeros instalamos el paquete --> flutter pub add intl

import 'package:intl/intl.dart';

class HumanFormats {

  //recibimos por parametro el numero a formatear y el numero de decimales que queremos
  //por defecto es 0 sin decimales si no viene por parametros el numero de decimales
  static String number( double number, [ int decimals = 0] ) {

    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);

    return formattedNumber;
  }
}