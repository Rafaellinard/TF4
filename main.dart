import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/minhas_screen.dart';
import 'screens/buscar_screen.dart';
import 'screens/notificacoes_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const TrocaFigurinhaApp());
}

class TrocaFigurinhaApp extends StatelessWidget {
  const TrocaFigurinhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Troca Figurinha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00C864),
          secondary: Color(0xFF00C864),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Map<String, dynamic>? _usuario;
  List<int> _repetidas = [];
  List<int> _faltam = [];
  List<Map<String, dynamic>> _notifs = [];
  int _tabIndex = 0;

  void _login(String nome, String tel, String cidade, String estado) {
    setState(() {
      _usuario = {
        'id': 'eu',
        'nome': nome,
        'telefone': tel,
        'cidade': cidade,
        'estado': estado,
      };
      _notifs = [
        {
          'id': 'n1',
          'status': 'pendente',
          'criadaEm': DateTime.now().subtract(const Duration(minutes: 2)),
          'solicitante': {
            'id': 'u2',
            'nome': 'Ana Oliveira',
            'telefone': '(11)98888-5678',
            'cidade': 'São Paulo',
            'estado': 'SP',
          },
          'figsDeles': [1, 25],
          'figsMinas': [37, 75],
          'trocaPerfeita': true,
        },
        {
          'id': 'n2',
          'status': 'aceita',
          'criadaEm': DateTime.now().subtract(const Duration(hours: 1)),
          'solicitante': {
            'id': 'u3',
            'nome': 'Pedro Costa',
            'telefone': '(21)97777-9012',
            'cidade': 'Rio de Janeiro',
            'estado': 'RJ',
          },
          'figsDeles': [5, 61],
          'figsMinas': [88, 115],
          'trocaPerfeita': false,
        },
      ];
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() => _notifs.insert(0, {
            'id': 'n_live',
            'status': 'pendente',
            'criadaEm': DateTime.now(),
            'solicitante': {
              'id': 'u5',
              'nome': 'Carlos Menezes',
              'telefone': '(85)95555-7890',
              'cidade': 'Fortaleza',
              'estado': 'CE',
            },
            'figsDeles': [6, 33],
            'figsMinas': [70, 105],
            'trocaPerfeita': false,
          }));
        }
      });
    });
  }

  void _toggleRepetida(int id) => setState(() {
    if (_repetidas.contains(id)) {
      _repetidas.remove(id);
    } else {
      _repetidas.add(id);
    }
  });

  void _toggleFaltam(int id) => setState(() {
    if (_faltam.contains(id)) {
      _faltam.remove(id);
    } else {
      _faltam.add(id);
    }
  });

  void _solicitarTroca(Map<String, dynamic> u) {
    setState(() {
      _notifs.insert(0, {
        'id': 'troca_${u['id']}',
        'status': 'pendente',
        'criadaEm': DateTime.now(),
        'solicitante': u,
        'figsDeles': u['figsDeles'] ?? [],
        'figsMinas': u['figsMinas'] ?? [],
        'trocaPerfeita': u['trocaPerfeita'] ?? false,
      });
      _tabIndex = 2;
    });
  }

  void _logout() {
    setState(() {
      _usuario = null;
      _repetidas = [];
      _faltam = [];
      _notifs = [];
      _tabIndex = 0;
    });
  }

  int get _notifsNaoLidas =>
      _notifs.where((n) => n['status'] == 'pendente').length;

  @override
  Widget build(BuildContext context) {
    if (_usuario == null) return LoginScreen(onLogin: _login);

    final tabs = [
      MinhasScreen(
        repetidas: _repetidas,
        faltam: _faltam,
        onToggleRepetida: _toggleRepetida,
        onToggleFaltam: _toggleFaltam,
        onBuscar: () => setState(() => _tabIndex = 1),
      ),
      BuscarScreen(
        repetidas: _repetidas,
        faltam: _faltam,
        onSolicitar: _solicitarTroca,
      ),
      NotificacoesScreen(
        notifs: _notifs,
        repetidas: _repetidas,
        usuario: _usuario!,
        onUpdate: (updated) => setState(() => _notifs = updated),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        titleSpacing: 16,
        title: Row(children: [
          const Text('⚽', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Troca Figurinha',
                style: GoogleFonts.bebasNeue(
                    fontSize: 18, color: Colors.white, letterSpacing: 1.5)),
            const Text('Copa do Mundo 2026',
                style: TextStyle(fontSize: 9, color: Color(0xFF444444))),
          ]),
        ]),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white70),
              onPressed: () => setState(() => _tabIndex = 2),
            ),
            if (_notifsNaoLidas > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$_notifsNaoLidas',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
          ]),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF555555), size: 20),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
        ),
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF00C864),
          unselectedItemColor: const Color(0xFF555555),
          selectedLabelStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w800, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w700, fontSize: 11),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.style_outlined),
              activeIcon: Icon(Icons.style),
              label: 'Minhas',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Trocas',
            ),
            BottomNavigationBarItem(
              label: 'Avisos',
              icon: Badge(
                isLabelVisible: _notifsNaoLidas > 0,
                label: Text('$_notifsNaoLidas'),
                child: const Icon(Icons.notifications_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: _notifsNaoLidas > 0,
                label: Text('$_notifsNaoLidas'),
                child: const Icon(Icons.notifications),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
