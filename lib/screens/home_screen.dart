import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/screens/video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(
        'https://servidor17-1.brlogic.com:7112/live?source=website',
      );
      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted && playerState.processingState == ProcessingState.ready) {
          setState(() {
            _isPlaying = playerState.playing;
          });
        }
      });
    } catch (e) {
      // Handle error
      print("Error setting audio source: $e");
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Builder(
        builder: (context) => Stack(
          children: [_buildBackgroundSlideshow(), _buildPlayerCard(context)],
        ),
      ),
    );
  }

  Widget _buildBackgroundSlideshow() {
    final List<String> imgList = [
      'assets/images/CAPA01.jpg',
      'assets/images/CAPA02.jpg',
      'assets/images/CAPA03.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        viewportFraction: 1.0,
      ),
      items: imgList
          .map((item) => Image.asset(item, fit: BoxFit.cover, width: double.infinity, height: double.infinity))
          .toList(),
    );
  }

  Widget _buildPlayerCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(120),
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/images/logo.png', width: screenWidth * 0.45),
                        _buildRadioInfo(),
                        _buildControls(),
                        _buildMicrophoneButton(),
                      ],
                    ),
                  ),
                  _buildTicker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildSocialIcon(FontAwesomeIcons.tiktok, 'TikTok', 'https://www.tiktok.com/@radiotopfmma', size: 38),
            const SizedBox(width: 8),
            _buildSocialIcon(FontAwesomeIcons.facebook, 'Facebook', 'https://web.facebook.com/people/RadioTop-Ipz/pfbid037mqL7tt56XWp1eL5S5vWHufwSCmCepoQE5LoLHEjPiGdBeqvwmVBSFWSnCRydv5kl/', size: 38),
            const SizedBox(width: 8),
            _buildSocialIcon(FontAwesomeIcons.youtube, 'YouTube', 'https://youtube.com/@radiotopfmma', size: 38),
          ],
        ),
        _buildMenuIcon(context),
      ],
    );
  }

  Widget _buildMenuIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(40),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.menu, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip, String urlString, {double size = 46}) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => _launchURL(urlString),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: Center(child: FaIcon(icon, color: Colors.white, size: size * 0.5)),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir: $urlString')),
        );
      }
    }
  }

  Widget _buildRadioInfo() {
    return Column(
      children: const [
        Text('Rádio Top FM 88.9', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
        SizedBox(height: 4),
        Text('Imperatriz – Maranhão', style: TextStyle(fontSize: 14, color: Color(0xFFffd700))),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _togglePlayPause,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
          ),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            size: 40,
            color: const Color(0xFFd80c25),
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoScreen())),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(18),
            backgroundColor: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.live_tv, size: 36, color: Color(0xFFd80c25)),
              Text('Ao vivo', style: TextStyle(fontSize: 11, color: Color(0xFFd80c25))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMicrophoneButton() {
    return ElevatedButton(
      onPressed: () => _launchURL('https://wa.me/559992178888'),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
      ),
      child: const Icon(Icons.mic, size: 34, color: Color(0xFFd80c25)),
    );
  }

  Widget _buildTicker() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFb5091f),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 20,
              child: Marquee(
                text: '• NO AR •',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                velocity: 50.0,
                blankSpace: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF121212),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFd80c25)),
              child: Text('Rádio Top FM', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Sobre a Rádio Top', style: TextStyle(color: Colors.white)),
              onTap: () => _showInfoDialog('Sobre a Rádio Top', 'Rádio Top FM, uma emissora da empresa RÁDIO E TV FAROL DA COMUNICAÇÃO LTDA, com pátio de transmissão no município de Davinópolis, no canal 205 frequência modulada 88.9 MHz. Nosso estúdio está localizado na rua Y, Nova Imperatriz, em frente à Secretaria Municipal de Infraestrutura... (conteúdo completo)'),
            ),
            ListTile(
              title: const Text('Termos de uso', style: TextStyle(color: Colors.white)),
              onTap: () => _showInfoDialog('Termos de Uso', 'Ao acessar o site da Rádio Top FM, você concorda com os nossos termos de uso... (conteúdo completo)'),
            ),
            ListTile(
              title: const Text('Política de privacidade', style: TextStyle(color: Colors.white)),
              onTap: () => _showInfoDialog('Política de Privacidade', 'Coletamos apenas dados essenciais como mensagens de áudio enviados pelos usuários... (conteúdo completo)'),
            ),
            const Divider(color: Colors.grey),
            const ListTile(title: Text('Nossas Redes Sociais', style: TextStyle(color: Colors.white70))),
            _buildSocialDrawer(),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/banner.png'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222222),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(child: Text(content, style: const TextStyle(color: Colors.white70))),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar', style: TextStyle(color: Color(0xFFd80c25))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialDrawer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSocialIcon(FontAwesomeIcons.tiktok, 'TikTok', 'https://www.tiktok.com/@radiotopfmma'),
        _buildSocialIcon(FontAwesomeIcons.facebook, 'Facebook', 'https://web.facebook.com/people/RadioTop-Ipz/pfbid037mqL7tt56XWp1eL5S5vWHufwSCmCepoQE5LoLHEjPiGdBeqvwmVBSFWSnCRydv5kl/'),
        _buildSocialIcon(FontAwesomeIcons.youtube, 'YouTube', 'https://youtube.com/@radiotopfmma'),
      ],
    );
  }
}