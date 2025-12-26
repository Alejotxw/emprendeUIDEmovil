const express = require("express");
const cors = require("cors");
const authRoutes = require("./auth.routes");
const productRoutes = require("./products.routes");

const notificationsRoutes = require("./notifications.routes"); 

const app = express();
const PORT = process.env.PORT || 4000;

// Middlewares
app.use(cors());
app.use(express.json());

// Rutas de autenticación (login / registro)
app.use("/auth", authRoutes);
// Rutas de productos
app.use("/products", productRoutes);

// Rutas de notificaciones
app.use("/notifications", notificationsRoutes);

// Ruta de prueba
app.get("/", (req, res) => {
  res.json({ message: "Backend del proyecto emprendeUIDE móvil funcionando " });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
