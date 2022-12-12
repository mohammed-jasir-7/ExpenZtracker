import 'package:expenztracker/custom%20WIDGETS/custom_route.dart';
import 'package:expenztracker/screens/insight/insight_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_applications_sharp, size: 40),
          ),
          Tooltip(
            message: 'Insight',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context, CustomPageRoute(child: const InsightScreen()));
              },
              icon: Icon(
                Icons.insights,
                size: 40,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.schedule, size: 40),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.calculate_rounded, size: 40),
          ),
        ],
      ),
    );
  }
}
