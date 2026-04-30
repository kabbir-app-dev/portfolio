import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kabirul Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _offerKey = GlobalKey();
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openWhatsApp() async {
    final String phone = "919330081292"; // with country code, no + or spaces
    final String message = "Hello, I would like to connect with you";

    final Uri url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _openWhatsApp,
        child: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color(0xFF0A0E21),
              Color(0xFF1A1A3E),
              Color(0xFF0F1228),
              Color(0xFF16213E),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  double opacity =
                      (_scrollController.hasClients &&
                          _scrollController.offset > 50)
                      ? 0.95
                      : 0.0;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A0E21).withOpacity(opacity),
                          const Color(0xFF1A1A3E).withOpacity(opacity),
                        ],
                      ),
                      boxShadow: opacity > 0
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                              ),
                            ]
                          : null,
                    ),
                  );
                },
              ),
              title: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, -20 * (1 - value)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _scrollToSection(_homeKey),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF3F3D9E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'K I',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildNavItem('Home', _homeKey),
                                const SizedBox(width: 35),
                                _buildNavItem('Projects', _projectsKey),
                                const SizedBox(width: 35),
                                _buildNavItem('What I Offer', _offerKey),
                                const SizedBox(width: 35),
                                _buildNavItem('Skills', _skillsKey),
                                const SizedBox(width: 35),
                                _buildNavItem('Contact', _contactKey),
                              ],
                            ),
                          ),
                          _buildHireMeButton(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(key: _homeKey, child: const HomeSection()),
                  const SizedBox(height: 80),
                  Container(key: _projectsKey, child: const ProjectsSection()),
                  const SizedBox(height: 80),
                  Container(key: _offerKey, child: const OfferSection()),
                  const SizedBox(height: 80),
                  Container(key: _skillsKey, child: const SkillsSection()),
                  const SizedBox(height: 80),
                  Container(key: _contactKey, child: const ContactSection()),
                  const SizedBox(height: 60),
                  _buildFooter(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, GlobalKey key) {
    return InkWell(
      onTap: () => _scrollToSection(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildHireMeButton() {
    return GestureDetector(
      onTap: () => _scrollToSection(_contactKey),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF6C63FF,
                  ).withOpacity(0.3 + _glowController.value * 0.3),
                  blurRadius: 15 + _glowController.value * 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'Hire Me',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: Column(
        children: [
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 30),
          const Text(
            '© 2024 Flutter Developer Portfolio',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
    );
  }
}

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  void _scrollToSection(BuildContext context, GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectsKey =
        (context
            .findAncestorStateOfType<_PortfolioHomePageState>()
            ?._projectsKey) ??
        GlobalKey();
    final contactKey =
        (context
            .findAncestorStateOfType<_PortfolioHomePageState>()
            ?._contactKey) ??
        GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isLarge = constraints.maxWidth > 900;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLarge) ...[
                Expanded(
                  child: _buildLeftContent(context, projectsKey, contactKey),
                ),
                const SizedBox(width: 60),
                const Expanded(child: BouncingChipsContainer()),
              ] else ...[
                Column(
                  children: [
                    _buildLeftContent(context, projectsKey, contactKey),
                    const SizedBox(height: 60),
                    const SizedBox(
                      height: 500,
                      child: BouncingChipsContainer(),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftContent(
    BuildContext context,
    GlobalKey projectsKey,
    GlobalKey contactKey,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-50 * (1 - value), 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Container(height: 10, width: 300, color: Colors.red),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Container(
                          //   width: 8,
                          //   height: 8,
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFF6C63FF),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          // ),
                          const SizedBox(width: 8),
                          const Text(
                            '''Hi,
Hope you are doing great!
I'm Kabirul Islam, an Experienced Flutter Developer.''',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-30 * (1 - value), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crafting',
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
                      ).createShader(bounds),
                      child: Text(
                        'Beautiful Digital',
                        style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    Text(
                      'Experiences',
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-20 * (1 - value), 0),
                child: const Text(
                  'I build premium, high-performance mobile and web applications\n'
                  'with stunning UI/UX, smooth animations, and clean architecture.\n'
                  '4+ years of experience delivering production-ready apps.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-10 * (1 - value), 0),
                child: Row(
                  children: [
                    _buildGradientButton(
                      'View My Work',
                      Icons.arrow_forward,
                      () {
                        Scrollable.ensureVisible(
                          projectsKey.currentContext!,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildOutlineButton('Contact Me', Icons.email_outlined, () {
                      Scrollable.ensureVisible(
                        contactKey.currentContext!,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    [
                          'Flutter',
                          'Dart',
                          'Firebase',
                          'REST API',
                          'GetX',
                          'Provider',
                        ]
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGradientButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF6C63FF), width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: const Color(0xFF6C63FF), size: 16),
          ],
        ),
      ),
    );
  }
}

// Bouncing Chips Physics Widget
class BouncingChipsContainer extends StatefulWidget {
  const BouncingChipsContainer({super.key});

  @override
  State<BouncingChipsContainer> createState() => _BouncingChipsContainerState();
}

class _BouncingChipsContainerState extends State<BouncingChipsContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PhysicsSimulation _simulation;
  final Random _random = Random();

  static const int numChips = 12;
  static const double chipRadius = 28.0;

  @override
  void initState() {
    super.initState();
    _simulation = PhysicsSimulation(
      numChips: numChips,
      radius: chipRadius,
      containerWidth: 500,
      containerHeight: 450,
    );

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 16),
        )..addListener(() {
          _simulation.update(0.016);
          setState(() {});
        });

    _resetPositions();
    _animationController.repeat();
  }

  void _resetPositions() {
    _simulation.reset(
      containerWidth: 500,
      containerHeight: 450,
      radius: chipRadius,
      random: _random,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = 500.0;
    final containerHeight = 450.0;

    _simulation.updateBounds(
      chipRadius + 8,
      chipRadius + 8,
      containerWidth - chipRadius - 8,
      containerHeight - chipRadius - 8,
    );

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F3460).withOpacity(0.3),
            const Color(0xFF1A1A3E).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(46),
        child: Stack(
          children: [
            // Background glow effect
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.05),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
            // Bouncing chips
            for (int i = 0; i < _simulation.chips.length; i++)
              _buildChip(_simulation.chips[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(ChipPhysics chip, int index) {
    return Positioned(
      left: chip.position.dx - chipRadius,
      top: chip.position.dy - chipRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 16),
        width: chipRadius * 2,
        height: chipRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: chip.colors,
            center: Alignment.topLeft,
            radius: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: chip.shadowColor.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(chip.icon, color: Colors.white, size: 24),
              const SizedBox(height: 2),
              Text(
                chip.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipPhysics {
  final int id;
  Offset position;
  Offset velocity;
  double mass;
  final List<Color> colors;
  final Color shadowColor;
  final IconData icon;
  final String text;

  ChipPhysics({
    required this.id,
    required this.position,
    required this.velocity,
    required this.mass,
    required this.colors,
    required this.shadowColor,
    required this.icon,
    required this.text,
  });
}

class PhysicsSimulation {
  List<ChipPhysics> chips;
  final double radius;
  final double restitution = 0.88;
  final double friction = 0.992;

  double leftBound = 0;
  double topBound = 0;
  double rightBound = 0;
  double bottomBound = 0;

  final List<Map<String, dynamic>> chipData = [
    {
      'icon': FontAwesomeIcons.flutter,
      'text': 'Flutter',
      'colors': [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
      'shadow': const Color(0xFF42A5F5),
    },

    {
      'icon': Icons.phone_android,
      'text': 'Mobile',
      'colors': [const Color(0xFFD4E157), const Color(0xFFD4E157)],
      'shadow': const Color(0xFFD4E157),
    },

    {
      'icon': Icons.web,
      'text': 'Web',
      'colors': [const Color(0xFF66BB6A), const Color(0xFF66BB6A)],
      'shadow': const Color(0xFF66BB6A),
    },
    // ios
    {
      'icon': FontAwesomeIcons.apple,
      'text': 'iOS',
      'colors': [const Color(0xFF26A69A), const Color(0xFF26A69A)],
      'shadow': const Color(0xFF26A69A),
    },

    // payu
    {
      'icon': Icons.payment,
      'text': 'Payment',
      'colors': [const Color(0xFFFF7043), const Color(0xFFFF7043)],
      'shadow': const Color(0xFFFF7043),
    },
    //notification
    {
      'icon': Icons.notifications,
      'text': 'Alert',
      'colors': [const Color(0xFF5C6BC0), const Color(0xFF5C6BC0)],
      'shadow': const Color(0xFF5C6BC0),
    },
    // chat
    {
      'icon': Icons.chat,
      'text': 'Chat',
      'colors': [const Color(0xFFAB47BC), const Color(0xFFAB47BC)],
      'shadow': const Color(0xFFAB47BC),
    },
    // video
    {
      'icon': Icons.videocam,
      'text': 'Video',
      'colors': [const Color(0xFF9CCC65), const Color(0xFF9CCC65)],
      'shadow': const Color(0xFF9CCC65),
    },
    // location
    {
      'icon': Icons.location_on,
      'text': 'Location',
      'colors': [const Color(0xFFFFA726), const Color(0xFFFFA726)],
      'shadow': const Color(0xFFFFA726),
    },

    // socket
    {
      'icon': FontAwesomeIcons.connectdevelop,
      'text': 'Socket',
      'colors': [const Color(0xFFFF8A65), const Color(0xFFFF8A65)],
      'shadow': const Color(0xFFFF8A65),
    },

    // security
    {
      'icon': Icons.security,
      'text': 'Security',
      'colors': [const Color(0xFFA1887F), const Color(0xFFA1887F)],
      'shadow': const Color(0xFFA1887F),
    },
  ];

  PhysicsSimulation({
    required int numChips,
    required this.radius,
    required double containerWidth,
    required double containerHeight,
  }) : chips = [] {
    for (int i = 0; i < numChips; i++) {
      final data = chipData[i % chipData.length];
      chips.add(
        ChipPhysics(
          id: i,
          position: Offset.zero,
          velocity: Offset.zero,
          mass: 1.0 + i * 0.1,
          colors: data['colors'],
          shadowColor: data['shadow'],
          icon: data['icon'],
          text: data['text'],
        ),
      );
    }
  }

  void reset({
    required double containerWidth,
    required double containerHeight,
    required double radius,
    required Random random,
  }) {
    final margin = radius + 8;
    final maxX = containerWidth - margin;
    final maxY = containerHeight - margin;
    final minX = margin;
    final minY = margin;

    for (var chip in chips) {
      bool overlapping;
      int attempts = 0;

      do {
        overlapping = false;
        chip.position = Offset(
          minX + random.nextDouble() * (maxX - minX),
          minY + random.nextDouble() * (maxY - minY),
        );
        chip.velocity = Offset(
          (random.nextDouble() - 0.5) * 400,
          (random.nextDouble() - 0.5) * 400,
        );

        for (var other in chips) {
          if (other != chip) {
            final dx = chip.position.dx - other.position.dx;
            final dy = chip.position.dy - other.position.dy;
            final dist = sqrt(dx * dx + dy * dy);
            if (dist < radius * 2) {
              overlapping = true;
              attempts++;
              break;
            }
          }
        }

        if (attempts > 100) break;
      } while (overlapping);
    }
  }

  void update(double dt) {
    if (dt > 0.033) dt = 0.033;

    for (var chip in chips) {
      chip.velocity = Offset(
        chip.velocity.dx * friction,
        chip.velocity.dy * friction,
      );
    }

    for (var chip in chips) {
      chip.position = Offset(
        chip.position.dx + chip.velocity.dx * dt,
        chip.position.dy + chip.velocity.dy * dt,
      );
    }

    for (int i = 0; i < chips.length; i++) {
      for (int j = i + 1; j < chips.length; j++) {
        _handleChipCollision(chips[i], chips[j]);
      }
    }

    for (var chip in chips) {
      _handleWallCollision(chip);
    }
  }

  void _handleChipCollision(ChipPhysics a, ChipPhysics b) {
    final dx = a.position.dx - b.position.dx;
    final dy = a.position.dy - b.position.dy;
    final dist = sqrt(dx * dx + dy * dy);
    final minDist = radius * 2;

    if (dist < minDist) {
      final overlap = minDist - dist;
      final angle = atan2(dy, dx);
      final correctionX = cos(angle) * (overlap / 2);
      final correctionY = sin(angle) * (overlap / 2);

      a.position = Offset(
        a.position.dx + correctionX,
        a.position.dy + correctionY,
      );
      b.position = Offset(
        b.position.dx - correctionX,
        b.position.dy - correctionY,
      );

      final relativeVelocityX = a.velocity.dx - b.velocity.dx;
      final relativeVelocityY = a.velocity.dy - b.velocity.dy;

      final nx = dx / dist;
      final ny = dy / dist;

      final velocityAlong = relativeVelocityX * nx + relativeVelocityY * ny;

      if (velocityAlong < 0) {
        final e = restitution;
        final m1 = a.mass;
        final m2 = b.mass;
        final impulse = (1 + e) * velocityAlong / (1 / m1 + 1 / m2);

        a.velocity = Offset(
          a.velocity.dx - (impulse * nx) / m1,
          a.velocity.dy - (impulse * ny) / m1,
        );
        b.velocity = Offset(
          b.velocity.dx + (impulse * nx) / m2,
          b.velocity.dy + (impulse * ny) / m2,
        );
      }
    }
  }

  void _handleWallCollision(ChipPhysics chip) {
    if (chip.position.dx - radius < leftBound) {
      chip.position = Offset(leftBound + radius, chip.position.dy);
      chip.velocity = Offset(-chip.velocity.dx * restitution, chip.velocity.dy);
    }

    if (chip.position.dx + radius > rightBound) {
      chip.position = Offset(rightBound - radius, chip.position.dy);
      chip.velocity = Offset(-chip.velocity.dx * restitution, chip.velocity.dy);
    }

    if (chip.position.dy - radius < topBound) {
      chip.position = Offset(chip.position.dx, topBound + radius);
      chip.velocity = Offset(chip.velocity.dx, -chip.velocity.dy * restitution);
    }

    if (chip.position.dy + radius > bottomBound) {
      chip.position = Offset(chip.position.dx, bottomBound - radius);
      chip.velocity = Offset(chip.velocity.dx, -chip.velocity.dy * restitution);
    }
  }

  void updateBounds(double left, double top, double right, double bottom) {
    leftBound = left;
    topBound = top;
    rightBound = right;
    bottomBound = bottom;
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Featured Projects',
            subtitle: 'Some of my best work',
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;
              if (constraints.maxWidth < 1000) crossAxisCount = 2;
              if (constraints.maxWidth < 700) crossAxisCount = 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 1.3,
                ),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    FloatingProjectCard(index: index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FloatingProjectCard extends StatefulWidget {
  final int index;
  const FloatingProjectCard({super.key, required this.index});

  @override
  State<FloatingProjectCard> createState() => _FloatingProjectCardState();
}

class _FloatingProjectCardState extends State<FloatingProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  final List<Map<String, String>> _projects = const [
    {
      'name': 'STBB',
      'description':
          'Help people to find particular blood type in emergency situations',
      'image': 'assets/images/bb_th.png',
      'category': 'Healthcare',
    },
    {
      'name': 'M-Paridarshan',
      'description':
          'West Bengal government’s initiative for inspection of schools',
      'image': 'assets/images/mp_th.png',
      'category': 'Education',
    },
    {
      'name': 'SponicHR',
      'description':
          'A complete HR management system for offices and organizations',
      'image': 'assets/images/sp_th.png',
      'category': 'Management',
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: Duration(seconds: 2 + widget.index % 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = sin(_floatController.value * pi) * 10;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 500 + widget.index * 100),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.9 + (value * 0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                _projects[widget.index]['image']!,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 160,
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C63FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _projects[widget.index]['category']!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _projects[widget.index]['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _projects[widget.index]['description']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),

                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ProjectDetailModal(
                                        project: _projects[widget.index],
                                        screenshots: widget.index == 0
                                            ? [
                                                'assets/images/bb_1.webp',
                                                'assets/images/bb_2.webp',
                                                'assets/images/bb_3.webp',
                                              ]
                                            : widget.index == 1
                                            ? [
                                                'assets/images/mp_1.webp',
                                                'assets/images/mp_2.webp',
                                                'assets/images/mp_3.webp',
                                              ]
                                            : [
                                                'assets/images/sp_1.png',
                                                'assets/images/sp_2.png',
                                                'assets/images/sp_3.png',
                                                'assets/images/sp_4.png',
                                                'assets/images/sp_5.png',
                                                'assets/images/sp_6.png',
                                              ],
                                        fetures: widget.index == 0
                                            ? {
                                                'Secure Authentication':
                                                    Icons.lock,
                                                'Roll Based Authentication':
                                                    Icons.lock,

                                                "Real Time Data Sync":
                                                    Icons.sync,

                                                "Location wise Blood Bank Search":
                                                    Icons.location_on,
                                              }
                                            : widget.index == 1
                                            ? {
                                                'School Inspection Management':
                                                    Icons.school,

                                                'Report Generation':
                                                    Icons.insert_drive_file,

                                                'Roll Based Authentication':
                                                    Icons.lock,

                                                "Geo Fencing for Inspections":
                                                    Icons.location_on,
                                              }
                                            : {
                                                'Employee Management':
                                                    Icons.people,

                                                'Leave Management':
                                                    Icons.beach_access,

                                                "Real Time Notifications":
                                                    Icons.notifications,

                                                "Real Time Chat Support":
                                                    Icons.chat,
                                              },

                                        techStack: widget.index == 0
                                            ? {
                                                'Flutter':
                                                    FontAwesomeIcons.flutter,
                                                'Dart':
                                                    FontAwesomeIcons.dartLang,

                                                "Google Maps API": Icons.map,

                                                'REST API': Icons.api,
                                                'GetX': Icons.info,
                                              }
                                            : widget.index == 1
                                            ? {
                                                'Flutter':
                                                    FontAwesomeIcons.flutter,
                                                'Dart':
                                                    FontAwesomeIcons.dartLang,

                                                "Google Maps API": Icons.map,

                                                'REST API': Icons.api,
                                                'Provider': Icons.info,
                                              }
                                            : {
                                                'Flutter':
                                                    FontAwesomeIcons.flutter,
                                                'Dart':
                                                    FontAwesomeIcons.dartLang,

                                                "Firebase": Icons.fireplace,

                                                "Google Maps API": Icons.map,

                                                'REST API': Icons.api,
                                                'Provider': Icons.info,
                                              },

                                        link: widget.index == 0
                                            ? 'https://apps.apple.com/in/app/stbb/id6636482794'
                                            : widget.index == 1
                                            ? 'https://play.google.com/store/apps/details?id=com.albatross.mparidarshan'
                                            : 'https://play.google.com/store/apps/details?id=com.xentix.swc&hl=en_IN',
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C63FF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text(
                                    'View Details',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class OfferSection extends StatelessWidget {
  const OfferSection({super.key});

  final List<Map<String, dynamic>> offers = const [
    {
      'icon': Icons.flutter_dash,
      'title': 'Flutter Development',
      'description':
          'Cross-platform apps for iOS, Android, and Web from single codebase',
      'color': Color(0xFF42A5F5),
    },
    {
      'icon': Icons.design_services,
      'title': 'UI/UX Design',
      'description': 'Beautiful, responsive, and intuitive user interfaces',
      'color': Color(0xFF6C63FF),
    },
    {
      'icon': Icons.backup,
      'title': 'Backend Integration',
      'description': 'Firebase, REST APIs, and cloud services integration',
      'color': Color(0xFF66BB6A),
    },
    {
      'icon': Icons.speed,
      'title': 'Performance Optimization',
      'description': 'Fast loading times and smooth animations',
      'color': Color(0xFFFFA726),
    },
    {
      'icon': Icons.app_registration,
      'title': 'App Deployment',
      'description': 'Play Store and App Store deployment',
      'color': Color(0xFFEF5350),
    },
    {
      'icon': Icons.build,
      'title': 'Maintenance & Support',
      'description': 'Ongoing support and feature updates',
      'color': Color(0xFFAB47BC),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          const SectionHeader(
            title: 'What I Offer',
            subtitle: 'Services & Solutions',
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;
              if (constraints.maxWidth < 900) crossAxisCount = 2;
              if (constraints.maxWidth < 600) crossAxisCount = 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 1.2,
                ),
                itemCount: offers.length,
                itemBuilder: (context, index) =>
                    FloatingOfferCard(offer: offers[index], index: index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FloatingOfferCard extends StatefulWidget {
  final Map<String, dynamic> offer;
  final int index;
  const FloatingOfferCard({
    super.key,
    required this.offer,
    required this.index,
  });

  @override
  State<FloatingOfferCard> createState() => _FloatingOfferCardState();
}

class _FloatingOfferCardState extends State<FloatingOfferCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: Duration(seconds: 2 + widget.index % 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = sin(_floatController.value * pi) * 8;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 400 + widget.index * 100),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.9 + (value * 0.1),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.offer['color'],
                                widget.offer['color'].withOpacity(0.5),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.offer['icon'],
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.offer['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.offer['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> skills = [
      {
        'name': 'Flutter',
        'level': 0.95,
        'icon': FontAwesomeIcons.flutter,
        'color': const Color(0xFF42A5F5),
      },
      {
        'name': 'Dart',
        'level': 0.92,
        'icon': FontAwesomeIcons.dartLang,
        'color': const Color(0xFF00E5FF),
      },
      {
        'name': 'Firebase',
        'level': 0.90,
        'icon': FontAwesomeIcons.fire,
        'color': const Color(0xFFFFA726),
      },
      {
        'name': 'REST API',
        'level': 0.92,
        'icon': Icons.api,
        'color': const Color(0xFFEF5350),
      },
      {
        'name': 'Provider/BLoC/GetX',
        'level': 0.90,
        'icon': FontAwesomeIcons.accessibleIcon,
        'color': const Color(0xFF6C63FF),
      },
      {
        'name': 'Git',
        'level': 0.88,
        'icon': Icons.code_off,
        'color': const Color(0xFF66BB6A),
      },
      {
        'name': 'Figma',
        'level': 0.85,
        'icon': Icons.design_services,
        'color': const Color(0xFFEC407A),
      },
      {
        'name': 'HTML/CSS',
        'level': 0.82,
        'icon': Icons.web,
        'color': const Color(0xFF42A5F5),
      },
      //postman
      {
        'name': 'Postman',
        'level': 0.80,
        'icon': Icons.send,
        'color': const Color(0xFFFF7043),
      },
      // sql
      {
        'name': 'SQL',
        'level': 0.78,
        'icon': Icons.storage,
        'color': const Color(0xFFAB47BC),
      },
      // java
      {
        'name': 'Java',
        'level': 0.70,
        'icon': Icons.code,
        'color': const Color(0xFF42A5F5),
      },
      // webrtc/ socket.io
      {
        'name': 'WebSockets',
        'level': 0.75,
        'icon': Icons.sync,
        'color': const Color(0xFF26C6DA),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Technical Skills',
            subtitle: 'Technologies I master',
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth < 1000) crossAxisCount = 3;
              if (constraints.maxWidth < 700) crossAxisCount = 2;
              if (constraints.maxWidth < 500) crossAxisCount = 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) =>
                    FloatingSkillCard(skill: skills[index], index: index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FloatingSkillCard extends StatefulWidget {
  final Map<String, dynamic> skill;
  final int index;
  const FloatingSkillCard({
    super.key,
    required this.skill,
    required this.index,
  });

  @override
  State<FloatingSkillCard> createState() => _FloatingSkillCardState();
}

class _FloatingSkillCardState extends State<FloatingSkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: Duration(seconds: 2 + widget.index % 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = sin(_floatController.value * pi) * 6;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 400 + widget.index * 80),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.9 + (value * 0.1),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.skill['icon'],
                          color: widget.skill['color'],
                          size: 35,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.skill['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: widget.skill['level'],
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.skill['color'],
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(widget.skill['level'] * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ProjectDetailModal extends StatefulWidget {
  final Map<String, String> project;
  final List<String> screenshots;
  final Map<String, dynamic> fetures;
  final Map<String, dynamic> techStack;
  final String link;

  const ProjectDetailModal({
    super.key,
    required this.project,
    required this.screenshots,
    required this.fetures,
    required this.techStack,
    required this.link,
  });

  @override
  State<ProjectDetailModal> createState() => _ProjectDetailModalState();
}

class _ProjectDetailModalState extends State<ProjectDetailModal> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_controller.hasClients) {
        _currentPage++;

        if (_currentPage >= widget.screenshots.length) {
          _currentPage = 0; // loop back
        }

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      _startAutoSlide(); // repeat
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 400),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.9 + (value * 0.1),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [Color(0xFF0A0E21), Color(0xFF1A1A3E)],
                  ),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 40),
                              // Center(
                              //   child:
                              // ),
                              const SizedBox(height: 40),
                              Text(
                                widget.project['name']!,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.project['category']!,
                                  style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Project Overview',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.project['description']!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[400],
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Key Features',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.fetures.entries
                                    .map((e) => _FeatureChip(e.key, e.value))
                                    .toList(),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Tech Stack',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.techStack.entries
                                    .map((e) => _TechChip(e.key, e.value))
                                    .toList(),
                              ),

                              const SizedBox(height: 30),
                              const Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildStoreButton(
                                Icons.cloud_download,
                                'App Store/ Play Store',
                                widget.link,
                              ),

                              const SizedBox(height: 60),
                            ],
                          ),

                          SizedBox(
                            height: 600,
                            width: 300,
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: widget.screenshots.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        widget.screenshots[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoreButton(IconData icon, String text, String url) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final Uri uri = Uri.parse(url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FeatureChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _TechChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'flutter.dev@example.com');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchLinkedIn() async {
    final Uri linkedInUri = Uri.parse('https://linkedin.com/in/flutterdev');
    if (await canLaunchUrl(linkedInUri)) {
      await launchUrl(linkedInUri);
    }
  }

  void _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/+919330081292');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 40 * (1 - value)),
              child: Container(
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    const SectionHeader(
                      title: "Let's Connect",
                      subtitle: 'Get in touch with me',
                    ),
                    const SizedBox(height: 50),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isRow = constraints.maxWidth > 700;
                        if (isRow) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildContactCard(
                                  context: context,
                                  icon: Icons.email,
                                  title: 'Email',
                                  value: 'kabirul.islam.co@gmail.com',
                                  onTap: _launchEmail,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: _buildContactCard(
                                  context: context,
                                  icon: Icons.link,
                                  title: 'LinkedIn',
                                  value:
                                      'https://www.linkedin.com/in/kabirul-islam-779010214/',
                                  onTap: _launchLinkedIn,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: _buildContactCard(
                                  context: context,
                                  icon: FontAwesomeIcons.whatsapp,
                                  title: 'WhatsApp',
                                  value: '+91 9330081292',
                                  onTap: _openWhatsApp,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildContactCard(
                                context: context,
                                icon: Icons.email,
                                title: 'Email',
                                value: 'flutter.dev@example.com',
                                onTap: _launchEmail,
                              ),
                              const SizedBox(height: 25),
                              _buildContactCard(
                                context: context,
                                icon: Icons.link,
                                title: 'LinkedIn',
                                value: 'linkedin.com/in/flutterdev',
                                onTap: _launchLinkedIn,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 35),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.verified,
                            color: Color(0xFF6C63FF),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Available for freelance work',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 10),
            // Text(
            //   value,
            //   style: TextStyle(
            //     fontSize: 13,
            //     color: Colors.grey[400],
            //     decoration: TextDecoration.underline,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SelectableText(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("Copied")));
                  },
                  child: Icon(Icons.copy, size: 16, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
