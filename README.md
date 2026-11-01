# Animal Production Data Explorer

This Flutter application presents data about animal production in the United States. Its dashboard summarizes the dataset and highlights leading states and products. Additional views show production on a map, yearly record counts, related-product association rules, and production by state and year.

The app is written in Dart with Flutter (Dart SDK constraint: `^3.5.4`). Flutter platform projects are present for Android, iOS, web, macOS, Windows, and Linux.

## Requirements

- Flutter SDK with Dart 3.5.4 or later (within the Dart 3.x release line).
- The companion data API, when using data-backed views. The frontend calls `http://127.0.0.1:8000`; that address is hard-coded in the app. The API server is not included in this repository.
- Network access to OpenStreetMap tile servers for map tiles.

Because the API address uses loopback, it refers to the device running the app. For an emulator, phone, or remote deployment, the API address may need to be changed to a host reachable from that device.

## Run locally

```sh
git clone https://github.com/stefaano19/big-data-dashboard-client.git
cd big-data-dashboard-client
flutter pub get
flutter run
```

Choose a connected device or simulator with `flutter devices` if Flutter does not select a target automatically.

## Backend API

The frontend currently requests these routes from `http://127.0.0.1:8000`:

| Route | Used for |
| --- | --- |
| `/tot_rows` | Dataset row count |
| `/tot_columns` | Dataset column count |
| `/source` | Census and survey counts |
| `/top_state` | Leading state and its coordinates/count |
| `/top_products` | Most frequent products |
| `/data_years` | Record counts by year |
| `/association_rules` | Related-product association rules |
| `/production_by_state_year?year=...&state=...` | Production by selected state and year |
| `/production_state?state=...` | Map query for a state |
| `/production_states?product=...` | Map query for a product |

These routes document the frontend's current requests; the backend implementation and its setup are outside this repository.

## Check the project

```sh
flutter analyze
flutter test
```

The checked-in widget test is still Flutter's starter counter test and does not currently describe this application's UI.
