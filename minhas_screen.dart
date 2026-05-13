import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dados.dart';
import '../models/figurinha.dart';

class MinhasScreen extends StatefulWidget {
  final List<int> repetidas;
  final List<int> faltam;
  final Function(int) onToggleRepetida;
  final Function(int) onToggleFaltam;
  final VoidCallback onBuscar;
  const MinhasScreen({super.key, required this.repetidas, required this.faltam,
    required this.onToggleRepetida, required this.onToggleFaltam, required this.onBuscar});
  @override State<MinhasScreen> createState() => _MinhasScreenState();
}

class _MinhasScreenState extends State<MinhasScreen> with SingleTickerProviderStateMixin {
  // Listas de dados carregadas localmente para evitar problemas de escopo
  late final List<Figurinha> _todasFigurinhas = gerarFigurinhas();
  late final List<String> _todasSelecoes = selecoesDados.map((s) => s["pais"] as String).toList();
  late final List<Map<String, dynamic>> _selecoesDados = selecoesDados;
  late TabController _tabCtrl;
  String _paisFiltro = 'Todos';
  String _busca = '';
  final _buscaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  List<Figurinha> get _figsFiltradas => _todasFigurinhas.where((f) {
    final pOk = _paisFiltro == 'Todos' || f.pais == _paisFiltro;
    final bOk = _busca.isEmpty || f.nome.toLowerCase().contains(_busca.toLowerCase());
    return pOk && bOk;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Botoes de navegacao topo ──────────────────────────────────────────
      Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Row(children: [
          Expanded(child: GestureDetector(
            onTap: widget.onBuscar,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF003D1F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF00C864)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('🔍', style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text('Buscar Trocas Perfeitas →', style: TextStyle(
                    color: Color(0xFF00C864), fontSize: 13, fontWeight: FontWeight.w800)),
              ]),
            ),
          )),
        ]),
      ),
      // Abas Tenho Repetidas / Me Faltam
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E1E1E))),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tabCtrl,
            indicator: BoxDecoration(borderRadius: BorderRadius.circular(9), border: Border.all(color: const Color(0xFF00C864), width: 1.5), color: const Color(0xFF0D0D0D)),
            labelColor: const Color(0xFF00C864),
            unselectedLabelColor: const Color(0xFF555555),
            labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 12),
            unselectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 12),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🃏 Tenho repetidas'),
                if (widget.repetidas.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: const Color(0xFF00C864), borderRadius: BorderRadius.circular(20)),
                    child: Text('${widget.repetidas.length}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900))),
                ],
              ])),
              Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🔍 Me faltam', style: TextStyle(color: Color(0xFFF59E0B))),
                if (widget.faltam.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(20)),
                    child: Text('${widget.faltam.length}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900))),
                ],
              ])),
            ],
          ),
        ),
      ),

      // Instrução contextual
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: AnimatedBuilder(
          animation: _tabCtrl,
          builder: (ctx, _) {
            final isRepetidas = _tabCtrl.index == 0;
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRepetidas ? const Color(0xFF001A0A) : const Color(0xFF1A1200),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isRepetidas ? const Color(0xFF1E3A22) : const Color(0xFF3A2D00))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isRepetidas ? '🃏 Marque o que você tem repetido' : '🔍 Marque o que está faltando no álbum',
                  style: TextStyle(color: isRepetidas ? const Color(0xFF00C864) : const Color(0xFFF59E0B), fontWeight: FontWeight.w800, fontSize: 12)),
                const SizedBox(height: 2),
                Text(isRepetidas
                  ? 'O sistema vai oferecer suas repetidas para quem precisa delas.'
                  : 'O sistema vai buscar quem tem essas figurinhas repetidas para te oferecer.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ]),
            );
          },
        ),
      ),

      // Busca e filtro
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Row(children: [
          Expanded(child: TextField(
            controller: _buscaCtrl,
            onChanged: (v) => setState(() => _busca = v),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: '🔎 Buscar jogador...',
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
              filled: true, fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF252525))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF252525))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00C864))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              prefixIcon: Icon(Icons.search, color: Colors.grey[700], size: 18)),
          )),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF252525))),
            child: DropdownButton<String>(
              value: _paisFiltro, underline: const SizedBox(),
              dropdownColor: const Color(0xFF1A1A1A),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: <String>['Todos', ..._todasSelecoes].map<DropdownMenuItem<String>>((String p) => DropdownMenuItem<String>(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => _paisFiltro = v!)),
          ),
        ]),
      ),

      // Contador
      AnimatedBuilder(
        animation: _tabCtrl,
        builder: (ctx, _) {
          final isRepetidas = _tabCtrl.index == 0;
          final count = isRepetidas ? widget.repetidas.length : widget.faltam.length;
          final cor = isRepetidas ? const Color(0xFF00C864) : const Color(0xFFF59E0B);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${_figsFiltradas.length} figurinhas', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
              Text('$count marcadas ✓', style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w800)),
            ]),
          );
        },
      ),

      // Lista
      Expanded(child: TabBarView(
        controller: _tabCtrl,
        children: [
          _listaFigurinhas(isRepetidas: true),
          _listaFigurinhas(isRepetidas: false),
        ],
      )),

      // FAB
      _fabWidget(),
    ]);
  }

  Widget _listaFigurinhas({required bool isRepetidas}) {
    final lista = isRepetidas ? widget.repetidas : widget.faltam;
    final cor = isRepetidas ? const Color(0xFF00C864) : const Color(0xFFF59E0B);
    final gradOn = isRepetidas
      ? [const Color(0xFF001A0A), const Color(0xFF003D1F)]
      : [const Color(0xFF1A0F00), const Color(0xFF3D2400)];

    final selsFiltradas = _selecoesDados.where((s) => _figsFiltradas.any((f) => f.pais == s["pais"])).toList();
    final todasEsp = gerarEspeciais();

    // Total de itens: seleções + 1 separador + categorias especiais
    final totalItems = selsFiltradas.length + 1 + especialsDados.length;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
      itemCount: totalItems,
      itemBuilder: (ctx, si) {
        // ── Separador especiais ──
        if (si == selsFiltradas.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(children: [
              const Expanded(child: Divider(color: Color(0xFF1E1E1E))),
              const SizedBox(width: 10),
              Text('✨ Figurinhas Especiais — 68 cromos',
                  style: TextStyle(fontSize: 11, color: cor, fontWeight: FontWeight.w800)),
              const SizedBox(width: 10),
              const Expanded(child: Divider(color: Color(0xFF1E1E1E))),
            ]),
          );
        }

        // ── Categorias especiais ──
        if (si > selsFiltradas.length) {
          final cat = especialsDados[si - selsFiltradas.length - 1];
          final catFigs = todasEsp.where((f) => f.pais == cat["categoria"]).toList();
          final nMarcadas = catFigs.where((f) => lista.contains(f.id)).length;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color((cat["cor"] as int)).withOpacity(0.4)),
              ),
              child: Row(children: [
                Text(cat["emoji"] as String, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(child: Text(cat["categoria"] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
                Text('$nMarcadas/${catFigs.length}',
                    style: TextStyle(color: nMarcadas > 0 ? cor : Colors.grey[800], fontSize: 11, fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4.5, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemCount: catFigs.length,
              itemBuilder: (ctx, fi) {
                final f = catFigs[fi];
                final on = lista.contains(f.id);
                return GestureDetector(
                  onTap: () => isRepetidas ? widget.onToggleRepetida(f.id) : widget.onToggleFaltam(f.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: on ? LinearGradient(colors: gradOn) : null,
                      color: on ? null : const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: on ? cor : const Color(0xFF1E1E1E), width: 1.5)),
                    child: Row(children: [
                      Text(f.numero, style: TextStyle(fontSize: 9, color: Colors.grey[500], fontWeight: FontWeight.w800)),
                      const SizedBox(width: 6),
                      Expanded(child: Text(f.nome,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Icon(on ? Icons.check_circle : Icons.circle_outlined,
                          color: on ? cor : const Color(0xFF2A2A2A), size: 16),
                    ]),
                  ),
                );
              },
            ),
          ]);
        }

        // ── Seleções normais ──
        final sel = selsFiltradas[si];
        final figs = _figsFiltradas.where((f) => f.pais == sel["pais"]).toList();
        final nMarcadas = figs.where((f) => lista.contains(f.id)).length;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E1E1E))),
            child: Row(children: [
              Text(sel["emoji"] as String, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(sel["pais"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(4)),
                child: Text('Grupo ${sel["grupo"]}', style: TextStyle(color: Colors.grey[600], fontSize: 11))),
              const Spacer(),
              Text('$nMarcadas/${figs.length}', style: TextStyle(color: nMarcadas > 0 ? cor : Colors.grey[800], fontSize: 11, fontWeight: FontWeight.w800)),
            ]),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4.5, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemCount: figs.length,
            itemBuilder: (ctx, fi) {
              final f = figs[fi];
              final on = lista.contains(f.id);
              return GestureDetector(
                onTap: () => isRepetidas ? widget.onToggleRepetida(f.id) : widget.onToggleFaltam(f.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: on ? LinearGradient(colors: gradOn) : null,
                    color: on ? null : const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: on ? cor : const Color(0xFF1E1E1E), width: 1.5)),
                  child: Row(children: [
                    Text(f.numero, style: TextStyle(fontSize: 9, color: Colors.grey[500], fontWeight: FontWeight.w800)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f.nome, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Icon(on ? Icons.check_circle : Icons.circle_outlined, color: on ? cor : const Color(0xFF2A2A2A), size: 16),
                  ]),
                ),
              );
            },
          ),
        ]);
      },
    );
  }

  Widget _fabWidget() {
    if (widget.repetidas.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: widget.onBuscar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C864), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          child: Text(
            widget.faltam.isNotEmpty ? '🎯 Buscar trocas perfeitas →' : '🔍 Buscar trocas — ${widget.repetidas.length} repetidas →',
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
        )),
      );
    }
    if (widget.faltam.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF1A1200), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF3A2D00))),
        child: Column(children: [
          const Text('Agora marque suas repetidas também! 👆', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 4),
          Text('O sistema precisa saber o que você tem para oferecer.', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        ]),
      );
    }
    return const SizedBox.shrink();
  }
}
