final padiRDP = [
  [10, 219],
  [12, 147],
  [14, 98],
  [16, 72],
  [18, 56],
  [20, 45],
  [22, 37],
  [25, 29],
  [30, 20],
  [35, 14],
  [40, 9],
  [42, 8],
];

int ndlForDepth(double depth) {
  for (var i = 0; i < padiRDP.length; i++) {
    if (padiRDP[i][0] >= depth) {
      return padiRDP[i][1];
    }
  }
  return 0;
}
