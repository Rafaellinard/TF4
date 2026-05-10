// ============================================================
// SERVIÇO: Supabase (Banco de dados + Tempo real)
//
// Para configurar:
// 1. Crie conta em supabase.com
// 2. Cole sua URL e chave anon abaixo
// 3. No painel SQL do Supabase, execute:
//
//   create table usuarios (
//     id uuid primary key default gen_random_uuid(),
//     nome text not null,
//     cidade text not null,
//     estado text not null,
//     created_at timestamp default now()
//   );
//   create table repetidas (
//     id uuid primary key default gen_random_uuid(),
//     usuario_id uuid references usuarios(id) on delete cascade,
//     figurinha_id integer not null,
//     unique(usuario_id, figurinha_id)
//   );
//   create table trocas (
//     id uuid primary key default gen_random_uuid(),
//     solicitante_id uuid references usuarios(id),
//     receptor_id    uuid references usuarios(id),
//     status text default 'pendente',
//     figurinhas_solicitante integer[],
//     figurinhas_receptor    integer[],
//     encontro_local text,
//     encontro_data  timestamp,
//     created_at timestamp default now()
//   );
//   alter publication supabase_realtime add table trocas;
// ============================================================
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/figurinha.dart';

const String supabaseUrl = 'COLE_SUA_URL_AQUI';
const String supabaseAnonKey = 'COLE_SUA_CHAVE_AQUI';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  // Inicializa o Supabase (chamar no main.dart)
  static Future<void> inicializar() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  // ---- USUÁRIOS ----
  static Future<Usuario> cadastrarUsuario({
    required String nome,
    required String cidade,
    required String estado,
  }) async {
    final res = await supabase
        .from('usuarios')
        .insert({'nome': nome, 'cidade': cidade, 'estado': estado})
        .select()
        .single();
    return Usuario(id: res['id'], nome: res['nome'], cidade: res['cidade'], estado: res['estado']);
  }

  static Future<List<Usuario>> buscarUsuarios({String? cidade, String? estado}) async {
    var query = supabase.from('usuarios').select('*, repetidas(figurinha_id)');
    if (cidade != null) query = query.eq('cidade', cidade) as dynamic;
    if (estado != null) query = query.eq('estado', estado) as dynamic;
    final res = await query;
    return (res as List).map((u) => Usuario(
      id: u['id'], nome: u['nome'], cidade: u['cidade'], estado: u['estado'],
      repetidas: (u['repetidas'] as List).map<int>((r) => r['figurinha_id'] as int).toList(),
    )).toList();
  }

  // ---- FIGURINHAS REPETIDAS ----
  static Future<void> adicionarRepetida(String usuarioId, int figurinhaId) async {
    await supabase.from('repetidas').upsert({
      'usuario_id': usuarioId, 'figurinha_id': figurinhaId,
    });
  }

  static Future<void> removerRepetida(String usuarioId, int figurinhaId) async {
    await supabase.from('repetidas')
        .delete()
        .eq('usuario_id', usuarioId)
        .eq('figurinha_id', figurinhaId);
  }

  static Future<List<int>> buscarRepetidas(String usuarioId) async {
    final res = await supabase.from('repetidas').select('figurinha_id').eq('usuario_id', usuarioId);
    return (res as List).map<int>((r) => r['figurinha_id'] as int).toList();
  }

  // ---- TROCAS ----
  static Future<void> solicitarTroca({
    required String solicitanteId,
    required String receptorId,
    required List<int> figurinhasSolicitante,
    required List<int> figurinhasReceptor,
  }) async {
    await supabase.from('trocas').insert({
      'solicitante_id': solicitanteId,
      'receptor_id': receptorId,
      'status': 'pendente',
      'figurinhas_solicitante': figurinhasSolicitante,
      'figurinhas_receptor': figurinhasReceptor,
    });
  }

  static Future<void> responderTroca(String trocaId, bool aceitar) async {
    await supabase.from('trocas').update({'status': aceitar ? 'aceita' : 'recusada'}).eq('id', trocaId);
  }

  static Future<void> confirmarEncontro({
    required String trocaId,
    required String local,
    required DateTime dataHora,
  }) async {
    await supabase.from('trocas').update({
      'status': 'confirmada',
      'encontro_local': local,
      'encontro_data': dataHora.toIso8601String(),
    }).eq('id', trocaId);
  }

  // ---- TEMPO REAL: escuta novas trocas ----
  static RealtimeChannel escutarTrocas(String usuarioId, Function(Map) onNova) {
    return supabase.channel('trocas_$usuarioId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'trocas',
          filter: PostgresChangeFilter(type: FilterType.eq, column: 'receptor_id', value: usuarioId),
          callback: (payload) => onNova(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'trocas',
          filter: PostgresChangeFilter(type: FilterType.eq, column: 'solicitante_id', value: usuarioId),
          callback: (payload) => onNova(payload.newRecord),
        )
        .subscribe();
  }
}
