Característica: Visualización de métricas calculadas del marketplace
  Como administrador del sistema
  Quiero visualizar datos calculados del marketplace
  Para conocer el estado actual de los emprendimientos sin procesar listas manualmente

  Escenario 1: Consulta SQL para total de productos
    Dado que el sistema cuenta con productos registrados en la base de datos
    Cuando el administrador solicita el total de productos
    Entonces el sistema debe ejecutar una consulta SQL utilizando COUNT()
    Y el sistema debe mostrar el total de productos registrados

  Escenario 2: Consulta SQL para precio promedio de servicios
    Dado que existen servicios registrados con precios asociados
    Cuando el administrador solicita el precio promedio de los servicios
    Entonces el sistema debe ejecutar una consulta SQL utilizando AVG()
    Y el sistema debe mostrar el precio promedio calculado correctamente

  Escenario 3: Persistencia del estado del tema visual
    Dado que el administrador ha seleccionado un tema visual (claro u oscuro)
    Cuando el administrador cierra la aplicación y la vuelve a abrir
    Entonces el sistema debe cargar el tema previamente seleccionado
    Y el estado del tema debe persistirse utilizando SharedPreferences
