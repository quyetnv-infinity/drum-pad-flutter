class FontResponsive {
  static double responsiveFontSize(double screenWidth, double size){
    return size * screenWidth / 375;
  }
}