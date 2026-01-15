Característica: Desacoplamiento de acceso a datos mediante repositorios
  Como desarrollador del sistema
  Quiero desacoplar la base de datos de la interfaz de usuario mediante repositorios
  Para mantener un código limpio y fácilmente testeable

  Escenario 1: Creación de modelos de datos
    Dado que existen entidades del dominio definidas
    Cuando se implementan los modelos de datos
    Entonces cada modelo debe incluir métodos fromMap()
    Y cada modelo debe incluir métodos toMap()
    Y los modelos deben permitir la correcta serialización y deserialización de datos

  Escenario 2: Implementación del repositorio de emprendimientos
    Dado que se requiere una capa de acceso a datos desacoplada
    Cuando se implementa el EntrepreneurshipRepository
    Entonces el repositorio debe encargarse exclusivamente de gestionar los datos
    Y el repositorio debe centralizar las operaciones de lectura y escritura

  Escenario 3: Desacoplamiento entre la UI y la base de datos
    Dado que existe una interfaz de usuario implementada
    Cuando la UI solicita información del sistema
    Entonces la UI debe comunicarse únicamente con el repositorio
    Y la UI no debe realizar llamadas directas a la base de datos
