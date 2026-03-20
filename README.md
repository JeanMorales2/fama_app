# 🌍 FAMA App – Destinos Turísticos

Aplicación móvil desarrollada en Flutter que permite explorar destinos turísticos de Nicaragua, diseñada bajo un enfoque **offline-first**.

---

## 🚀 Funcionalidades

- 📍 Listado de destinos turísticos
- 🔎 Búsqueda local por nombre, categoría o ubicación
- 🧭 Vista de detalle con información completa
- 🗺️ Mapa interactivo (modo online)
- 📴 Mapa offline con imágenes locales
- 🎨 Categorías con colores e íconos
- 📄 Paginación local incremental (3 elementos por carga)
- 💾 Persistencia de datos con SQLite

---

## 📴 Modo Offline

La aplicación está diseñada para funcionar sin conexión a internet:

- Los datos se almacenan localmente en SQLite
- Los mapas tienen un fallback a imágenes precargadas
- La búsqueda y navegación funcionan completamente offline

---

## 🗺️ Mapa híbrido

La aplicación implementa una estrategia híbrida:

- **Online:** mapa interactivo con OpenStreetMap (`flutter_map`)
- **Offline:** imagen estática precargada con zoom (`InteractiveViewer`)

---

## 🧱 Arquitectura

Se implementa una arquitectura basada en separación de capas:

- `domain`: entidades y casos de uso
- `data`: repositorios y datasource local
- `presentation`: UI (pages/widgets)

---

## 🛠️ Tecnologías utilizadas

- Flutter
- Dart
- SQLite (`sqflite`)
- flutter_map (OpenStreetMap)
- connectivity_plus

---

## 📦 Dataset

La aplicación incluye 6 destinos turísticos:

- San Juan del Sur
- Granada
- Jinotega
- León
- Managua
- Boaco

---

## ⚙️ Ejecución

```bash
flutter pub get
flutter run
```

---

## 💡 Decisiones técnicas

- Se priorizó un enfoque **offline-first**
- No se utiliza API externa para cumplir con el requisito
- Se implementó paginación local para mejorar la escalabilidad
- Se utilizaron mapas híbridos para balancear UX y requerimientos offline

---

## 📌 Autor

Proyecto desarrollado como prueba técnica para FAMA.
