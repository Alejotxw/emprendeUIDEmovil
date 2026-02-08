const express = require("express");
const cors = require("cors");

const authRoutes = require("./auth.routes");
const productRoutes = require("./products.routes");
const reportesRoutes = require("./reportes");
const ordersRoutes = require("./orders.routes");
const servicesRoutes = require("./emprendimientos.routes");
const reviewsRoutes = require("./reviews.routes");
const notificationsRoutes = require("./notifications.routes"); 

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Rutas
app.use("/auth", authRoutes);
app.use("/products", productRoutes);
app.use("/reportes", reportesRoutes);
app.use("/orders", ordersRoutes);
app.use("/services", servicesRoutes);
app.use("/reviews", reviewsRoutes);

// Rutas de notificaciones
app.use("/notifications", notificationsRoutes);


app.get("/", (req, res) => {
  res.json({ message: "Backend del proyecto emprendeUIDE móvil funcionando" });
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
