import 'dart:convert';
import 'package:http/http.dart' as http;
import 'supabase_service.dart';

class PagamentoService {

  // URL da Edge Function
  static const String _funcUrl =
      'https://hccwvkfkfhkufgtrcoia.supabase.co/functions/v1/criar-pagamento';

  // ─── Gerar pagamento Pix ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> gerarPix({
    required String trocaId,
    required String emailUsuario,
    double valor = 3.99,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_funcUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $supabaseAnonKey',
        },
        body: jsonEncode({
          'troca_id': trocaId,
          'email_usuario': emailUsuario,
          'valor': valor,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'qr_code': data['qr_code'],
          'qr_code_base64': data['qr_code_base64'],
          'payment_id': data['payment_id'],
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ─── Verificar status do pagamento ────────────────────────────────────────
  static Future<bool> verificarPagamento(String paymentId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://hccwvkfkfhkufgtrcoia.supabase.co/functions/v1/verificar-pagamento?id=$paymentId'),
        headers: {
          'Authorization': 'Bearer $supabaseAnonKey',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'approved';
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
