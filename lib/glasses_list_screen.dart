import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

class GlassesListScreen extends StatefulWidget {
  const GlassesListScreen({Key? key}) : super(key: key);

  @override
  State<GlassesListScreen> createState() => _GlassesListScreenState();
}

class _GlassesListScreenState extends State<GlassesListScreen>
    with TickerProviderStateMixin {
  late AnimationController animationcontroller;
  late Animation<Offset> anim1;

  List<Map> items = [
    {
      'image': 'assets/images/th1.jpg',
      'title': 'Shooter',
      'text': 'Currectly one of the most iconic\nsunglass models in the world ',
    },
    {
      'image': 'assets/images/th2.jpg',
      'title': 'AVIATOR',
      'text': 'Currectly one of the most iconic\nsunglass models in the world',
    },
    {
      'image': 'assets/images/th3.jpg',
      'title': 'AVIATOR',
      'text': 'Currectly one of the most iconic\nsunglass models in the world',
    },
  ];

  PageController controllerPage = PageController(viewportFraction: 0.60);
  PageController controllerPage1 = PageController();
  int currentPage = 0;
  @override
  void initState() {
    animationcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    controllerPage.addListener(() {
      int pos = controllerPage.page!.round();

      if (currentPage != pos) {
        if (currentPage < pos) {
          controllerPage1.nextPage(
              duration: const Duration(microseconds: 1), curve: Curves.easeIn);
        } else {
          controllerPage1.previousPage(
              duration: const Duration(microseconds: 1), curve: Curves.easeIn);
        }

        setState(() {
          currentPage = pos;
        });
      }
    });

    anim1 = Tween<Offset>(begin: const Offset(0.8, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
            parent: animationcontroller,
            curve: const Interval(0.7, 1,
                curve: Curves.easeInOutSine))); //Curves.easeInOutSine

    animationcontroller.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationcontroller.dispose();
    controllerPage.dispose();
    controllerPage1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: controllerPage1,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Image(
              image: AssetImage(items[index]['image']),
              opacity: const AlwaysStoppedAnimation(1),
              fit: BoxFit.cover,
            );
          },
        ),
        Scaffold(
          bottomSheet: const SizedBox(
            width: double.infinity,
            height: 120,
            child: Card(
              margin: EdgeInsets.only(bottom: 60, left: 20, right: 20),
              color: Colors.white,
              child: Center(
                  child: Text(
                'Try Glasses',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SlideTransition(
            position: anim1,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 450,
                child: PageView.builder(
                    controller: controllerPage,
                    itemCount: items.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      // Active page
                      bool active = index == currentPage;
                      return _buildStoryPage(
                          active, items[index]['image'], items[index]['text']);
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_buildStoryPage(bool active, String image, String text) {
  final double top = active ? 50 : 90;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          child: FlipCard(
        front: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(top: top, bottom: 10, right: 30),
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
        ),
        back: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(top: top, bottom: 10, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: ModelViewer(
                  src: 'assets/images/uploads3d.glb',
                  autoRotate: true,
                  autoPlay: true,
                  touchAction: null,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(width: 5),
                      CircleAvatar(
                        backgroundColor: Colors.brown,
                      ),
                      SizedBox(width: 5),
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                      )
                    ],
                  )),
              const Expanded(
                  child: Text(
                '100% UV protection',
                style: TextStyle(fontSize: 17),
              )),
              const Expanded(
                  child: Text(
                '\$268',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
              const Expanded(
                  child: Card(
                margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                color: Colors.black,
                child: Center(
                  child: Text('Add to cart',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
              )),
            ],
          ),
        ),
      )),
      Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, left: 11),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          )),
      Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                    )),
              ],
            ),
          ))
    ],
  );
}
