# ChuChu

ChuChu is a decentralized content subscription platform based on the Nostr protocol, with a built-in custodial Lightning wallet, supporting subscription payments to creators through the Lightning Network.

## ChuChu Backend

- **ChuChu Relay**: [chuchu-relay](https://github.com/nsnjx/chuchu-relay) - Based on [relay29](https://github.com/fiatjaf/relay29), enhanced with paid subscription group content functionality
- **LNbits**: [lnbits](https://github.com/nsnjx/lnbits) - Custodial Lightning wallet service

## ChuChu Frontend

- **iOS & Android**: [chuchu](https://github.com/nsnjx/chuchu) - Mobile application (current repository)
- **Web Client**: Planned

## Features

### Implemented Features

- **Nostr Account Login** - Support for Nostr key login and Amber login
- **Built-in Custodial Lightning Wallet** - Integrated Lightning Network wallet with Lightning payment support
- **Follow List** - Manage creators you follow
- **Comment Feature** - Comment and interact with posts
- **Content Browsing** - Browse timeline
- **Search Function** - Search creators
- **Subscription Feature** - Subscribe to creator content
- **Group Feature** - Join and manage Nostr groups
- **Wallet Management** - View transaction history and manage wallet

### Development Roadmap

- [ ] Support for Apple, Google, and X login
- [ ] Content Grouping: Posts can be categorized as public, subscriber-only, or custom groups
- [ ] Draft Management
- [ ] Tipping Feature: Support tipping with built-in wallet
- [ ] iOS Version Support
- [ ] Direct Messages (DM) with video chat support
- [ ] Enhanced Search: Search by creator name, tags, and topics
- [ ] Recommendations: Display trending and popular creators
- [ ] Tags: Category tags to help discover content
- [ ] Push Notifications: In-app push notifications
- [ ] Web Version

## Getting Started

### Requirements

- Flutter SDK 3.7.0 or higher

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/chuchu-app.git
cd chuchu-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code (if needed)
```bash
flutter pub run build_runner build
```

4. Run the application
```bash
# Android
flutter run

# iOS
flutter run -d ios
```

### Building

#### Android
```bash
flutter build apk
# Or build App Bundle
flutter build appbundle
```

#### iOS
```bash
flutter build ios
```

## Development

### Code Style

The project uses `flutter_lints` for code linting. Please ensure you follow Dart code style guidelines.

### Contributing

Contributions are welcome! Please feel free to submit an Issue or Pull Request.

## License

MIT License

## Contact

- **GitHub**: [@nsnjx](https://github.com/nsnjx)
- **Nostr**: `npub1epcg7dqvcpe2qqr0mnrqe26v88gjz426gmzzupe6f5r09c8lca0sl2e92e`
