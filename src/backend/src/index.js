const express = require("express");
const cors = require("cors");

const authRoutes = require("./auth.routes");
const productRoutes = require("./products.routes");
const reportesRoutes = require("./reportes");

const notificationsRoutes = require("./notifications.routes"); 

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

app.use("/auth", authRoutes);
app.use("/products", productRoutes);
app.use("/reportes", reportesRoutes);

<<<<<<< HEAD:backend/src/index.js
=======
// Rutas de notificaciones
app.use("/notifications", notificationsRoutes);

// Ruta de prueba
>>>>>>> main:src/backend/src/index.js
app.get("/", (req, res) => {
  res.json({ message: "Backend del proyecto emprendeUIDE móvil funcionando" });
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
