import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/figurinha.dart';
import '../models/dados.dart';


class BuscarScreen extends StatefulWidget {
  final List<int> repetidas;
  final List<int> faltam;
  final Function(Map<String, dynamic> troca) onSolicitar;
  const BuscarScreen({super.key, required this.repetidas, required this.faltam, required this.onSolicitar});
  @override State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  // Acesso local às funções de dados
  late final List<Figurinha> _todasFigs = [...gerarFigurinhas(), ...gerarEspeciais()];
  
  Figurinha? _getFig(int id) {
    try { return _todasFigs.firstWhere((f) => f.id == id); }
    catch (_) { return null; }
  }
  String _estadoFiltro = 'Todos';
  String _cidadeFiltro = 'Todas';

  // Calcula match entre usuário logado e outro usuário
  Map<String, dynamic> _calcularMatch(Map<String, dynamic> u) {
    final repetidas = List<int>.from(u["repetidas"] ?? []);
    final faltam    = List<int>.from(u["faltam"]    ?? []);
    final euPossoOferecer = widget.repetidas.where((id) => faltam.contains(id)).toList();
    final elePodeOferecer = repetidas.where((id) => widget.faltam.contains(id)).toList();
    final trocaPerfeita   = euPossoOferecer.isNotEmpty && elePodeOferecer.isNotEmpty;
    return { 'euPossoOferecer': euPossoOferecer, 'elePodeOferecer': elePodeOferecer, 'trocaPerfeita': trocaPerfeita };
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = _usuariosFiltrados();
    final usuariosComMatch = usuarios.map((u) => {...u, ..._calcularMatch(u)}).toList()
      ..sort((a, b) => (b['trocaPerfeita'] == true ? 1 : 0) - (a['trocaPerfeita'] == true ? 1 : 0));

    return Column(children: [
      // Filtro cidade
      _filtroBox(),

      // Aviso se falta repetidas ou faltam
      if (widget.repetidas.isEmpty || widget.faltam.isEmpty) _avisoListas(),

      // Lista
      Expanded(child: widget.repetidas.isEmpty
        ? _emptyState('🃏', 'Marque suas repetidas primeiro!')
        : usuariosComMatch.isEmpty
          ? _emptyState('😔', 'Nenhuma pessoa encontrada.')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              itemCount: usuariosComMatch.length,
              itemBuilder: (ctx, i) => _userCard(usuariosComMatch[i]),
            )
      ),
    ]);
  }

  Widget _filtroBox() => Container(
    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E1E1E))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('📍 Filtrar por cidade', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _dropDown(['Todos', 'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'], _estadoFiltro, (v) => setState(() { _estadoFiltro = v!; _cidadeFiltro = 'Todas'; }))),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: _dropDown(['Todas', ...{for (final u in _usuariosBase()) u["cidade"] as String}].toList()..sort(), _cidadeFiltro, (v) => setState(() => _cidadeFiltro = v!))),
      ]),
    ]),
  );

  Widget _avisoListas() => Container(
    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF1A1200), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF3A2D00))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('⚠️ Para trocas perfeitas você precisa de:', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w800, fontSize: 13)),
      const SizedBox(height: 10),
      _avisoItem('🃏', 'Figurinhas repetidas', 'O que você vai oferecer', widget.repetidas.isNotEmpty, widget.repetidas.length),
      const SizedBox(height: 8),
      _avisoItem('🔍', 'Figurinhas que faltam', 'O que você quer receber', widget.faltam.isNotEmpty, widget.faltam.length),
    ]),
  );

  Widget _avisoItem(String emoji, String titulo, String sub, bool ok, int count) => Row(children: [
    Text(ok ? '✅' : '❌', style: const TextStyle(fontSize: 20)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$titulo${ok ? ' ($count marcadas)' : ''}', style: TextStyle(color: ok ? const Color(0xFF00C864) : Colors.grey[600], fontWeight: FontWeight.w700, fontSize: 13)),
      Text(sub, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
    ])),
  ]);

  Widget _userCard(Map<String, dynamic> u) {
    final trocaPerfeita   = u['trocaPerfeita'] as bool? ?? false;
    final euPosso         = List<int>.from(u['euPossoOferecer'] ?? []);
    final elePode         = List<int>.from(u['elePodeOferecer'] ?? []);
    final temAlgo         = euPosso.isNotEmpty || elePode.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: trocaPerfeita ? const Color(0xFF0A140D) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: trocaPerfeita ? const Color(0xFF00C864) : const Color(0xFF1E1E1E), width: trocaPerfeita ? 1.5 : 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Badge troca perfeita
        if (trocaPerfeita) Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF003D1F), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00C864))),
          child: Row(children: [
            const Text('🎯', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(child: Text('Troca Perfeita! Vocês dois têm o que o outro precisa', style: GoogleFonts.nunito(color: const Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 12))),
          ]),
        ),

        // Usuário
        Row(children: [
          CircleAvatar(radius: 22,
            backgroundColor: trocaPerfeita ? const Color(0xFF00C864) : const Color(0xFF333333),
            child: Text((u["nome"] as String)[0], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(u["nome"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              if (trocaPerfeita) ...[
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: const Color(0xFF00C864), borderRadius: BorderRadius.circular(20)),
                  child: const Text('MATCH', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900))),
              ],
            ]),
            Text('📍 ${u["cidade"]} — ${u["estado"]}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            Text('📱 ${u["telefone"]}', style: TextStyle(color: Colors.grey[700], fontSize: 11)),
          ])),
        ]),
        const SizedBox(height: 12),

        // Figurinhas
        if (euPosso.isNotEmpty) ...[
          _tagLabel('✅ Você tem e ele(a) precisa:', const Color(0xFF00C864)),
          _tags(euPosso, const Color(0xFF00C864)),
          const SizedBox(height: 8),
        ],
        if (elePode.isNotEmpty) ...[
          _tagLabel('🔍 Ele(a) tem e você precisa:', const Color(0xFFF59E0B)),
          _tags(elePode, const Color(0xFFF59E0B)),
          const SizedBox(height: 10),
        ],
        if (!temAlgo) ...[
          _tagLabel('Repetidas dele(a):', Colors.grey),
          _tags(List<int>.from(u["repetidas"] ?? []), Colors.grey),
          const SizedBox(height: 10),
        ],

        // Botão
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: temAlgo || trocaPerfeita ? () => widget.onSolicitar({
            ...u, 'trocaPerfeita': trocaPerfeita,
            'figsDeles': elePode, 'figsMinas': euPosso,
          }) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: trocaPerfeita ? const Color(0xFF00C864) : const Color(0xFF333333),
            foregroundColor: trocaPerfeita ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: Text(
            trocaPerfeita ? '🎯 Solicitar troca perfeita!' : temAlgo ? '🤝 Solicitar troca' : 'Sem figurinhas compatíveis',
            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800)),
        )),
      ]),
    );
  }

  Widget _tagLabel(String t, Color cor) => Padding(padding: const EdgeInsets.only(bottom: 5),
    child: Text(t, style: TextStyle(fontSize: 10, color: cor, fontWeight: FontWeight.w800)));

  Widget _tags(List<int> ids, Color cor) => Wrap(spacing: 5, runSpacing: 5, children: [
    ...ids.take(4).map((id) {
      final f = _getFig(id);
      return f == null ? const SizedBox.shrink() : Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(6), border: Border.all(color: cor)),
        child: Text('${f.emoji} ${f.nome}', style: TextStyle(color: cor, fontSize: 11)));
    }),
    if (ids.length > 4) Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(6), border: Border.all(color: cor)),
      child: Text('+${ids.length - 4}', style: TextStyle(color: cor, fontSize: 11))),
  ]);

  Widget _dropDown(List<String> items, String value, Function(String?) onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF252525))),
    child: DropdownButton<String>(
      value: value, isExpanded: true, underline: const SizedBox(),
      dropdownColor: const Color(0xFF1A1A1A),
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged));

  Widget _emptyState(String icon, String msg) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(icon, style: const TextStyle(fontSize: 48)), const SizedBox(height: 12),
    Text(msg, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w700)),
  ]));

  List<Map<String, dynamic>> _usuariosBase() => [
    { 'id':'u1','nome':'Lucas Silva','telefone':'(11)99999-1234','cidade':'São Paulo','estado':'SP','repetidas':[1,5,25,61],'faltam':[2,37,49,75]},
    { 'id':'u2','nome':'Ana Oliveira','telefone':'(11)98888-5678','cidade':'São Paulo','estado':'SP','repetidas':[2,10,37,75],'faltam':[1,5,25,61]},
    { 'id':'u3','nome':'Pedro Costa','telefone':'(21)97777-9012','cidade':'Rio de Janeiro','estado':'RJ','repetidas':[3,15,49,88],'faltam':[6,12,70,100]},
    { 'id':'u4','nome':'Mariana Lima','telefone':'(31)96666-3456','cidade':'Belo Horizonte','estado':'MG','repetidas':[4,20,55,93],'faltam':[1,25,49,88]},
    { 'id':'u5','nome':'Carlos Menezes','telefone':'(41)95555-7890','cidade':'Curitiba','estado':'PR','repetidas':[6,12,33,70],'faltam':[5,61,100,120]},
    { 'id':'u6','nome':'Beatriz Santos','telefone':'(81)94444-2345','cidade':'Recife','estado':'PE','repetidas':[7,18,42,79],'faltam':[3,15,49,88]},
    { 'id':'u7','nome':'Felipe Rocha','telefone':'(51)93333-6789','cidade':'Porto Alegre','estado':'RS','repetidas':[8,22,50,85],'faltam':[2,37,75,110]},
    { 'id':'u8','nome':'Juliana Ferreira','telefone':'(85)92222-0123','cidade':'Fortaleza','estado':'CE','repetidas':[9,26,46,82],'faltam':[8,22,50,85]},
  ];

  List<Map<String, dynamic>> _usuariosFiltrados() => _usuariosBase().where((u) {
    final cOk = _cidadeFiltro == 'Todas' || u["cidade"] == _cidadeFiltro;
    final eOk = _estadoFiltro == 'Todos' || u["estado"] == _estadoFiltro;
    return cOk && eOk;
  }).toList();
}
