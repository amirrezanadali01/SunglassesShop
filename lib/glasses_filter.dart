import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sunglassesshop/glasses_list_screen.dart';

class GlassesFilterScreen extends StatefulWidget {
  const GlassesFilterScreen({Key? key}) : super(key: key);

  @override
  State<GlassesFilterScreen> createState() => _GlassesFilterScreenState();
}

class _GlassesFilterScreenState extends State<GlassesFilterScreen> {
  late List<AnimatedTextKit> myText;

  @override
  void initState() {
    myText = [
      AnimatedTextKit(
          pause: const Duration(microseconds: 10),
          onFinished: () {
            setState(() {
              textQuestion = const Text(
                'So, What are you looking for?',
                key: Key("2"),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
              items = Row(key: const Key('2'), children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        textQuestion = const Text(
                          'And who are you shopping for?',
                          key: Key("3"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                        items = Row(key: const Key('3'), children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  myText.add(AnimatedTextKit(
                                      pause: const Duration(microseconds: 10),
                                      onFinished: () {
                                        setState(() {
                                          myText.add(AnimatedTextKit(
                                              onFinished: () {
                                                Navigator.of(context)
                                                    .push(newPageAnimation());
                                              },
                                              pause: const Duration(
                                                  milliseconds: 10),
                                              isRepeatingAnimation: false,
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                    "with round shape",
                                                    textStyle: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                    speed: const Duration(
                                                        milliseconds: 60)),
                                              ]));
                                        });
                                      },
                                      isRepeatingAnimation: false,
                                      animatedTexts: [
                                        TypewriterAnimatedText("Man",
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                            speed: const Duration(
                                                milliseconds: 60)),
                                      ]));

                                  items = Container();
                                });
                              },
                              child: const TemplateItems(
                                image: "assets/images/man.jpg",
                                text: "Man",
                              ),
                            ),
                          ),
                          const Expanded(
                            child: TemplateItems(
                              image: "assets/images/woman.jpg",
                              text: "Woman",
                            ),
                          ),
                        ]);

                        myText.add(AnimatedTextKit(
                            pause: const Duration(microseconds: 10),
                            isRepeatingAnimation: false,
                            onFinished: () {
                              setState(() {
                                myText.add(AnimatedTextKit(
                                    pause: const Duration(microseconds: 10),
                                    isRepeatingAnimation: false,
                                    animatedTexts: [
                                      TypewriterAnimatedText("for",
                                          textStyle: const TextStyle(
                                            fontSize: 15,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 60)),
                                    ]));
                              });
                            },
                            animatedTexts: [
                              TypewriterAnimatedText("Eyeglasses",
                                  textStyle: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  speed: const Duration(milliseconds: 60)),
                            ]));
                      });
                    },
                    child: const TemplateItems(
                      image: "assets/images/ch1.jpg",
                      text: "eyeglasses",
                    ),
                  ),
                ),
                const Expanded(
                    child: TemplateItems(
                  image: "assets/images/ch3.jpg",
                  text: "sunglasses",
                )),
              ]);
            });
          },
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText("I'm looking for",
                textStyle: const TextStyle(fontSize: 15),
                speed: const Duration(milliseconds: 60)),
          ])
    ];
    super.initState();
  }

  Widget textQuestion = Container();
  Widget items = Container(key: const Key('1'));

  bool flag = true;

  Route newPageAnimation() {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const GlassesListScreen();
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: animation
              .drive(Tween(begin: const Offset(0, 1), end: const Offset(0, 0))),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 900),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              )),
        ],
        leading: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Wrap(children: myText),
            const SizedBox(height: 50),
            AnimatedSwitcher(
              reverseDuration: const Duration(microseconds: 1),
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                          // -0.5
                          begin: const Offset(0, -1.30),
                          end: const Offset(0, 0))
                      .animate(animation),
                  child: FadeTransition(opacity: animation, child: child)),
              child: textQuestion,
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: items,
            ),
          ],
        ),
      ),
    );
  }
}

class TemplateItems extends StatelessWidget {
  const TemplateItems({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            clipBehavior: Clip.antiAlias,
            child: Image(
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                image: AssetImage(image))),
        const SizedBox(height: 10),
        const Text('Eyeglasses')
      ],
    );
  }
}
