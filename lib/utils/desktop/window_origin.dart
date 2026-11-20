bool isWindowOriginInWorkArea({
  required double dx,
  required double dy,
  required double left,
  required double top,
  required double width,
  required double height,
  double margin = 30,
}) {
  return dx >= left &&
      dy >= top &&
      dx < left + width - margin &&
      dy < top + height - margin;
}
