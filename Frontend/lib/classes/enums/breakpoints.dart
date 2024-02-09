enum Breakpoints {
  mobileS(320),
  mobileM(375),
  mobileL(425),
  tablet(768),
  laptop(1024),
  laptopL(1440);

  const Breakpoints(this.size);

  final num size;
}
