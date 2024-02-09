enum Breakpoints {
  mobileS(320),
  mobileM(375),
  mobileL(425),
  tablet(768),
  laptop(1024),
  laptopL(1440);

  const Breakpoints(this.value);

  final num value;
}

extension BreakpointsExtension on Breakpoints {
  num get size {
    switch (this) {
      case Breakpoints.mobileS:
        return Breakpoints.mobileS.value;
      case Breakpoints.mobileM:
        return Breakpoints.mobileM.value;
      case Breakpoints.mobileL:
        return Breakpoints.mobileL.value;
      case Breakpoints.tablet:
        return Breakpoints.tablet.value;
      case Breakpoints.laptop:
        return Breakpoints.laptop.value;
      case Breakpoints.laptopL:
        return Breakpoints.laptopL.value;
    }
  }
}
