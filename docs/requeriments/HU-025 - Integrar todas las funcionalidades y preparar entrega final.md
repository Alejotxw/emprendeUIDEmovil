Historia de Usuario

Como equipo de desarrollo,
quiero tener todas las nuevas características integradas, probadas y documentadas,
para entregar un proyecto profesional, escalable y con evidencia clara de trabajo colaborativo.

Criterios de Aceptación

Dado que todas las ramas individuales han sido integradas en la rama principal
Cuando se ejecuta la aplicación completa
Entonces deben funcionar correctamente el cambio de tema, el cambio de idioma y la carga de recursos sin errores ni regresiones.

Dado que el usuario prueba las combinaciones de tema e idioma
Cuando cambia entre modo claro/oscuro y español/inglés
Entonces debe visualizar la misma pantalla con textos correctos y colores legibles en las cuatro combinaciones posibles.

Dado que se revisa el repositorio del proyecto
Cuando el docente accede al repositorio
Entonces debe evidenciarse la participación de los integrantes del equipo mediante commits visibles en el historial y en la sección de colaboradores.

Dado que se prepara el entregable del proyecto
Cuando se genera el documento final en PDF
Entonces debe incluir: enlace al repositorio, capturas del tablero de tareas, evidencias de commits y colaboradores, y al menos cuatro capturas de pantalla con las combinaciones de tema e idioma.

Dado que existen conflictos o errores de integración
Cuando se realiza la integración final de las ramas
Entonces los conflictos deben resolverse antes de considerar la historia de usuario como completada, garantizando la estabilidad de la aplicación.

Notas Técnicas

Integración: Utilizar GitFlow o una estrategia de ramas basada en feature, develop y main para organizar el trabajo colaborativo.

Pruebas: Verificar manualmente y mediante pruebas básicas el funcionamiento del cambio de tema, idioma y carga de recursos en diferentes escenarios.

Documentación: Registrar evidencias del trabajo colaborativo y funcionamiento de la aplicación mediante capturas de pantalla y registros del repositorio.

Control de versiones: Garantizar que cada integrante del equipo realice commits significativos y descriptivos en su respectiva rama.

GitHub: Crear ramas feature/* por cada funcionalidad implementada y realizar Pull Requests hacia develop y posteriormente hacia main.
