import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Credenciais do projeto TrocaFigurinha ───────────────────────────────────
const String supabaseUrl    = 'https://hccwvkfkfhkufgtrcoia.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjY3d2a2ZrZmhrdWZndHJjb2lhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1MDk2NjksImV4cCI6MjA5NDA4NTY2OX0.FmipxOctUWEhgZR1BoH_4fWuUmLgGyYpOzGF8ElB-RM';

// Cliente global
final supabase = Supabase.instance.client;

class SupabaseService {

  // ─── Inicializar ──────────────────────────────────────────────────────────
  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // ─── CADASTRO ─────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> cadastrar({
    required String nome,
    required String telefone,
    required String cidade,
    required String estado,
    required String senha,
  }) async {
    try {
      // Verifica se telefone já existe
      final existeList = await supabase
          .from('usuarios')
          .select('id')
          .eq('telefone', telefone);

      if (existeList.isNotEmpty) return null; // já cadastrado

      final res = await supabase
          .from('usuarios')
          .insert({
            'nome': nome,
            'telefone': telefone,
            'cidade': cidade,
            'estado': estado,
            'senha': senha,
          })
          .select()
          .single();

      return res;
    } catch (e) {
      print('ERRO CADASTRO: $e');
      return {'erro': e.toString()};
    }
  }

  // ─── LOGIN ────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> login({
    required String telefone,
    required String senha,
  }) async {
    try {
      final res = await supabase
          .from('usuarios')
          .select()
          .eq('telefone', telefone)
          .eq('senha', senha)
          .maybeSingle();

      return res;
    } catch (e) {
      return null;
    }
  }

  // ─── SALVAR REPETIDAS ─────────────────────────────────────────────────────
  static Future<void> salvarRepetidas(String usuarioId, List<int> ids) async {
    try {
      // Remove todas antigas
      await supabase
          .from('repetidas')
          .delete()
          .eq('usuario_id', usuarioId);

      // Insere novas
      if (ids.isNotEmpty) {
        await supabase.from('repetidas').insert(
          ids.map((id) => {
            'usuario_id': usuarioId,
            'figurinha_id': id,
          }).toList(),
        );
      }
    } catch (e) {
      // silencioso
    }
  }

  // ─── SALVAR FALTAM ────────────────────────────────────────────────────────
  static Future<void> salvarFaltam(String usuarioId, List<int> ids) async {
    try {
      await supabase
          .from('faltam')
          .delete()
          .eq('usuario_id', usuarioId);

      if (ids.isNotEmpty) {
        await supabase.from('faltam').insert(
          ids.map((id) => {
            'usuario_id': usuarioId,
            'figurinha_id': id,
          }).toList(),
        );
      }
    } catch (e) {
      // silencioso
    }
  }

  // ─── CARREGAR REPETIDAS ───────────────────────────────────────────────────
  static Future<List<int>> carregarRepetidas(String usuarioId) async {
    try {
      final res = await supabase
          .from('repetidas')
          .select('figurinha_id')
          .eq('usuario_id', usuarioId);

      return (res as List).map((r) => r['figurinha_id'] as int).toList();
    } catch (e) {
      return [];
    }
  }

  // ─── CARREGAR FALTAM ──────────────────────────────────────────────────────
  static Future<List<int>> carregarFaltam(String usuarioId) async {
    try {
      final res = await supabase
          .from('faltam')
          .select('figurinha_id')
          .eq('usuario_id', usuarioId);

      return (res as List).map((r) => r['figurinha_id'] as int).toList();
    } catch (e) {
      return [];
    }
  }

  // ─── BUSCAR OUTROS USUÁRIOS ───────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> buscarUsuarios(String usuarioId) async {
    try {
      final res = await supabase
          .from('usuarios')
          .select('id, nome, telefone, cidade, estado')
          .neq('id', usuarioId);

      return (res as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // ─── BUSCAR REPETIDAS DE UM USUÁRIO ──────────────────────────────────────
  static Future<List<int>> buscarRepetidas(String usuarioId) async {
    try {
      final res = await supabase
          .from('repetidas')
          .select('figurinha_id')
          .eq('usuario_id', usuarioId);

      return (res as List).map((r) => r['figurinha_id'] as int).toList();
    } catch (e) {
      return [];
    }
  }

  // ─── BUSCAR FALTAM DE UM USUÁRIO ─────────────────────────────────────────
  static Future<List<int>> buscarFaltam(String usuarioId) async {
    try {
      final res = await supabase
          .from('faltam')
          .select('figurinha_id')
          .eq('usuario_id', usuarioId);

      return (res as List).map((r) => r['figurinha_id'] as int).toList();
    } catch (e) {
      return [];
    }
  }
}
