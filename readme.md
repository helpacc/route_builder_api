# Route builder API

Микросервис на Sinatra, взаимодействующий с Google Directions API для определения приблизительной стоимости и продолжительности поездки.

## Запуск

```
cd route_builder_api
bundle
echo "GOOGLE_API_KEY=YOUR_API_KEY" > .env
rake # прогон тестов
puma
```

По умолчанию сервер запустится на 8000м порту.
