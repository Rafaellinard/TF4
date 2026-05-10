# 📱 Como Publicar o Troca Figurinha nas Lojas

## 🛠️ PASSO 1 — Instalar o Flutter

### No Mac (para publicar no iOS também):
```bash
# 1. Baixe o Flutter SDK em flutter.dev
# 2. Extraia e adicione ao PATH:
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Verifique a instalação:
flutter doctor
```

### No Windows (só Android):
```bash
# 1. Baixe em flutter.dev/docs/get-started/install/windows
# 2. Adicione ao PATH nas variáveis de ambiente
flutter doctor
```

---

## 🤖 PASSO 2 — Publicar na Google Play (Android)

### 2.1 — Gere o APK de release:
```bash
cd troca_figurinha
flutter build appbundle --release
# Arquivo gerado em: build/app/outputs/bundle/release/app-release.aab
```

### 2.2 — Crie a keystore (assinatura do app):
```bash
keytool -genkey -v -keystore ~/troca-figurinha.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias troca-figurinha
# Anote a senha — você vai precisar sempre!
```

### 2.3 — Configure a assinatura em android/key.properties:
```
storePassword=SUA_SENHA
keyPassword=SUA_SENHA
keyAlias=troca-figurinha
storeFile=/Users/SEU_USUARIO/troca-figurinha.jks
```

### 2.4 — Publique na Play Store:
1. Acesse play.google.com/console
2. Crie uma conta de desenvolvedor (taxa única de US$25)
3. Clique em "Criar app"
4. Vá em "Produção" > "Criar nova versão"
5. Faça upload do arquivo .aab
6. Preencha título, descrição, screenshots
7. Envie para revisão (leva 1-3 dias)

---

## 🍎 PASSO 3 — Publicar na App Store (iOS)

> ⚠️ Precisa de um Mac com Xcode instalado

### 3.1 — Conta de desenvolvedor Apple:
- Acesse developer.apple.com
- Assine o programa por US$99/ano

### 3.2 — Build para iOS:
```bash
flutter build ios --release
```

### 3.3 — Abra no Xcode:
```bash
open ios/Runner.xcworkspace
```
- Product > Archive
- Distribute App > App Store Connect
- Upload

### 3.4 — No App Store Connect (appstoreconnect.apple.com):
1. Crie o app
2. Preencha informações (nome, descrição, screenshots)
3. Selecione o build que você fez upload
4. Envie para revisão da Apple (leva 1-3 dias)

---

## 💰 PASSO 4 — Configurar Pagamento Real

### Stripe (cartão):
```bash
# No pubspec.yaml já está configurado.
# 1. Crie conta em stripe.com
# 2. Pegue suas chaves em dashboard.stripe.com/apikeys
# 3. Cole em lib/services/pagamento_service.dart
```

### Pix (Mercado Pago):
```bash
# 1. Crie conta em mercadopago.com.br
# 2. Use a API de pagamentos para gerar QR Code dinâmico
# Documentação: https://www.mercadopago.com.br/developers
```

---

## 🗄️ PASSO 5 — Banco de Dados (Supabase)

```bash
# 1. Crie conta em supabase.com
# 2. Crie novo projeto
# 3. No painel SQL, cole os comandos de lib/services/supabase_service.dart
# 4. Cole URL e chave em:
#    - lib/services/supabase_service.dart
# 5. Descomente a linha no main.dart:
#    await SupabaseService.inicializar();
```

---

## 📁 Estrutura do Projeto

```
troca_figurinha/
├── lib/
│   ├── main.dart                    # Ponto de entrada + rotas
│   ├── models/
│   │   ├── figurinha.dart           # Classes: Figurinha, Usuario, Troca
│   │   └── dados.dart               # Todas as 980 figurinhas Copa 2026
│   ├── screens/
│   │   ├── login_screen.dart        # Tela de cadastro
│   │   ├── minhas_screen.dart       # Minhas figurinhas repetidas
│   │   └── notificacoes_screen.dart # Notifs + fluxo encontro + pagamento
│   └── services/
│       ├── supabase_service.dart    # Banco de dados + tempo real
│       └── pagamento_service.dart   # Stripe + Pix
├── pubspec.yaml                     # Dependências
└── COMO_PUBLICAR.md                 # Este arquivo
```

---

## 🚀 Comandos Úteis

```bash
# Instalar dependências
flutter pub get

# Rodar no emulador
flutter run

# Build Android
flutter build appbundle --release

# Build iOS (só no Mac)
flutter build ios --release

# Verificar problemas
flutter doctor -v
```

---

## 💡 Próximos Passos Sugeridos

1. ✅ Completar a tela BuscarScreen (como o app web)
2. ✅ Integrar notificações push com Firebase
3. ✅ Adicionar foto de perfil do usuário
4. ✅ Sistema de avaliação após a troca
5. ✅ Chat entre os usuários após a troca aceita
6. ✅ Mapa para mostrar onde ficam os outros usuários
