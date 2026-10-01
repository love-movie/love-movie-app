# love_movie

Aplicação Android desenvolvida com Flutter.

## Ambiente de desenvolvimento

O projeto é desenvolvido em um servidor Ubuntu headless acessado pelo VS Code via Remote SSH. A compilação e a execução são realizadas em um dispositivo Android físico conectado ao servidor por USB.

Para instalar e validar Flutter, Android SDK, Build-Tools, ADB e o dispositivo físico, consulte:

- [Preparação do ambiente Flutter para desenvolvimento Android](SETUP_AMBIENTE_FLUTTER.md)

## Pré-requisitos

Antes de trabalhar no projeto, confirme que os itens essenciais estão válidos:

```bash
flutter doctor -v
```

Verifique também se o dispositivo Android está disponível:

```bash
flutter devices
```

## Preparação do projeto

Obter as dependências:

```bash
flutter pub get
```

## Executar no dispositivo Android

Com o Samsung conectado ao `nucpcserver` via USB:

```bash
flutter run -d RXCW204T5GX
```

Durante a execução interativa:

- `r`: hot reload;
- `R`: hot restart;
- `q`: encerrar a execução.

## Build Android

Gerar um APK de release:

```bash
flutter build apk --release
```

O APK será criado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Estrutura inicial

```text
love_movie/
├── android/
├── lib/
│   └── main.dart
├── test/
├── pubspec.yaml
├── README.md
└── SETUP_AMBIENTE_FLUTTER.md
```

## Documentação

- [Setup técnico do ambiente Flutter e Android](docs/SETUP_AMBIENTE_FLUTTER.md)
