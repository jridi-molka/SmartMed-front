# SmartMed — Frontend (Flutter)

Application mobile de gestion intelligente des rendez-vous médicaux
et du temps d'attente.

## Prérequis

- Flutter SDK (voir `flutter --version`)
- Google Chrome (développement web) ou un téléphone Android
- Le Backend SmartMed lancé (dépôt Backend)

## Installation

```bash
git clone <URL-DU-DEPOT>
cd <NOM-DU-DOSSIER>
flutter pub get
```

## Lancer l'application

Sur Chrome (le Backend tourne sur `localhost:8000`) :

```bash
flutter run -d chrome
```

Sur téléphone, avec l'adresse IP du PC qui héberge le Backend :

```bash
flutter run --dart-define=API_URL=http://<IP-DU-PC>:8000
```

## Structure de `lib/`

| Dossier | Rôle |
|---|---|
| `core/constants/` | adresse et routes de l'API |
| `core/network/` | client HTTP, gestion des erreurs |
| `core/storage/` | stockage sécurisé du token |
| `models/` | classes de données (User, LoginResponse...) |
| `services/` | appels à l'API (AuthService...) |
| `screens/` | écrans de l'application |
| `widgets/` | composants réutilisables |
| `routes/` | navigation |

## Contrat API

La source de vérité est le Swagger du Backend :
`http://localhost:8000/docs`.
Si un endpoint ou un champ change, le développeur concerné prévient
l'autre avant de merger.

## Règles Git

- Ne jamais développer sur `main`.
- Une branche par fonctionnalité : `feature/flutter-...`
- Une Pull Request limitée à une fonctionnalité, testée.
- Ne jamais commiter de token, mot de passe ou fichier `.env`.

## Tests

```bash
flutter test
```