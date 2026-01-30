# Historia de Usuario: Integración Final y Entrega del Proyecto

**Como** equipo de desarrollo,  
**quiero** tener todas las nuevas características integradas, probadas y documentadas,  
**para** entregar un proyecto profesional, escalable y con evidencia clara de trabajo colaborativo.

---

## ✅ Criterios de Aceptación (Gherkin)

### Escenario: Estabilidad e Integración
* **Dado** que todas las ramas individuales han sido integradas en la rama principal.
* **Cuando** se ejecuta la aplicación completa.
* **Entonces** deben funcionar correctamente el cambio de tema, idioma y recursos sin errores ni regresiones.

### Escenario: Matriz de combinaciones visuales
* **Dado** que el usuario alterna entre las configuraciones de la interfaz.
* **Cuando** se combinan los estados (Claro/Español, Oscuro/Español, Claro/Inglés, Oscuro/Inglés).
* **Entonces** los textos y colores deben ser legibles y coherentes en las cuatro combinaciones.

### Escenario: Evidencia de colaboración
* **Dado** que el docente o revisor accede al repositorio.
* **Cuando** consulta el historial de commits y la sección de colaboradores.
* **Entonces** debe visualizarse una participación equitativa y significativa de todos los integrantes.

### Escenario: Documentación del entregable
* **Dado** que se genera el documento final en PDF.
* **Cuando** se prepara el archivo para entrega.
* **Entonces** debe incluir: enlace al repo, capturas de tableros de tareas, historial de commits y capturas de las 4 combinaciones de UI.

---

## 🛠️ Notas Técnicas

### 🌳 Estrategia de Git (GitFlow)
* **Main/Master:** Rama de producción, solo código estable.
* **Develop:** Rama de integración para pruebas de equipo.
* **Feature branches:** `feature/*` para cada funcionalidad individual.
* **Resolución de conflictos:** No se permiten merges con conflictos pendientes.

### 🧪 Pruebas y QA
* **Manual Testing:** Verificación de flujo de usuario punta a punta.
* **Regression Testing:** Asegurar que la implementación de una característica (ej. idioma) no rompió una previa (ej. assets).

### 📄 Registro de Evidencias
* **GitHub Insights:** Uso de gráficos de contribución para validar el trabajo colaborativo.
* **Naming Conventions:** Commits descriptivos bajo el estándar de *Conventional Commits*.

---

## 🚀 Flujo de Cierre (GitHub)

1. **Feature to Develop:** Pull Requests individuales con revisión de código.
2. **Develop to Main:** Integración final tras pruebas de estabilidad.
3. **Pull Request Final:** No realizar merge a la rama principal hasta que todos los criterios de aceptación estén marcados como completados.
