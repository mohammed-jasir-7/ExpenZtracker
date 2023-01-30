class Onboard {
  final String image;
  final String title;
  final String content;

  Onboard({required this.image, required this.title, required this.content});
}

List<Onboard> contents = [
  Onboard(
      image: 'assets/images/pageOne.png',
      title: 'Say hi to your new \nfinance tracker',
      content:
          "You’re amazing for taking this first step\n towards getting better control over your\n money and Financial goals"),
  Onboard(
      image: 'assets/images/pageTwo.png',
      title: 'Control your Spending habits\n and start saving ',
      content:
          'ExpenZ tracker helps you control your\n spending, track your expenses, and ultimately\nsave more money'),
  Onboard(
      image: 'assets/images/pageThree.png',
      title: 'Together we’ll reach\nyour financial goals',
      content:
          'ExpenZ tracker will help you stay focused on\ntracking your spending habits and reach\nyour financial goals.'),
];
