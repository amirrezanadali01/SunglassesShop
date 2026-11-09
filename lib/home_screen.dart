import 'package:flutter/material.dart';
import 'package:sunglassesshop/glasses_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// The sheet's downward offset (in dp) required to reveal the buttons.
  static const double _maxCollapse = 30;

  /// Animation for the circles rising from behind the sheet.
  late final AnimationController _popController;

  /// Additional slight movement of the circles after the sheet is released.
  late final AnimationController _nudgeController;

  double _collapse = 0;
  Duration _sheetDuration = Duration.zero;
  bool _actionsVisible = false;
  bool _isLight = true;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _nudgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _popController.dispose();
    _nudgeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Gesture handling
  // ---------------------------------------------------------------------------

  void _onPanStart(DragStartDetails _) {
    setState(() => _sheetDuration = Duration.zero);
    if (_actionsVisible) _hideActions();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _collapse =
          (_collapse + details.delta.dy).clamp(0.0, _maxCollapse).toDouble();
    });

    if (!_actionsVisible && _collapse >= _maxCollapse) {
      _showActions();
    }
  }

  void _releaseSheet() {
    if (_actionsVisible) _nudgeController.forward();
    setState(() {
      _sheetDuration = const Duration(milliseconds: 400);
      _collapse = 0;
    });
  }

  void _showActions() {
    setState(() {
      _actionsVisible = true;
      _isLight = false;
    });
    _popController.forward();
  }

  void _hideActions() {
    setState(() => _actionsVisible = false);
    _nudgeController.reverse();
    _popController.reverse();
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final iconColor = _isLight ? Colors.black : Colors.white;

    // همه‌ی اندازه‌ها از روی اندازه‌ی صفحه حساب می‌شوند.
    final available = media.size.height - media.padding.top - kToolbarHeight;
    final sheetMaxHeight =
        (available * 0.6).clamp(300.0, 520.0).toDouble() + media.padding.bottom;
    final sheetHeight = sheetMaxHeight - _collapse;
    final bubbleSize = (media.size.width * 0.13).clamp(44.0, 60.0).toDouble();

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Image.asset(
            _isLight
                ? 'assets/images/BackLight.jpg'
                : 'assets/images/BackDark.jpg',
            key: ValueKey(_isLight),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: null, // TODO: open drawer
              icon: Icon(Icons.menu_rounded, color: iconColor),
            ),
            actions: [
              IconButton(
                onPressed: null, // TODO: search
                icon: Icon(Icons.search, color: iconColor),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GlassesFilterScreen()),
                ),
                icon: Icon(Icons.shopping_bag_outlined, color: iconColor),
              ),
            ],
          ),
          bottomSheet: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: bubbleSize + 24,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ActionBubble(
                              icon: Icons.settings_outlined,
                              size: bubbleSize,
                              popInterval: const Interval(0, 0.7,
                                  curve: Curves.elasticOut),
                              pop: _popController,
                              nudge: _nudgeController,
                            ),
                            SizedBox(width: bubbleSize * 0.35),
                            _ActionBubble(
                              icon: Icons.favorite_border_outlined,
                              size: bubbleSize,
                              popInterval: const Interval(0.2, 0.8,
                                  curve: Curves.elasticOut),
                              pop: _popController,
                              nudge: _nudgeController,
                            ),
                            SizedBox(width: bubbleSize * 0.35),
                            _ActionBubble(
                              icon: Icons.assistant_photo_outlined,
                              size: bubbleSize,
                              popInterval: const Interval(0.1, 0.7,
                                  curve: Curves.elasticOut),
                              pop: _popController,
                              nudge: _nudgeController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: (_) => _releaseSheet(),
                    onPanCancel: _releaseSheet,
                    child: AnimatedContainer(
                      duration: _sheetDuration,
                      width: double.infinity,
                      height: sheetHeight,
                      padding: EdgeInsets.fromLTRB(
                        12,
                        24,
                        12,
                        12 + media.padding.bottom,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: const _SheetContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Floating round buttons
// =============================================================================

class _ActionBubble extends StatelessWidget {
  const _ActionBubble({
    required this.icon,
    required this.size,
    required this.popInterval,
    required this.pop,
    required this.nudge,
  });

  final IconData icon;
  final double size;
  final Interval popInterval;
  final Animation<double> pop;
  final Animation<double> nudge;

  @override
  Widget build(BuildContext context) {
    final hiddenDy = size + 16;

    return AnimatedBuilder(
      animation: Listenable.merge([pop, nudge]),
      builder: (context, child) {
        final p = popInterval.transform(pop.value);
        final dy = hiddenDy * (1 - p) - size * 0.2 * nudge.value;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: SizedBox.square(
        dimension: size,
        child: ElevatedButton(
          onPressed: () {}, // TODO
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
          ),
          child: Icon(icon, color: Colors.black, size: size * 0.45),
        ),
      ),
    );
  }
}

// =============================================================================
// Sheet content
// =============================================================================

class _SheetContent extends StatelessWidget {
  const _SheetContent();

  static const _newCollection = [
    GlassesItem(
      image: 'assets/images/sun3.jpg',
      name: 'Aviater Classic',
      price: 188,
      colors: 4,
    ),
    GlassesItem(
      image: 'assets/images/sun2.jpg',
      name: 'Flash lenses',
      price: 228,
      colors: 8,
    ),
    GlassesItem(
      image: 'assets/images/sun3.jpg',
      name: 'Caript Classic',
      price: 21,
      colors: 2,
    ),
  ];

  static const _bestSelling = [
    'assets/images/wom2.jpeg',
    'assets/images/wom1.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle('New Collection'),
        const SizedBox(height: 16),
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in _newCollection)
                Expanded(child: GlassesCard(item: item)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SectionTitle('Best Selling', dividerFirst: true),
        const SizedBox(height: 16),
        Expanded(
          flex: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final path in _bestSelling)
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.dividerFirst = false});

  final String title;
  final bool dividerFirst;

  @override
  Widget build(BuildContext context) {
    const divider = Expanded(child: Divider(color: Colors.black26));
    final text = Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );

    return Row(
      children: dividerFirst
          ? [divider, const SizedBox(width: 5), text]
          : [text, const SizedBox(width: 5), divider],
    );
  }
}

// =============================================================================
// Product model + card
// =============================================================================

class GlassesItem {
  const GlassesItem({
    required this.image,
    required this.name,
    required this.price,
    required this.colors,
  });

  final String image;
  final String name;
  final double price;
  final int colors;
}

class GlassesCard extends StatelessWidget {
  const GlassesCard({required this.item, super.key});

  final GlassesItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Image.asset(item.image, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text('${item.colors} Colours',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
