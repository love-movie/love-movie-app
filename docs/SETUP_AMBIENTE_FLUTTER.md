# Preparação do Ambiente Flutter para Desenvolvimento Android

## 1. Objetivo

Este documento registra a preparação do ambiente utilizado para desenvolver, compilar e executar a aplicação Flutter `love_movie` em um dispositivo Android físico.

O ambiente foi configurado sem Android Studio e sem emulador. A compilação ocorre em um servidor Linux headless, e o aplicativo é executado em um celular conectado diretamente ao servidor por USB.

Este documento não é o README funcional da aplicação. O README principal do projeto deve referenciá-lo como documentação técnica do ambiente.

## 2. Arquitetura do ambiente

```text
Notebook
   |
   | Remote Desktop Connection
   v
PC Windows 253
   |
   | VS Code + Remote SSH
   v
nucpcserver
Ubuntu 24.04.5 LTS headless
   |
   | USB + ADB
   v
Samsung SM-A536E
Android 16, API 36
```

O código-fonte fica no `nucpcserver` e é editado remotamente pelo VS Code. O Flutter também é executado no `nucpcserver`, que compila e instala a aplicação no celular por meio do ADB.

## 3. Ambiente validado

- Ubuntu 24.04.5 LTS, Noble Numbat
- Kernel Linux 6.8.0-142-generic x86_64
- Servidor headless
- Flutter 3.47.5, canal stable
- Dart 3.13.4
- DevTools 2.60.0
- OpenJDK 17.0.20.1
- Android SDK em `~/Android/Sdk`
- Android SDK Platform 36
- Android SDK Build-Tools 37.0.0
- Android SDK Platform-Tools 37.0.1
- Android SDK Command-line Tools 23.0.0
- Samsung SM-A536E, Android 16, API 36, arquitetura arm64

## 4. Pré-requisitos do sistema

Atualizar os índices do APT e instalar as ferramentas necessárias:

```bash
sudo apt update

sudo apt install \
  curl \
  git \
  wget \
  unzip \
  zip \
  xz-utils \
  libglu1-mesa \
  openjdk-17-jdk \
  adb \
  -y
```

Validar o Java:

```bash
java -version
```

## 5. Preparação do dispositivo Android

### 5.1. Ativar as opções do desenvolvedor

No celular:

1. Abrir **Configurações**.
2. Acessar **Sobre o telefone**.
3. Acessar **Informações do software**.
4. Tocar sete vezes em **Número da versão**.

### 5.2. Ativar a depuração USB

No celular:

1. Abrir **Configurações**.
2. Acessar **Opções do desenvolvedor**.
3. Ativar **Depuração USB**.

### 5.3. Validar a detecção USB no Linux

Com o celular conectado ao `nucpcserver`:

```bash
lsusb
```

Dispositivo identificado durante o setup:

```text
Samsung Electronics Co., Ltd Galaxy series, misc. (MTP mode)
```

Validar o acesso via ADB:

```bash
adb devices
```

Resultado obtido:

```text
List of devices attached
RXCW204T5GX    device
```

Na primeira conexão, é necessário autorizar a depuração USB na tela do celular.

## 6. Instalação do Flutter

### 6.1. Criar o diretório de ferramentas

```bash
mkdir -p ~/tools
cd ~/tools
```

### 6.2. Baixar o Flutter

Versão utilizada neste ambiente: `3.47.5`.

```bash
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.5-stable.tar.xz
```

### 6.3. Extrair o Flutter

```bash
tar xf flutter_linux_3.47.5-stable.tar.xz
```

### 6.4. Adicionar o Flutter ao PATH

Adicionar ao arquivo `~/.bashrc`:

```bash
export PATH="$PATH:$HOME/tools/flutter/bin"
```

Recarregar a configuração:

```bash
source ~/.bashrc
```

### 6.5. Validar o Flutter

```bash
flutter --version
```

Resultado validado:

```text
Flutter 3.47.5
Dart 3.13.4
DevTools 2.60.0
```

Opcionalmente, desabilitar a telemetria:

```bash
flutter --disable-analytics
```

## 7. Instalação do Android SDK em ambiente headless

### 7.1. Criar o diretório do SDK

```bash
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk
```

### 7.2. Baixar o Android SDK Command-line Tools

Pacote utilizado durante o setup:

```bash
wget https://dl.google.com/android/repository/commandlinetools-linux-16111833_latest.zip
```

### 7.3. Extrair e organizar os Command-line Tools

```bash
mkdir -p cmdline-tools
unzip commandlinetools-linux-16111833_latest.zip -d cmdline-tools
mv cmdline-tools/cmdline-tools cmdline-tools/latest
```

A estrutura resultante deve conter:

```text
~/Android/Sdk/
└── cmdline-tools/
    └── latest/
        ├── bin/
        ├── lib/
        └── source.properties
```

## 8. Variáveis de ambiente do Android SDK

Adicionar ao arquivo `~/.bashrc`:

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
```

Recarregar a configuração:

```bash
source ~/.bashrc
```

Validar os Command-line Tools:

```bash
sdkmanager --version
```

> Na versão usada neste ambiente, o `sdkmanager` informa que está obsoleto e delega a execução ao novo Android CLI. Isso não impediu a instalação dos componentes necessários.

## 9. Instalação dos componentes do Android SDK

Instalar o Platform-Tools:

```bash
sdkmanager "platform-tools"
```

Instalar a plataforma Android 36:

```bash
sdkmanager "platforms;android-36"
```

Instalar o Build-Tools 37.0.0:

```bash
sdkmanager "build-tools;37.0.0"
```

O Build-Tools é obrigatório. Sem ele, o Flutter pode localizar o diretório do SDK, mas ainda considerar a plataforma Android inválida.

Aceitar as licenças:

```bash
yes | sdkmanager --licenses
```

Listar os componentes instalados:

```bash
sdkmanager --list_installed
```

## 10. Configuração do SDK no Flutter

Informar explicitamente ao Flutter a localização do Android SDK:

```bash
flutter config --android-sdk "$HOME/Android/Sdk"
```

Verificar a configuração:

```bash
flutter config --list
```

## 11. Resolução do aviso de múltiplos binários ADB

Durante a validação, o Flutter encontrou dois binários:

```text
~/Android/Sdk/platform-tools/adb
/usr/lib/android-sdk/platform-tools/adb
```

A versão localizada dentro do Android SDK configurado foi mantida como principal. Verificar todas as ocorrências:

```bash
type -a adb
```

Verificar qual será executada:

```bash
which adb
```

Resultado esperado:

```text
~/Android/Sdk/platform-tools/adb
```

Se o ADB fornecido pelos pacotes do Ubuntu não for mais necessário, identificar os pacotes relacionados antes da remoção:

```bash
dpkg -l | grep -E 'adb|android-sdk-platform-tools'
```

Depois de ajustar ou remover a instalação duplicada, limpar o cache de resolução de comandos do shell:

```bash
hash -r
```

## 12. Validação final do ambiente

Executar:

```bash
flutter doctor -v
```

Para desenvolvimento Android, os itens essenciais devem estar válidos:

```text
[✓] Flutter
[✓] Android toolchain
[✓] Connected device
[✓] Network resources
```

Em um servidor headless dedicado ao desenvolvimento Android, os avisos relativos ao Chrome e ao toolchain de Linux Desktop podem ser ignorados, desde que não haja intenção de desenvolver para Web ou Linux Desktop nesse servidor.

## 13. Verificação do dispositivo pelo Flutter

```bash
flutter devices
```

Resultado validado:

```text
SM A536E (mobile) • RXCW204T5GX • android-arm64 • Android 16 (API 36)
Linux (desktop)   • linux       • linux-x64     • Ubuntu 24.04.5 LTS
```

## 14. Criação e execução da aplicação `love_movie`

Criar o diretório de projetos, se necessário:

```bash
mkdir -p ~/projetos
cd ~/projetos
```

Criar a aplicação:

```bash
flutter create love_movie
```

Entrar no projeto:

```bash
cd love_movie
```

Executar no celular conectado:

```bash
flutter run -d RXCW204T5GX
```

Como existe também um destino Linux listado, o parâmetro `-d RXCW204T5GX` elimina ambiguidade e seleciona explicitamente o celular.

Durante a execução interativa:

- `r`: hot reload;
- `R`: hot restart;
- `q`: encerrar o `flutter run`.

## 15. Comandos úteis

Verificar a versão do Flutter:

```bash
flutter --version
```

Diagnosticar o ambiente:

```bash
flutter doctor -v
```

Listar dispositivos:

```bash
flutter devices
```

Listar dispositivos ADB:

```bash
adb devices
```

Listar componentes Android instalados:

```bash
sdkmanager --list_installed
```

Atualizar dependências do projeto:

```bash
flutter pub get
```

Executar a aplicação no Samsung:

```bash
flutter run -d RXCW204T5GX
```

Gerar um APK de release:

```bash
flutter build apk --release
```

## 16. Observações de manutenção

- O nome `love_movie` segue a convenção de projetos Dart e Flutter, usando letras minúsculas e sublinhado.
- Ao atualizar Flutter, Android SDK, Platform-Tools ou Build-Tools, atualizar também as versões registradas neste documento.
- Não é necessário instalar Android Studio neste ambiente headless.
- Não é necessário configurar emulador, pois os testes são realizados em um dispositivo físico via USB.
- O Android SDK e o Flutter foram instalados no diretório pessoal do usuário, evitando dependência de uma interface gráfica.
