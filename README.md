# StockMate Inventory UI

A Flutter frontend prototype for a Ghanaian food business. The app uses a light canvas, white rounded cards and lavender highlights inspired by the supplied inventory dashboard references.

## Project layout

- `app/` configures `MaterialApp`, route entry and theme tokens.
- `core/` contains shared fields, cards, buttons, detail/empty-state widgets and currency formatting.
- `data/models/` and `data/mock_data/` contain the shared inventory, sale and expense records.
- `features/` separates authentication and the Dashboard, Inventory, Sales and Expenses screens and components.
- `features/shell/` owns the four-tab navigation and one in-memory copy of each list, shared by all screens.

## Run

```sh
flutter pub get
flutter run
```

Start the API in `../inventory_app_backend` before signing in. Set its address
once in the root `.env` file; the shared `ApiConfig` reads it for API requests.
The checked-in development value is `http://10.0.2.2:3000/api` for an Android
emulator. Change it for other targets:

- iOS simulator: `http://localhost:3000/api`
- Physical phone: `http://<your-computer-LAN-IP>:3000/api`
- Deployed backend: `https://test-admin.ivoenora.com/api` (or your deployed API URL)

Use HTTPS for deployed builds. The base URL is app configuration, not a secret;
do not put passwords or private API keys in `.env`.

## Features

- Dashboard totals, recent sales, restocking alerts and quick actions.
- Inventory search and status filters, item details, add/edit and quantity update flows.
- Sales history, details and validated sale entry that calculates the total and deducts inventory.
- Expense history, details, date/category entry and daily total.
- Shared Material theme and reusable cards, status tags, detail rows and form fields.

Registration and login use the backend's `/api/auth` endpoints. The JWT is kept
in platform secure storage and checked against `/api/auth/me` when the app opens;
logging out discards it. The authenticated inventory, sales, and expenses screens
still use in-memory sample data and are not connected to the API yet.

The UI uses Flutter's built-in `setState`; BLoC is not needed for this small auth
flow. It can be introduced when shared asynchronous state across the authenticated
features makes it useful.
