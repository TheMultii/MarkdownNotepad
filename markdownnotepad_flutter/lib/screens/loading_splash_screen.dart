import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingSplashScreen extends StatefulWidget {
  const LoadingSplashScreen({super.key});

  @override
  State<LoadingSplashScreen> createState() => _LoadingSplashScreenState();
}

class _LoadingSplashScreenState extends State<LoadingSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [InitSetupPageAnimation()],
          ),
        ),
      ),
    );
  }
}

class InitSetupPageAnimation extends StatelessWidget {
  const InitSetupPageAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(999999999),
            ),
          )
              .animate()
              .move(
                duration: 0.ms,
                end: const Offset(0, -100),
              )
              .scale(
                duration: 500.ms,
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
              )
              .fadeIn(
                duration: 100.ms,
              )
              .move(
                duration: 1000.ms,
                end: const Offset(0, 100),
                curve: Curves.bounceOut,
              )
              .then(delay: 300.ms)
              .fadeOut(
                duration: 100.ms,
              ),
          AnimatedContainer(
            duration: 100.ms,
            width: 30,
            height: 30,
            child: Image.asset("assets/icon.png"),
          )
              .animate()
              .then(
                delay: 1000.ms,
              )
              .fadeIn(
                duration: 100.ms,
              )
              .scale(
                duration: 750.ms,
                end: const Offset(5, 5),
                curve: Curves.bounceOut,
              )
              .then()
              .slideY(
                duration: 250.ms,
                end: -1,
                curve: Curves.linear,
              ),
          const Text(
            "Markdown Notepad",
            style: TextStyle(
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .move(
                duration: 0.ms,
                end: const Offset(0, 80),
              )
              .then(
                delay: 1900.ms,
              )
              .fadeIn(
                duration: 150.ms,
              )
        ],
      ),
    );
  }
}
