import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final Function(String nome, String telefone, String cidade, String estado) onLogin;
  const LoginScreen({super.key, required this.onLogin});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Tela: splash | login | cadastro
  String _tela = 'splash';

  // Controllers login
  final _loginTelCtrl   = TextEditingController();
  final _loginSenhaCtrl = TextEditingController();

  // Controllers cadastro
  final _cadNomeCtrl   = TextEditingController();
  final _cadTelCtrl    = TextEditingController();
  final _cadCidadeCtrl = TextEditingController();
  final _cadSenhaCtrl  = TextEditingController();
  final _cadConfCtrl   = TextEditingController();
  String _estado = 'CE';

  bool _loading = false;
  bool _mostrarSenha = false;
  String? _erro;

  // Banco local simulado
  final List<Map<String, dynamic>> _contas = [
    {
      'nome': 'Ana Oliveira',
      'tel': '(11)98888-5678',
      'cidade': 'São Paulo',
      'estado': 'SP',
      'senha': '1234',
    }
  ];

  static const _estados = [
    'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
    'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
    'RS','RO','RR','SC','SP','SE','TO'
  ];

  String _fmtTel(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.length <= 2)  return '($d';
    if (d.length <= 7)  return '(${d.substring(0,2)})${d.substring(2)}';
    if (d.length <= 11) return '(${d.substring(0,2)})${d.substring(2,7)}-${d.substring(7)}';
    return '(${d.substring(0,2)})${d.substring(2,7)}-${d.substring(7,11)}';
  }

  void _showErro(String msg) => setState(() => _erro = msg);

  void _login() async {
    setState(() => _erro = null);
    if (_loginTelCtrl.text.isEmpty || _loginSenhaCtrl.text.isEmpty) {
      _showErro('Preencha telefone e senha!'); return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    final conta = _contas.firstWhere(
      (c) => c['tel'] == _loginTelCtrl.text && c['senha'] == _loginSenhaCtrl.text,
      orElse: () => {},
    );
    if (conta.isEmpty) {
      setState(() { _loading = false; _erro = 'Telefone ou senha incorretos!'; });
      return;
    }
    setState(() => _loading = false);
    widget.onLogin(conta['nome'], conta['tel'], conta['cidade'], conta['estado']);
  }

  void _cadastrar() async {
    setState(() => _erro = null);
    if (_cadNomeCtrl.text.trim().isEmpty || _cadTelCtrl.text.isEmpty || _cadCidadeCtrl.text.trim().isEmpty) {
      _showErro('Preencha todos os campos!'); return;
    }
    if (_cadTelCtrl.text.replaceAll(RegExp(r'\D'), '').length < 10) {
      _showErro('Telefone inválido!'); return;
    }
    if (_cadSenhaCtrl.text.length < 4) {
      _showErro('Senha deve ter ao menos 4 caracteres!'); return;
    }
    if (_cadSenhaCtrl.text != _cadConfCtrl.text) {
      _showErro('As senhas não coincidem!'); return;
    }
    if (_contas.any((c) => c['tel'] == _cadTelCtrl.text)) {
      _showErro('Telefone já cadastrado! Faça login.'); return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    final nova = {
      'nome': _cadNomeCtrl.text.trim(),
      'tel': _cadTelCtrl.text,
      'cidade': _cadCidadeCtrl.text.trim(),
      'estado': _estado,
      'senha': _cadSenhaCtrl.text,
    };
    _contas.add(nova);
    setState(() => _loading = false);
    widget.onLogin(nova['nome']!, nova['tel']!, nova['cidade']!, nova['estado']!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 30),

            // ===== SPLASH =====
            if (_tela == 'splash') ...[
              const Text('⚽', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text('Troca Figurinha',
                  style: GoogleFonts.bebasNeue(fontSize: 36, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 4),
              const Text('Copa do Mundo 2026',
                  style: TextStyle(color: Color(0xFF00C864), fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text('Encontre pessoas para trocar suas\nfigurinhas repetidas na sua cidade!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.7)),
              const SizedBox(height: 20),
              // Stats
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E1E1E)),
                ),
                child: Row(children: [
                  for (final item in [
                    ['980', 'figurinhas'],
                    ['48', 'seleções'],
                    ['🎯', 'match certo'],
                    ['R\$3,99', 'encontro']
                  ])
                    Expanded(child: Column(children: [
                      const SizedBox(height: 10),
                      Text(item[0], style: GoogleFonts.bebasNeue(
                          fontSize: 16, color: const Color(0xFF00C864), letterSpacing: 1)),
                      Text(item[1], style: TextStyle(
                          fontSize: 9, color: Colors.grey[700], fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                    ])),
                ]),
              ),
              const SizedBox(height: 20),
              _btnVerde('Entrar na minha conta →', () => setState(() { _tela = 'login'; _erro = null; })),
              const SizedBox(height: 8),
              _btnCinza('Criar conta grátis', () => setState(() { _tela = 'cadastro'; _erro = null; })),
              const SizedBox(height: 16),
              Text('🔒 Suas figurinhas ficam salvas sempre que você entrar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700])),
            ],

            // ===== LOGIN =====
            if (_tela == 'login') ...[
              const Text('🔐', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 10),
              Text('Entrar', style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text('Bem-vindo de volta! Suas figurinhas estão te esperando.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 24),

              _label('📱 WhatsApp / Telefone'),
              TextField(
                controller: _loginTelCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                onChanged: (v) {
                  final fmt = _fmtTel(v);
                  _loginTelCtrl.value = _loginTelCtrl.value.copyWith(
                    text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
                },
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _dec('(00)99999-9999'),
              ),
              const SizedBox(height: 12),

              _label('🔒 Senha'),
              TextField(
                controller: _loginSenhaCtrl,
                obscureText: !_mostrarSenha,
                onSubmitted: (_) => _login(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _dec('Sua senha').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_mostrarSenha ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600]),
                    onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dica demo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1200),
                  border: Border.all(color: const Color(0xFF3A2D00)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const Text('🧪', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Conta demo para testar:',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w800, fontSize: 12)),
                    Text('Tel: (11)98888-5678  ·  Senha: 1234',
                        style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),

              if (_erro != null) _erroBox(_erro!),
              _btnVerde(_loading ? 'Entrando...' : 'Entrar →', _loading ? null : _login),
              const SizedBox(height: 12),
              _divisor('não tem conta?'),
              const SizedBox(height: 12),
              _btnCinza('Criar conta grátis', () => setState(() { _tela = 'cadastro'; _erro = null; })),
              const SizedBox(height: 8),
              _voltarBtn(),
            ],

            // ===== CADASTRO =====
            if (_tela == 'cadastro') ...[
              const Text('📝', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 10),
              Text('Criar Conta', style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text('Gratuito! Suas figurinhas ficam salvas para sempre.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 24),

              _label('👤 Nome completo'),
              _input(_cadNomeCtrl, 'Seu nome completo'),
              const SizedBox(height: 12),

              _label('📱 WhatsApp (será seu login)'),
              TextField(
                controller: _cadTelCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                onChanged: (v) {
                  final fmt = _fmtTel(v);
                  _cadTelCtrl.value = _cadTelCtrl.value.copyWith(
                    text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
                },
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _dec('(00)99999-9999'),
              ),
              const SizedBox(height: 12),

              Row(children: [
                Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('📍 Cidade'),
                  _input(_cadCidadeCtrl, 'Sua cidade'),
                ])),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('Estado'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF252525)),
                    ),
                    child: DropdownButton<String>(
                      value: _estado,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF1A1A1A),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      items: _estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _estado = v!),
                    ),
                  ),
                ])),
              ]),
              const SizedBox(height: 12),

              _label('🔒 Criar senha'),
              TextField(
                controller: _cadSenhaCtrl,
                obscureText: !_mostrarSenha,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _dec('Mínimo 4 caracteres').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_mostrarSenha ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600]),
                    onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                ),
              ),
              // Barra força senha
              if (_cadSenhaCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: List.generate(4, (i) => Expanded(child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _cadSenhaCtrl.text.length >= (i + 1) * 2
                        ? (_cadSenhaCtrl.text.length >= 8 ? const Color(0xFF00C864) : const Color(0xFFF59E0B))
                        : const Color(0xFF252525),
                  ),
                )))),
                const SizedBox(height: 4),
                Text(
                  _cadSenhaCtrl.text.length < 4 ? 'Muito curta' :
                  _cadSenhaCtrl.text.length < 8 ? 'Razoável' : '✅ Senha forte!',
                  style: TextStyle(
                    fontSize: 10,
                    color: _cadSenhaCtrl.text.length >= 8
                        ? const Color(0xFF00C864)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ],
              const SizedBox(height: 12),

              _label('🔒 Confirmar senha'),
              TextField(
                controller: _cadConfCtrl,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _dec('Repita a senha').copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: _cadConfCtrl.text.isEmpty
                        ? const Color(0xFF252525)
                        : _cadConfCtrl.text == _cadSenhaCtrl.text
                            ? const Color(0xFF00C864)
                            : Colors.redAccent),
                  ),
                ),
              ),
              if (_cadConfCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _cadConfCtrl.text == _cadSenhaCtrl.text ? '✅ Senhas conferem!' : '❌ As senhas não coincidem',
                  style: TextStyle(
                    fontSize: 10,
                    color: _cadConfCtrl.text == _cadSenhaCtrl.text
                        ? const Color(0xFF00C864)
                        : Colors.redAccent,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              if (_erro != null) _erroBox(_erro!),
              _btnVerde(_loading ? 'Criando conta...' : 'Criar conta e entrar →',
                  _loading ? null : _cadastrar),
              const SizedBox(height: 12),
              _divisor('já tem conta?'),
              const SizedBox(height: 12),
              _btnCinza('Fazer login', () => setState(() { _tela = 'login'; _erro = null; })),
              const SizedBox(height: 8),
              _voltarBtn(),
            ],

            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  // ===== HELPERS =====
  Widget _label(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(t, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w700)),
    ),
  );

  Widget _input(TextEditingController c, String hint) => TextField(
    controller: c,
    style: const TextStyle(color: Colors.white, fontSize: 13),
    decoration: _dec(hint),
  );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
    filled: true,
    fillColor: const Color(0xFF1A1A1A),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF252525))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF252525))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00C864))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  Widget _btnVerde(String label, VoidCallback? onTap) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00C864),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
    ),
  );

  Widget _btnCinza(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[500],
        side: BorderSide(color: Colors.grey[800]!),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
    ),
  );

  Widget _voltarBtn() => TextButton(
    onPressed: () => setState(() { _tela = 'splash'; _erro = null; }),
    child: Text('← Voltar', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
  );

  Widget _divisor(String texto) => Row(children: [
    const Expanded(child: Divider(color: Color(0xFF252525))),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(texto, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
    ),
    const Expanded(child: Divider(color: Color(0xFF252525))),
  ]);

  Widget _erroBox(String msg) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFF1A0000),
      border: Border.all(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
    ]),
  );
}
