# 🌍 FAMA App

Aplicación móvil desarrollada en **Flutter** que permite visualizar destinos turísticos almacenados localmente, incluyendo listado, búsqueda, detalle y mapa interactivo.

---

## 🚀 Demo funcional

La aplicación permite:

- 📍 Visualizar destinos turísticos
- 🔎 Buscar destinos en tiempo real (offline)
- 📄 Ver detalle completo del destino
- 🗺️ Visualizar ubicación en mapa (OpenStreetMap)
- 🖼️ Mostrar imágenes locales sin conexión
- 💾 Persistir datos en SQLite

---

## 🧱 Arquitectura

Se utilizó una arquitectura por capas inspirada en **Clean Architecture**, separando responsabilidades para mejorar mantenibilidad y escalabilidad:

lib/
├── core/
├── data/
│   ├── datasources/
│   │   └── local/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── store/

---

## ⚙️ Decisiones técnicas

- Flutter para desarrollo multiplataforma
- SQLite con sqflite + ffi para persistencia offline
- flutter_map con OpenStreetMap (sin API key)
- Assets locales para imágenes
- Arquitectura desacoplada por capas

---

## 🔄 Flujo de datos

UI → UseCase → Repository → DataSource → SQLite

---

## ▶️ Ejecución del proyecto

flutter pub get
flutter run

---

## 📦 Generar APK

flutter build apk

Ruta:
build/app/outputs/flutter-apk/app-release.apk

---

## 🔮 Mejoras futuras

- Manejo de estado con MobX o Riverpod
- Inyección de dependencias
- API remota
- Filtros
- Tests

---

## 👨‍💻 Autor

Jean Carlos Eleazar Morales Gutiérrez
Full Stack Developer
