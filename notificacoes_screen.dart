import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/dados.dart';
import '../models/figurinha.dart';
import '../models/shoppings.dart';
import '../services/pagamento_service.dart';

class NotificacoesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notifs;
  final List<int> repetidas;
  final Map<String, dynamic> usuario;
  final Function(List<Map<String, dynamic>>) onUpdate;

  const NotificacoesScreen({
    super.key,
    required this.notifs,
    required this.repetidas,
    required this.usuario,
    required this.onUpdate,
  });

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  // Sub-tela
  String _subTela = 'lista';
  int _passo = 0;

  // Troca ativa
  Map<String, dynamic>? _trocaAtiva;
  final Set<int> _figsDelas = {};
  final Set<int> _figsMinhas = {};

  // Encontro
  String _capitalEscolhida = 'São Paulo';
  String _shoppingEscolhido = '';
  String _ponto = '';
  DateTime? _data;
  TimeOfDay? _hora;

  // Pagamento
  bool _pixGerado   = false;
  bool _pixLoading  = false;
  String? _pixQrCode;
  String? _pixCopiaECola;
  String? _paymentId;
  bool _termoAceito = false;
  bool _loading = false;

  // Confirmação e avaliação
  bool _chegouEu = false;
  bool _chegouOutro = false;
  Map<String, int> _avaliacoes = {};
  int _minhaEstrela = 0;



  @override
  void dispose() {
    super.dispose();
  }

  // ─── Busca figurinha pelo id ──────────────────────────────────────────────
  late final List<Figurinha> _todasFigs = [...gerarFigurinhas(), ...gerarEspeciais()];

  Figurinha? _getFig(int id) {
    try { return _todasFigs.firstWhere((f) => f.id == id); }
    catch (_) { return null; }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  void _snack(String msg, bool ok) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w800)),
      backgroundColor: ok ? const Color(0xFF003D1F) : const Color(0xFF3D0000),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  String _tempoRel(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1)  return 'agora mesmo';
    if (d.inHours < 1)    return '${d.inMinutes}min atrás';
    if (d.inDays < 1)     return '${d.inHours}h atrás';
    return '${d.inDays}d atrás';
  }

  void _responder(String id, bool aceitar) {
    final updated = widget.notifs.map((n) {
      if (n["id"] == id) return {...n, 'status': aceitar ? 'aceita' : 'recusada'};
      return n;
    }).toList();
    widget.onUpdate(updated);
    _snack(aceitar ? '✅ Troca aceita!' : '❌ Troca recusada.', aceitar);
  }

  void _abrirFluxo(Map<String, dynamic> notif) {
    setState(() {
      _trocaAtiva = notif;
      _subTela = 'fluxo';
      _passo = 0;
      _figsDelas.clear();
      _figsMinhas.clear();
      _pixGerado = false;
      _termoAceito = false;
      _shoppingEscolhido = '';
      _ponto = '';
      _data = null;
      _hora = null;
      _chegouEu = false;
      _chegouOutro = false;
      final estado = widget.usuario['estado'] as String? ?? 'SP';
      _capitalEscolhida = estadoParaCapital[estado] ?? 'São Paulo';
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_subTela == 'confirmado') return _telaConfirmado();
    if (_subTela == 'fluxo')     return _telaFluxo();
    return _telaLista();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LISTA DE NOTIFICAÇÕES
  // ══════════════════════════════════════════════════════════════════════════
  Widget _telaLista() {
    final naoLidas = widget.notifs.where((n) => n["status"] == 'pendente').length;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Row(children: [
          Text('🔔 Notificações',
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          const Spacer(),
          if (naoLidas > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF002D16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00C864)),
              ),
              child: Text('$naoLidas nova${naoLidas > 1 ? "s" : ""}',
                  style: const TextStyle(color: Color(0xFF00C864), fontSize: 12, fontWeight: FontWeight.w800)),
            ),
        ]),
      ),
      Expanded(
        child: widget.notifs.isEmpty
            ? _emptyState('🔔', 'Nenhuma notificação ainda.')
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                itemCount: widget.notifs.length,
                itemBuilder: (ctx, i) => _notifCard(widget.notifs[i]),
              ),
      ),
    ]);
  }

  Widget _notifCard(Map<String, dynamic> n) {
    final status        = n["status"] as String;
    final isPendente    = status == 'pendente';
    final isAceita      = status == 'aceita';
    final isConf        = status == 'confirmada';
    final trocaPerfeita = n["trocaPerfeita"] as bool? ?? false;
    final criadaEm      = n["criadaEm"] as DateTime;

    final bc = isPendente
        ? const Color(0xFF00C864)
        : isAceita
            ? const Color(0xFF3B82F6)
            : isConf
                ? const Color(0xFFF59E0B)
                : const Color(0xFF333333);

    final figsDeles = ((n["figsDeles"] ?? []) as List)
        .map((id) => _getFig(id as int))
        .whereType<Figurinha>()
        .toList();
    final figsMinas = ((n["figsMinas"] ?? []) as List)
        .map((id) => _getFig(id as int))
        .whereType<Figurinha>()
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: trocaPerfeita && isPendente ? const Color(0xFF0A140D) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bc, width: trocaPerfeita && isPendente ? 2 : 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // Banner troca perfeita
        if (trocaPerfeita && isPendente)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF003D1F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00C864)),
            ),
            child: Row(children: [
              const Text('🎯', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Troca Perfeita!',
                    style: GoogleFonts.nunito(
                        color: const Color(0xFF00C864), fontWeight: FontWeight.w900, fontSize: 14)),
                Text(
                  '${(n["solicitante"] as Map)['nome'].toString().split(' ').first} '
                  'tem o que você precisa — e você tem o que ele(a) precisa! 🎉',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ])),
            ]),
          ),

        // Banner pagamento
        if (isPendente)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: trocaPerfeita ? const Color(0xFF0D1A10) : const Color(0xFF1A1200),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: trocaPerfeita ? const Color(0xFF1E3A22) : const Color(0xFF3A2D00)),
            ),
            child: Row(children: [
              const Text('💳', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: trocaPerfeita
                    ? RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                          children: [
                            const TextSpan(text: '✅ '),
                            TextSpan(
                              text: 'Match encontrado! ',
                              style: const TextStyle(
                                  color: Color(0xFF00C864), fontWeight: FontWeight.w800),
                            ),
                            const TextSpan(text: 'Confirme o encontro por apenas '),
                            const TextSpan(
                              text: 'R\$ 3,99',
                              style: TextStyle(
                                  color: Color(0xFF00C864), fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                          children: [
                            TextSpan(
                              text: '✅ ',
                              style: const TextStyle(
                                  color: Color(0xFFF59E0B), fontWeight: FontWeight.w800),
                            ),
                            TextSpan(
                              text:
                                  'Confirme por R\$ 3,99 — ${(n["solicitante"] as Map)['nome'].toString().split(' ').first}. 🎉',
                            ),
                          ],
                        ),
                      ),
              ),
            ]),
          ),

        // Cabeçalho usuário
        Row(children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: isPendente
                ? const Color(0xFF00C864)
                : isAceita
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFFF59E0B),
            child: Text(
              ((n["solicitante"] as Map)['nome'] as String).isNotEmpty
                  ? ((n["solicitante"] as Map)['nome'] as String)[0]
                  : '?',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text((n["solicitante"] as Map)['nome'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              if (trocaPerfeita && isPendente) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                      color: const Color(0xFF00C864), borderRadius: BorderRadius.circular(20)),
                  child: const Text('MATCH',
                      style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900)),
                ),
              ],
            ]),
            Text(
              '📍 ${(n["solicitante"] as Map)['cidade']} — ${(n["solicitante"] as Map)['estado']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text('📱 ${(n["solicitante"] as Map)['telefone']}',
                style: TextStyle(color: Colors.grey[700], fontSize: 11)),
            Text(_tempoRel(criadaEm),
                style: TextStyle(color: Colors.grey[800], fontSize: 10)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isPendente
                  ? const Color(0xFF002D16)
                  : isAceita
                      ? const Color(0xFF0F2744)
                      : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: bc),
            ),
            child: Text(
              isPendente ? '⏳ Pendente' : isAceita ? '✅ Aceita' : isConf ? '📅 Confirmada' : '❌ Recusada',
              style: TextStyle(color: bc, fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
        ]),
        const SizedBox(height: 12),

        // Figurinhas
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(trocaPerfeita ? '🔍 Você vai receber:' : 'Ele(a) oferece:',
                style: TextStyle(
                    fontSize: 10,
                    color: trocaPerfeita ? const Color(0xFFF59E0B) : Colors.grey[600],
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            ...figsDeles.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: trocaPerfeita ? const Color(0xFFF59E0B) : const Color(0xFF333333)),
                    ),
                    child: Text('${f.emoji} ${f.nome}',
                        style: TextStyle(
                            color: trocaPerfeita ? const Color(0xFFF59E0B) : Colors.grey[500],
                            fontSize: 11)),
                  ),
                )),
          ])),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('⇄',
                style: TextStyle(
                    color: trocaPerfeita ? const Color(0xFF00C864) : Colors.grey[700],
                    fontSize: 20)),
          ),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(trocaPerfeita ? '✅ Você vai dar:' : 'Quer das suas:',
                style: TextStyle(
                    fontSize: 10,
                    color: trocaPerfeita ? const Color(0xFF00C864) : Colors.grey[600],
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            ...figsMinas.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF00C864)),
                    ),
                    child: Text('${f.emoji} ${f.nome}',
                        style: const TextStyle(color: Color(0xFF00C864), fontSize: 11)),
                  ),
                )),
          ])),
        ]),
        const SizedBox(height: 12),

        // Botões pendente
        if (isPendente)
          Row(children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _responder(n["id"] as String, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C864),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  trocaPerfeita ? '🎯 Aceitar — R\$ 3,99' : '✅ Aceitar — R\$ 3,99',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _responder(n["id"] as String, false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('❌ Recusar', style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
              ),
            ),
          ]),

        // Botão aceita → ir para fluxo
        if (isAceita)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _abrirFluxo(n),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C864),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('🃏 Selecionar figurinhas e marcar encontro →',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: Colors.black)),
            ),
          ),

        // Confirmado
        if (isConf) ...[
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1200),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('📅 Encontro confirmado!',
                  style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 6),
              Text('🏬 ${n["shopping"] ?? ''} — ${n["capital"] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              if ((n["ponto"] ?? '').toString().isNotEmpty)
                Text('📌 ${n["ponto"]}',
                    style: const TextStyle(color: Color(0xFF00C864), fontSize: 12)),
              Text('🗓 ${n["data"] ?? ''} às ${n["hora"] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('📱 ${(n["solicitante"] as Map)['telefone']}',
                  style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
            ]),
          ),

          // Confirmação de chegada
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF252525)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('📍 Confirmação de chegada',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _chegouEu
                        ? null
                        : () {
                            setState(() => _chegouEu = true);
                            _snack(
                              '✅ ${(n["solicitante"] as Map)['nome'].toString().split(' ').first} foi notificado(a) que você chegou!',
                              true,
                            );
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: _chegouEu ? const Color(0xFF003D1F) : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: _chegouEu ? const Color(0xFF00C864) : const Color(0xFF252525)),
                      ),
                      child: Center(
                        child: Text(
                          _chegouEu ? '✅ Você chegou!' : '📍 Cheguei no shopping',
                          style: TextStyle(
                            color: _chegouEu ? const Color(0xFF00C864) : Colors.grey[600],
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: _chegouOutro ? const Color(0xFF003D1F) : const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _chegouOutro ? const Color(0xFF00C864) : const Color(0xFF1E1E1E)),
                    ),
                    child: Center(
                      child: Text(
                        _chegouOutro
                            ? '✅ ${(n["solicitante"] as Map)['nome'].toString().split(' ').first} chegou!'
                            : '⏳ Aguardando...',
                        style: TextStyle(
                          color: _chegouOutro ? const Color(0xFF00C864) : Colors.grey[700],
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ]),
              if (_chegouEu && _chegouOutro) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003D1F),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00C864)),
                  ),
                  child: const Text('🎉 Os dois chegaram! Hora de trocar as figurinhas!',
                      style: TextStyle(color: Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ],
            ]),
          ),

          // Avaliação
          if (_chegouEu && _avaliacoes[n["id"] as String] == null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF252525)),
              ),
              child: Column(children: [
                Text(
                  '⭐ Avalie ${(n["solicitante"] as Map)['nome'].toString().split(' ').first}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text('Sua avaliação ajuda outros usuários',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _minhaEstrela = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _minhaEstrela > i ? '⭐' : '☆',
                        style: TextStyle(
                            fontSize: 28,
                            color: _minhaEstrela > i ? Colors.amber : Colors.grey[700]),
                      ),
                    ),
                  )),
                ),
                if (_minhaEstrela > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    ['', '😞 Péssimo', '😕 Ruim', '😐 Ok', '😊 Bom', '🤩 Excelente!'][_minhaEstrela],
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _avaliacoes[n["id"] as String] = _minhaEstrela;
                          _minhaEstrela = 0;
                        });
                        _snack('⭐ Avaliação enviada! Obrigado.', true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C864),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Enviar avaliação ⭐ $_minhaEstrela/5',
                          style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: Colors.black)),
                    ),
                  ),
                ],
              ]),
            ),

          if (_avaliacoes[n["id"] as String] != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1A10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E3A22)),
              ),
              child: Text(
                '⭐ Você avaliou ${(n["solicitante"] as Map)['nome'].toString().split(' ').first} com ${_avaliacoes[n["id"] as String]}/5',
                style: const TextStyle(color: Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
        ],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLUXO 4 PASSOS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _telaFluxo() {
    return Column(children: [
      _stepHeader(),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 30),
        child: [
          _passo0Figurinhas(),
          _passo1Encontro(),
          _passo2Termo(),
          _passo3Pagamento(),
        ][_passo],
      )),
    ]);
  }

  Widget _stepHeader() {
    final labels = ['Figurinhas', 'Encontro', 'Termo', 'Pagamento'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      child: Row(children: [
        GestureDetector(
          onTap: () => setState(() {
            if (_passo == 0) _subTela = 'lista';
            else _passo--;
          }),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF252525)),
            ),
            child: const Center(child: Text('←', style: TextStyle(color: Colors.white, fontSize: 16))),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Passo ${_passo + 1} de 4',
              style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w700)),
          Text(labels[_passo],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
        ])),
        Row(children: List.generate(4, (i) => Container(
          width: 8, height: 8,
          margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i <= _passo ? const Color(0xFF00C864) : const Color(0xFF252525),
          ),
        ))),
      ]),
    );
  }

  // ─── Passo 0: Figurinhas ──────────────────────────────────────────────────
  Widget _passo0Figurinhas() {
    final figsDelesList = ((_trocaAtiva?['figsDeles'] ?? []) as List)
        .map((id) => _getFig(id as int))
        .whereType<Figurinha>()
        .toList();
    final minhasReps = widget.repetidas
        .map((id) => _getFig(id))
        .whereType<Figurinha>()
        .toList();

    return Column(children: [
      _secBox('🃏 Figurinhas que você vai receber:', [
        Text('Toque para selecionar', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        const SizedBox(height: 8),
        ...figsDelesList.map((f) => _figCheck(f, _figsDelas, const Color(0xFF00C864))),
      ]),
      _secBox('🃏 Suas figurinhas que você vai entregar:', [
        if (minhasReps.isEmpty)
          Text('Nenhuma repetida marcada.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12))
        else ...[
          Text('Selecione o que vai dar em troca',
              style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          const SizedBox(height: 8),
          ...minhasReps.map((f) => _figCheck(f, _figsMinhas, const Color(0xFFF59E0B))),
        ],
      ]),
      _resumoBox(),
      _btnVerde('Próximo: Marcar encontro →', () {
        if (_figsDelas.isEmpty || _figsMinhas.isEmpty) {
          _snack('Selecione ao menos 1 figurinha de cada lado!', false);
          return;
        }
        setState(() => _passo = 1);
      }),
    ]);
  }

  // ─── Passo 1: Encontro ────────────────────────────────────────────────────
  Widget _passo1Encontro() {
    final shoppings = shoppingsPorCapital[_capitalEscolhida] ?? [];
    return Column(children: [
      _secBox('🏬 Escolha o shopping', [
        _labelW('🌆 Capital'),
        _dropdownW(todasCapitais, _capitalEscolhida, (v) {
          setState(() { _capitalEscolhida = v!; _shoppingEscolhido = ''; _ponto = ''; });
        }),
        const SizedBox(height: 12),
        _labelW('🏬 Shopping'),
        ...shoppings.map((sh) => GestureDetector(
          onTap: () => setState(() { _shoppingEscolhido = sh; _ponto = ''; }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _shoppingEscolhido == sh ? const Color(0xFF002D16) : const Color(0xFF181818),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _shoppingEscolhido == sh ? const Color(0xFF00C864) : const Color(0xFF252525),
                width: 1.5,
              ),
            ),
            child: Row(children: [
              const Text('🏬', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(child: Text(sh,
                  style: TextStyle(
                    color: _shoppingEscolhido == sh ? const Color(0xFF00C864) : Colors.grey[500],
                    fontWeight: FontWeight.w700, fontSize: 13,
                  ))),
              if (_shoppingEscolhido == sh)
                const Icon(Icons.check_circle, color: Color(0xFF00C864), size: 18),
            ]),
          ),
        )),
        if (_shoppingEscolhido.isNotEmpty) ...[
          const Divider(color: Color(0xFF1E3A22), height: 24),
          _labelW('📌 Onde dentro do shopping?'),
          const SizedBox(height: 6),
          TextField(
            onChanged: (v) => setState(() => _ponto = v),
            maxLength: 80,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Ex: em frente à Renner, praça de alimentação piso 2...',
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF0A1A0F),
              counterStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1E3A22)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00C864)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          if (_ponto.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF003D1F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00C864)),
              ),
              child: Row(children: [
                const Text('📌', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('PONTO DE ENCONTRO',
                      style: TextStyle(color: Color(0xFF4A9A6A), fontSize: 9, fontWeight: FontWeight.w700)),
                  Text(_ponto,
                      style: const TextStyle(color: Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 13)),
                ])),
              ]),
            ),
        ],
      ]),
      _secBox('📅 Quando?', [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _labelW('🗓 Data'),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                  builder: (ctx, child) => Theme(data: ThemeData.dark(), child: child!),
                );
                if (d != null) setState(() => _data = d);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF252525)),
                ),
                child: Text(
                  _data == null ? 'Selecionar' : '${_data!.day}/${_data!.month}/${_data!.year}',
                  style: TextStyle(color: _data == null ? Colors.grey[700] : Colors.white, fontSize: 13),
                ),
              ),
            ),
          ])),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _labelW('⏰ Hora'),
            GestureDetector(
              onTap: () async {
                final h = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (ctx, child) => Theme(data: ThemeData.dark(), child: child!),
                );
                if (h != null) setState(() => _hora = h);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF252525)),
                ),
                child: Text(
                  _hora == null ? 'Selecionar' : _hora!.format(context),
                  style: TextStyle(color: _hora == null ? Colors.grey[700] : Colors.white, fontSize: 13),
                ),
              ),
            ),
          ])),
        ]),
      ]),
      // Caixa valor
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF001A0A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00C864)),
        ),
        child: Row(children: [
          const Text('💳', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              (_trocaAtiva?['trocaPerfeita'] as bool? ?? false)
                  ? 'Confirme o encontro por apenas R\$ 3,99'
                  : 'Você não paga nada!',
              style: const TextStyle(color: Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(
              (_trocaAtiva?['trocaPerfeita'] as bool? ?? false)
                  ? 'Match encontrado! Confirme e garanta a figurinha exata. 🎯'
                  : 'A taxa do encontro já está coberta. Só confirmar e aparecer! 🎉',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ])),
        ]),
      ),
      _btnVerde('Próximo: Termo de Ciência →', () {
        if (_shoppingEscolhido.isEmpty || _ponto.trim().isEmpty || _data == null || _hora == null) {
          _snack('Preencha shopping, ponto, data e hora!', false);
          return;
        }
        setState(() => _passo = 2);
      }),
    ]);
  }

  // ─── Passo 2: Termo ───────────────────────────────────────────────────────
  Widget _passo2Termo() {
    final tp = _trocaAtiva?['trocaPerfeita'] as bool? ?? false;
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1A10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E3A22)),
        ),
        child: Column(children: [
          const Text('📋', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text('Termo de Ciência',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.white, letterSpacing: 1)),
          const Text('Leia com atenção antes de prosseguir',
              style: TextStyle(color: Color(0xFF00C864), fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
      Container(
        height: 280,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF252525)),
        ),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final c in [
              ['💳', tp ? '1. Taxa — R\$ 3,99' : '1. Taxa de encontro',
                tp ? 'Ao confirmar um match perfeito, você paga R\$ 3,99 para garantir o encontro. Não é reembolsável.'
                   : 'Para encontros iniciados pelo usuário, a taxa cobre os custos operacionais da plataforma.'],
              ['🤝', '2. Responsabilidade', 'Ambas as partes se comprometem a comparecer no local, data e hora acordados.'],
              ['🚫', '3. Ausência', 'A plataforma não se responsabiliza pelo não comparecimento. Sem reembolso em caso de ausência.'],
              ['🏬', '4. Local', 'O encontro ocorre em shopping público. A plataforma não tem vínculo com os estabelecimentos.'],
              ['🔒', '5. Privacidade', 'Seu telefone é compartilhado apenas com quem você confirmou a troca.'],
              ['⚖️', '6. Foro', 'Regido pelo CDC (Lei 8.078/90) e Marco Civil da Internet (Lei 12.965/14).'],
            ]) ...[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c[0], style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c[1], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                  const SizedBox(height: 3),
                  Text(c[2], style: TextStyle(color: Colors.grey[600], fontSize: 11, height: 1.5)),
                ])),
              ]),
              const SizedBox(height: 14),
            ],
          ]),
        ),
      ),
      // Resumo encontro
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF252525)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('📍 $_shoppingEscolhido — $_capitalEscolhida',
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          if (_ponto.isNotEmpty)
            Text('📌 $_ponto',
                style: const TextStyle(color: Color(0xFF00C864), fontSize: 12)),
        ]),
      ),
      // Checkbox aceite
      GestureDetector(
        onTap: () => setState(() => _termoAceito = !_termoAceito),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _termoAceito ? const Color(0xFF001A0A) : const Color(0xFF111111),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _termoAceito ? const Color(0xFF00C864) : const Color(0xFF252525),
              width: 1.5,
            ),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22, height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: _termoAceito ? const Color(0xFF00C864) : const Color(0xFF444444), width: 2),
                color: _termoAceito ? const Color(0xFF00C864) : Colors.transparent,
              ),
              child: _termoAceito
                  ? const Center(child: Text('✓', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900)))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tp
                    ? 'Li e concordo. Estou ciente de que a taxa de R\$ 3,99 é de minha responsabilidade e que a plataforma não se responsabiliza pelo não comparecimento.'
                    : 'Li e concordo com o Termo de Ciência e estou ciente das condições desta plataforma.',
                style: TextStyle(
                    color: _termoAceito ? Colors.white : Colors.grey[600], fontSize: 13, height: 1.6),
              ),
            ),
          ]),
        ),
      ),
      _btnVerde(
        _termoAceito ? '✅ Aceitar e ir para o pagamento →' : 'Marque a caixa para continuar',
        _termoAceito ? () => setState(() => _passo = 3) : null,
      ),
    ]);
  }

  // ─── Passo 3: Pagamento ───────────────────────────────────────────────────
  Widget _passo3Pagamento() {
    final tp = _trocaAtiva?['trocaPerfeita'] as bool? ?? false;

    return Column(children: [
      // Card valor
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Column(children: [
          Text(tp ? 'Confirmar encontro — Match encontrado!' : 'Taxa de encontro',
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 4),
          Text('R\$ 3,99',
              style: GoogleFonts.bebasNeue(fontSize: 52, color: const Color(0xFF00C864), letterSpacing: 2)),
          Text(
            tp ? 'Sua confirmação garante a figurinha exata que você precisa! 🎯' : 'Você não paga nada — a taxa já está coberta! 🎉',
            style: TextStyle(color: Colors.grey[700], fontSize: 11, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: tp
                    ? [const Color(0xFF003D1F), const Color(0xFF004D24)]
                    : [const Color(0xFF1A0F00), const Color(0xFF2D1A00)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tp ? const Color(0xFF00C864) : const Color(0xFFF59E0B)),
            ),
            child: Text(
              tp
                  ? '"Pago menos que um pacote e garanto a figurinha exata que preciso!"'
                  : '"Minha solicitação foi aceita — o encontro está garantido!"',
              style: TextStyle(
                color: tp ? const Color(0xFF00C864) : const Color(0xFFF59E0B),
                fontSize: 13, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),

      // Pagamento via PIX (única forma)
      _secBox('💚 Pagar via Pix', [
        if (!_pixGerado && !_pixLoading)
          _btnVerde('Gerar QR Code Pix — R\$ 3,99', () async {
            setState(() => _pixLoading = true);
            final result = await PagamentoService.gerarPix(
              trocaId: _trocaAtiva?['id'] as String? ?? 'troca_${DateTime.now().millisecondsSinceEpoch}',
              emailUsuario: 'usuario@trocafigurinha.com.br',
            );
            setState(() {
              _pixLoading = false;
              if (result != null) {
                _pixGerado      = true;
                _pixQrCode      = result['qr_code'] as String?;
                _pixCopiaECola  = result['qr_code'] as String?;
                _paymentId      = result['payment_id']?.toString();
              }
            });
          })
        else if (_pixLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              CircularProgressIndicator(color: Color(0xFF00C864)),
              SizedBox(height: 10),
              Text('Gerando QR Code...', style: TextStyle(color: Color(0xFF00C864), fontSize: 12)),
            ]),
          ))
        else ...[
          if (_pixQrCode != null) ...[
            Center(child: QrImageView(
              data: _pixQrCode!,
              version: QrVersions.auto,
              size: 160,
              backgroundColor: Colors.white,
            )),
            const SizedBox(height: 10),
            Text('Escaneie com o app do seu banco',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            if (_pixCopiaECola != null)
              GestureDetector(
                onTap: () {
                  _snack('✅ Código Pix copiado!', true);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1A10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E3A22)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Pix Copia e Cola (toque para copiar):',
                        style: TextStyle(color: Color(0xFF555555), fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      _pixCopiaECola!.length > 50
                          ? '${_pixCopiaECola!.substring(0, 50)}...'
                          : _pixCopiaECola!,
                      style: const TextStyle(
                          color: Color(0xFF00C864),
                          fontWeight: FontWeight.w800,
                          fontSize: 11)),
                  ]),
                ),
              ),
          ] else ...[
            Center(child: QrImageView(
              data: 'trocafigurinha2026@pagamento.com.br',
              version: QrVersions.auto,
              size: 150,
              backgroundColor: Colors.white,
            )),
            const SizedBox(height: 8),
            const Text('trocafigurinha2026@pagamento.com.br',
                style: TextStyle(color: Color(0xFF00C864), fontWeight: FontWeight.w800, fontSize: 11),
                textAlign: TextAlign.center),
          ],
          const SizedBox(height: 10),
          const Text('✅ Após pagar, clique em confirmar abaixo',
              style: TextStyle(color: Color(0xFF00C864), fontSize: 12, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ]),

            // Rodapé segurança
      Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF252525)),
        ),
        child: Text(
          tp
              ? '🔒 Pagamento seguro. Sua confirmação garante o encontro.'
              : '🔒 Você não paga nada. O encontro já está garantido para você.',
          style: const TextStyle(color: Color(0xFF555555), fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ),

      // Botão confirmar
      _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C864)))
          : _btnVerde(
              tp ? '✅ Confirmar por R\$ 3,99' : '✅ Confirmar — R\$ 3,99',
              () async {
                setState(() => _loading = true);
                await Future.delayed(const Duration(seconds: 2));
                final updated = widget.notifs.map((n) {
                  if (n["id"] == _trocaAtiva?['id']) {
                    return {
                      ...n,
                      'status': 'confirmada',
                      'shopping': _shoppingEscolhido,
                      'capital': _capitalEscolhida,
                      'ponto': _ponto,
                      'data': '${_data!.day}/${_data!.month}/${_data!.year}',
                      'hora': _hora!.format(context),
                    };
                  }
                  return n;
                }).toList();
                widget.onUpdate(updated);
                setState(() { _loading = false; _subTela = 'confirmado'; });
              },
            ),
      const SizedBox(height: 30),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONFIRMADO
  // ══════════════════════════════════════════════════════════════════════════
  Widget _telaConfirmado() {
    final tp = _trocaAtiva?['trocaPerfeita'] as bool? ?? false;
    final nome = (_trocaAtiva?['solicitante'] as Map?)?['nome'] ?? '';
    final tel  = (_trocaAtiva?['solicitante'] as Map?)?['telefone'] ?? '';

    return Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Text('🎉', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 12),
        Text('Encontro Confirmado!',
            style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white, letterSpacing: 2)),
        const SizedBox(height: 20),
        _infoCard('📅 Detalhes', const Color(0xFF001A0A), const Color(0xFF00C864), [
          '👤 Com: $nome',
          '🏬 $_shoppingEscolhido',
          '📍 $_capitalEscolhida',
          if (_ponto.isNotEmpty) '📌 $_ponto',
          if (_data != null) '🗓 ${_data!.day}/${_data!.month}/${_data!.year} às ${_hora?.format(context) ?? ''}',
          '📱 WhatsApp: $tel',
        ]),
        _infoCard('🃏 Troca combinada', const Color(0xFF1A1200), const Color(0xFFF59E0B), [
          'Você recebe: ${_figsDelas.length} figurinha${_figsDelas.length != 1 ? "s" : ""}',
          'Você entrega: ${_figsMinhas.length} figurinha${_figsMinhas.length != 1 ? "s" : ""}',
        ]),
        _infoCard('💳 Pagamento', const Color(0xFF161616), const Color(0xFF252525), [
          '✅ Confirmado por R\$ 3,99 · Encontro garantido! 🎉',
        ]),
        const SizedBox(height: 16),
        _btnVerde('← Voltar ao início', () => setState(() { _subTela = 'lista'; _trocaAtiva = null; })),
      ]),
    ));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WIDGETS AUXILIARES
  // ══════════════════════════════════════════════════════════════════════════
  Widget _figCheck(Figurinha f, Set<int> set, Color cor) {
    final sel = set.contains(f.id);
    return GestureDetector(
      onTap: () => setState(() => sel ? set.remove(f.id) : set.add(f.id)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? cor.withValues(alpha: 0.15) : const Color(0xFF161616),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: sel ? cor : const Color(0xFF1E1E1E), width: 1.5),
        ),
        child: Row(children: [
          Text(f.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(f.nome,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
          Icon(sel ? Icons.check_circle : Icons.circle_outlined,
              color: sel ? cor : const Color(0xFF2A2A2A), size: 18),
        ]),
      ),
    );
  }

  Widget _resumoBox() => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF0D1A10),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFF1E3A22)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Resumo:', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('Você recebe: ${_figsDelas.length} figurinha${_figsDelas.length != 1 ? "s" : ""}',
          style: const TextStyle(color: Color(0xFF00C864), fontSize: 12)),
      Text('Você entrega: ${_figsMinhas.length} figurinha${_figsMinhas.length != 1 ? "s" : ""}',
          style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12)),
    ]),
  );

  Widget _secBox(String tit, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF141414),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF1E1E1E)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tit, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      const SizedBox(height: 8),
      ...children,
    ]),
  );

  Widget _infoCard(String tit, Color bg, Color border, List<String> lines) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    width: double.infinity,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tit, style: TextStyle(
          color: border == const Color(0xFF252525) ? Colors.grey[500] : border,
          fontWeight: FontWeight.w800, fontSize: 13)),
      const SizedBox(height: 6),
      ...lines.map((l) => Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(l, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          )),
    ]),
  );

  Widget _btnVerde(String label, VoidCallback? onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00C864),
        disabledBackgroundColor: const Color(0xFF00C864).withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: GoogleFonts.nunito(
          fontSize: 13, fontWeight: FontWeight.w800,
          color: onTap == null ? Colors.white54 : Colors.black)),
    )),
  );

  Widget _labelW(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(t, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w700)),
  );


  Widget _dropdownW(List<String> items, String value, Function(String?) onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFF252525)),
    ),
    child: DropdownButton<String>(
      value: items.contains(value) ? value : items.first,
      isExpanded: true, underline: const SizedBox(),
      dropdownColor: const Color(0xFF1A1A1A),
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
    ),
  );

  Widget _emptyState(String icon, String msg) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(icon, style: const TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      Text(msg, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w700)),
    ],
  ));
}
