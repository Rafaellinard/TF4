// ============================================================
// SERVIÇO: Pagamento com Stripe
//
// Para configurar:
// 1. Crie conta em stripe.com
// 2. Pegue sua publishable key no dashboard
// 3. Crie um backend (pode usar Supabase Edge Functions) para
//    criar o PaymentIntent e retornar o client_secret
//
// Exemplo de Edge Function no Supabase:
//   import Stripe from 'https://esm.sh/stripe@14'
//   const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY'))
//   const paymentIntent = await stripe.paymentIntents.create({
//     amount: 499, // R$ 4,99 em centavos
//     currency: 'brl',
//   })
//   return new Response(JSON.stringify({ clientSecret: paymentIntent.client_secret }))
// ============================================================
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String stripePublishableKey = 'COLE_SUA_CHAVE_STRIPE_AQUI';
// URL da sua Edge Function no Supabase:
const String backendUrl = 'https://SEU_PROJETO.supabase.co/functions/v1/criar-pagamento';

class PagamentoService {
  static void inicializar() {
    Stripe.publishableKey = stripePublishableKey;
  }

  // Pagamento com cartão via Stripe
  static Future<bool> pagarComCartao() async {
    try {
      // 1. Pede o client_secret ao backend
      final res = await http.post(Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'valor': 499, 'moeda': 'brl'}));

      final data = json.decode(res.body);
      final clientSecret = data['clientSecret'] as String;

      // 2. Mostra a tela de pagamento do Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Troca Figurinha',
          style: ThemeMode.dark,
        ),
      );

      // 3. Apresenta o sheet de pagamento
      await Stripe.instance.presentPaymentSheet();
      return true; // Pagamento ok!

    } on StripeException catch (e) {
      // Usuário cancelou ou erro no cartão
      print('Erro pagamento: ${e.error.message}');
      return false;
    } catch (e) {
      print('Erro geral: $e');
      return false;
    }
  }

  // Gerar chave Pix (integração com seu banco ou Mercado Pago)
  static Future<String> gerarChavePix() async {
    // Aqui você integra com Mercado Pago, PagSeguro, etc.
    // Por enquanto retorna uma chave fictícia para demonstração:
    await Future.delayed(const Duration(seconds: 1));
    return 'trocafigurinha2026@pagamento.com.br';
  }
}
