import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../models/dados.dart';

class AlbumScreen extends StatefulWidget {
  final List<int> repetidas;
  final List<int> faltam;
  final Map<String, dynamic> usuario;

  const AlbumScreen({
    super.key,
    required this.repetidas,
    required this.faltam,
    required this.usuario,
  });

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final Map<String, GlobalKey> _seloKeys = {};

  int _progresso(String pais) {
    final figs = todasFigurinhas.where((f) => f.pais == pais).toList();
    // Tenho = todas MENOS as que estao em faltam
    return figs.where((f) => !widget.faltam.contains(f.id)).length;
  }

  bool _completo(String pais) {
    final figs = todasFigurinhas.where((f) => f.pais == pais).toList();
    return figs.every((f) => !widget.faltam.contains(f.id));
  }

  int get _totalTenho => todasFigurinhas.where((f) => !widget.faltam.contains(f.id)).length;
  int get _totalFigurinhas => todasFigurinhas.length;

  @override
  void initState() {
    super.initState();
    for (final sel in selecoesDados) {
      _seloKeys[sel["pais"] as String] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timesCompletos = selecoesDados
        .where((s) => _completo(s["pais"] as String))
        .toList();

    return CustomScrollView(slivers: [
      // ── Header geral ──────────────────────────────────────────────────
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(children: [
          // Botao voltar
          Row(children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF252525)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_back_ios, color: Color(0xFF00C864), size: 14),
                  SizedBox(width: 4),
                  Text('Voltar', style: TextStyle(
                      color: Color(0xFF00C864), fontSize: 13, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          // Card progresso
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1A10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00C864)),
            ),
            child: Column(children: [
              Row(children: [
                const Text('📖', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Meu Álbum', style: GoogleFonts.bebasNeue(
                      fontSize: 22, color: Colors.white, letterSpacing: 1)),
                  Text(
                    '${widget.usuario['nome'].toString().split(' ').first} · Copa 2026',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('$_totalTenho', style: GoogleFonts.bebasNeue(
                      fontSize: 36, color: const Color(0xFF00C864))),
                  Text('de $_totalFigurinhas',
                      style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ]),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _totalTenho / _totalFigurinhas,
                  backgroundColor: const Color(0xFF1A1A1A),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF00C864)),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  '${(_totalTenho / _totalFigurinhas * 100).toStringAsFixed(1)}% completo',
                  style: const TextStyle(color: Color(0xFF00C864),
                      fontSize: 11, fontWeight: FontWeight.w800)),
                Text('${_totalFigurinhas - _totalTenho} faltando',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ]),
            ]),
          ),

          // Times completos
          if (timesCompletos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1000),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('🏆', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Times Completos — ${timesCompletos.length}',
                      style: const TextStyle(color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w800, fontSize: 14)),
                ]),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8,
                  children: timesCompletos.map((sel) => GestureDetector(
                    onTap: () => _mostrarSelo(sel),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D1F00),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(sel["emoji"] as String,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(sel["pais"] as String,
                            style: const TextStyle(color: Color(0xFFF59E0B),
                                fontSize: 12, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 4),
                        const Text('🏆', style: TextStyle(fontSize: 11)),
                      ]),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                Text('Toque para ver e compartilhar o selo! 📲',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ]),
            ),
          ],
          const SizedBox(height: 8),
        ]),
      )),

      // ── Lista seleções ─────────────────────────────────────────────────
      SliverList(delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          final sel  = selecoesDados[i];
          final pais = sel["pais"] as String;
          final figs = todasFigurinhas.where((f) => f.pais == pais).toList();
          final prog = _progresso(pais);
          final done = prog == 20;

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: done ? () => _mostrarSelo(sel) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: done ? const Color(0xFF1A1000) : const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: done ? const Color(0xFFF59E0B) : const Color(0xFF1E1E1E),
                      width: done ? 1.5 : 1,
                    ),
                  ),
                  child: Row(children: [
                    Text(sel["emoji"] as String, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(pais, style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                        if (done) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('COMPLETO 🏆',
                                style: TextStyle(color: Colors.black,
                                    fontSize: 8, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ]),
                      Text('Grupo ${sel["grupo"]}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 10)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('$prog/20', style: TextStyle(
                        color: done ? const Color(0xFFF59E0B) : const Color(0xFF00C864),
                        fontWeight: FontWeight.w800, fontSize: 13,
                      )),
                      if (done)
                        Text('ver selo', style: TextStyle(
                            color: Colors.grey[600], fontSize: 9)),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: prog / 20,
                  backgroundColor: const Color(0xFF1A1A1A),
                  valueColor: AlwaysStoppedAnimation(
                    done ? const Color(0xFFF59E0B) : const Color(0xFF00C864)),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 5),
              // Grid figurinhas
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 3.2,
                  crossAxisSpacing: 3, mainAxisSpacing: 3,
                ),
                itemCount: figs.length,
                itemBuilder: (ctx, fi) {
                  final f    = figs[fi];
                  final tenho = widget.repetidas.contains(f.id);
                  final falta = widget.faltam.contains(f.id);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      color: tenho
                          ? const Color(0xFF001A0A)
                          : falta
                              ? const Color(0xFF1A1000)
                              : const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: tenho
                            ? const Color(0xFF00C864)
                            : falta
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF252525),
                      ),
                    ),
                    child: Row(children: [
                      Text(f.numero, style: TextStyle(
                        fontSize: 7,
                        color: tenho
                            ? const Color(0xFF00C864)
                            : falta
                                ? const Color(0xFFF59E0B)
                                : Colors.grey[700],
                        fontWeight: FontWeight.w800,
                      )),
                      const SizedBox(width: 2),
                      Expanded(child: Text(
                        f.nome.split(' ').first,
                        style: TextStyle(fontSize: 7,
                            color: tenho ? Colors.white : Colors.grey[600]),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      )),
                    ]),
                  );
                },
              ),
            ]),
          );
        },
        childCount: selecoesDados.length,
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 80)),
    ]);
  }

  // ── Selo estilo "Match Perfeito" ─────────────────────────────────────────
  void _mostrarSelo(Map<String, dynamic> sel) {
    final pais  = sel["pais"]  as String;
    final emoji = sel["emoji"] as String;
    final figs  = todasFigurinhas.where((f) => f.pais == pais).toList();
    final key   = _seloKeys[pais] ?? GlobalKey();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),

              // ── SELO VISUAL ───────────────────────────────────────────
              RepaintBoundary(
                key: key,
                child: Container(
                  width: 340, height: 340,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A0800),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 5),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                          blurRadius: 30, spreadRadius: 2),
                    ],
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    // Anéis decorativos
                    Container(
                      width: 320, height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.3), width: 1.5)),
                    ),
                    Container(
                      width: 300, height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15), width: 1)),
                    ),
                    // Troféu esquerda
                    const Positioned(left: 18, top: 120,
                        child: Text('🏆', style: TextStyle(fontSize: 32))),
                    // Estrela direita
                    const Positioned(right: 18, top: 100,
                        child: Text('⭐', style: TextStyle(fontSize: 28))),
                    // Conteúdo
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      // Topo
                      Text('COMPLETEI APÓS O',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 12, color: Colors.white,
                              letterSpacing: 2)),
                      Text('MATCH', style: GoogleFonts.bebasNeue(
                          fontSize: 38, color: const Color(0xFFF59E0B),
                          letterSpacing: 2,
                          shadows: [const Shadow(color: Color(0xFF7C4A00),
                              offset: Offset(2, 2), blurRadius: 0)])),
                      Text('PERFEITO', style: GoogleFonts.bebasNeue(
                          fontSize: 34, color: Colors.white, letterSpacing: 3,
                          shadows: [const Shadow(color: Color(0xFF333333),
                              offset: Offset(2, 2), blurRadius: 0)])),
                      // Check
                      Container(
                        width: 36, height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF59E0B),
                        ),
                        child: const Center(
                          child: Text('✓', style: TextStyle(
                              color: Colors.black, fontSize: 20,
                              fontWeight: FontWeight.w900)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Mini figurinhas grid
                      SizedBox(
                        width: 180,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5, childAspectRatio: 1.1,
                            crossAxisSpacing: 2, mainAxisSpacing: 2,
                          ),
                          itemCount: 10,
                          itemBuilder: (_, i) => Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1a3a6e),
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: const Color(0xFF4a6fa5), width: 0.5),
                            ),
                            child: const Center(child: Text('🧍',
                                style: TextStyle(fontSize: 10))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Marca
                      Text('VALEU', style: TextStyle(
                          fontSize: 10, color: Colors.grey[400],
                          letterSpacing: 3, fontWeight: FontWeight.w700)),
                      Text('TROCA', style: GoogleFonts.bebasNeue(
                          fontSize: 22, color: Colors.white, letterSpacing: 1)),
                      Text('FIGURINHA', style: GoogleFonts.bebasNeue(
                          fontSize: 22, color: const Color(0xFFF59E0B),
                          letterSpacing: 1,
                          shadows: [const Shadow(color: Color(0xFF7C4A00),
                              offset: Offset(1, 1))])),
                      const SizedBox(height: 6),
                      // País
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(emoji,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const Text('★  ★',
                                style: TextStyle(color: Colors.black,
                                    fontSize: 8, fontWeight: FontWeight.w900)),
                            Text(pais.toUpperCase(),
                                style: GoogleFonts.bebasNeue(
                                    fontSize: 18, color: Colors.black,
                                    letterSpacing: 2)),
                            const Text('PAÍS COMPLETADO',
                                style: TextStyle(color: Color(0xFF3a2000),
                                    fontSize: 7, fontWeight: FontWeight.w900,
                                    letterSpacing: 1)),
                          ]),
                        ]),
                      ),
                    ]),
                  ]),
                ),
              ),

              const SizedBox(height: 16),
              // Nome usuário
              Text(
                '${widget.usuario['nome']} completou este time!',
                style: const TextStyle(color: Color(0xFF00C864),
                    fontWeight: FontWeight.w800, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text('via @TrocaFigurinha · Copa 2026 ⚽',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              const SizedBox(height: 16),

              // Botão compartilhar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.share, size: 18),
                      label: Text('Compartilhar no Instagram / WhatsApp',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800, fontSize: 13)),
                      onPressed: () => _compartilhar(key, ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Fechar',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _compartilhar(GlobalKey key, BuildContext ctx) async {
    try {
      final boundary = key.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '📲 Tire um print do selo e compartilhe no Instagram! ⚽'),
            backgroundColor: Color(0xFF003D1F),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 Tire um print e compartilhe no Instagram!'),
            backgroundColor: Color(0xFF003D1F),
          ),
        );
      }
    }
  }
}
