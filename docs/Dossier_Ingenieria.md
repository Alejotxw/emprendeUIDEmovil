# Dossier de Ingeniería Avanzado: Proyecto EmprendeUIDEmovil

## 1. Introducción y Contexto
El proyecto **EmprendeUIDEmovil** es una plataforma tipo marketplace diseñada para la comunidad de la Universidad Internacional del Ecuador (UIDE). Su objetivo principal es centralizar y formalizar el comercio interno entre estudiantes y docentes.

### Impacto en ODS
- **ODS 8 (Trabajo Decente y Crecimiento Económico):** Fomenta la autonomía financiera de los estudiantes.
- **ODS 9 (Industria, Innovación e Infraestructura):** Implementa una infraestructura digital moderna para el intercambio comercial local.
- **ODS 4 (Educación de Calidad):** Proporciona un entorno real para la validación de habilidades profesionales.

## 2. Arquitectura del Sistema
El sistema sigue una arquitectura desacoplada para garantizar escalabilidad y mantenimiento.

### 2.1 Frontend (Móvil)
Desarrollado en **Flutter 3.x** con el lenguaje Dart.
- **Gestión de Estado:** Implementación de `Provider` para manejar servicios, carrito y roles.
- **Internacionalización:** Sistema dinámico (ES/EN) en tiempo real.

### 2.2 Backend (API REST)
Construido con **Node.js** y **Express**.
- **Autenticación:** Firebase Admin para gestión de tokens.
- **Rutas:** `/auth`, `/products`, `/notifications`, `/reportes`.

### 2.3 Infraestructura de Datos
Uso de **Firebase** (Firestore, Auth, Storage).

---

## 3. Evidencia Técnica Detallada

### 3.1 Estructura de Rutas del Backend
El backend implementa validaciones de roles en `products.routes.js`.

### 3.2 Gestión de Estado en Frontend
Uso de `MultiProvider` en `main.dart` para centralizar la lógica de negocio.

### 3.3 Evidencia de Logs (Reportes de Sistema)
**Ubicación:** `src/backend/src/reporte-sistemas/reporte_1764920074554.json`

```json
{
  "usuario": "luis",
  "modulo": "registro",
  "descripcion": "Se corrigió el flujo de validación en el formulario.",
  "version_flutter": "1.0.4",
  "version_backend": "2.2",
  "estado": "completado"
}
```

### 3.4 Evidencia de Control de Versiones (Micro-commits)
Se han generado micro-commits en la rama `audit-week` para demostrar trazabilidad.

---

## 4. Auditoría y Calidad
Se optimizó el `MaterialApp` y se mantuvo el esquema de colores institucional (UIDE Red: `0xFFC8102E`).

## 5. Conclusiones y Estado del Proyecto
El proyecto cuenta con una arquitectura sólida y profesional, con manejo de seguridad y mantenibilidad.
