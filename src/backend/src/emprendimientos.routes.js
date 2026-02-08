const express = require("express");
const { db } = require("./firebase");

const router = express.Router();

/*
Colección REAL en Firestore: services

{
  title,
  subtitle,
  category,
  price,
  imagePath,
  services,
  products,
  rating,
  reviewCount,
  ownerId,
  isActive,
  createdAt,
  updatedAt
}
*/

// ===============================
// CREAR SERVICIO / EMPRENDIMIENTO
// POST /services
// ===============================
router.post("/", async (req, res) => {
  try {
const {
  title,
  subtitle,
  category,
  price,
  imagePath,
  services,
  products,
  rating,
  reviewCount,
  ownerId,
  schedule
} = req.body;

    if (!title || !ownerId) {
      return res.status(400).json({
        message: "Faltan datos obligatorios (title, ownerId)",
      });
    }

const newService = {
  title,
  subtitle: subtitle || "",
  category: category || "General",
  price: price || 0,
  imagePath: imagePath || "",
  services: services || [],
  products: products || [],
  rating: rating || 0,
  reviewCount: reviewCount || 0,
  ownerId,

  schedule: {
    days: schedule?.days || [],
    open: schedule?.open || "",
    close: schedule?.close || "",
  },

  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date(),
};

    const ref = await db.collection("services").add(newService);

    res.status(201).json({
      id: ref.id,
    });
  } catch (error) {
    console.error("Error POST /services:", error);
    res.status(500).json({ message: "Error al crear servicio" });
  }
});

// ===============================
// OBTENER SERVICIOS ACTIVOS
// GET /services
// ===============================
router.get("/", async (req, res) => {
  try {
    const snapshot = await db
      .collection("services")
      .where("isActive", "==", true)
      .orderBy("createdAt", "desc")
      .get();

    const services = [];

    for (const doc of snapshot.docs) {
      const serviceData = doc.data();

      // buscar reviews del servicio
      const reviewsSnap = await db
        .collection("reviews")
        .where("serviceId", "==", doc.id)
        .get();

      let total = 0;
      let sum = 0;

      reviewsSnap.forEach(r => {
        const rating = r.data().rating || 0;
        sum += rating;
        total++;
      });

      const average = total > 0 ? sum / total : 0;

      services.push({
        id: doc.id,
        ...serviceData,
        rating: Number(average.toFixed(1)),
        reviewCount: total,
      });
    }

    res.json(services);
  } catch (error) {
    console.error("Error GET /services:", error);
    res.status(500).json({ message: "Error al obtener servicios" });
  }
});


// ===============================
// SERVICIOS POR OWNER
// GET /services/owner/:ownerId
// ===============================
router.get("/owner/:ownerId", async (req, res) => {
  try {
    const { ownerId } = req.params;

    const snapshot = await db
      .collection("services")
      .where("ownerId", "==", ownerId)
      .where("isActive", "==", true)
      .orderBy("createdAt", "desc")
      .get();

    const services = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(services);
  } catch (error) {
    console.error("Error GET /services/owner:", error);
    res.status(500).json({ message: "Error al obtener servicios" });
  }
});

// ===============================
// OBTENER SERVICIO POR ID
// GET /services/:id
// ===============================
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const ref = db.collection("services").doc(id);
    const doc = await ref.get();

    if (!doc.exists) {
      return res.status(404).json({ message: "Servicio no encontrado" });
    }

    res.json({
      id: doc.id,
      ...doc.data(),
    });
  } catch (error) {
    console.error("Error GET /services/:id:", error);
    res.status(500).json({ message: "Error al obtener servicio" });
  }
});

// ===============================
// ACTUALIZAR SERVICIO
// PUT /services/:id
// ===============================
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    await db.collection("services").doc(id).update({
      ...req.body,
      updatedAt: new Date(),
    });

    res.json({ message: "Servicio actualizado" });
  } catch (error) {
    console.error("Error PUT /services/:id:", error);
    res.status(500).json({ message: "Error al actualizar servicio" });
  }
});

// ===============================
// DESACTIVAR SERVICIO
// DELETE /services/:id
// ===============================
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const ref = db.collection("services").doc(id);
    const doc = await ref.get();

    if (!doc.exists) {
      return res.status(404).json({ message: "Servicio no encontrado" });
    }

    await ref.update({
      isActive: false,
      updatedAt: new Date(),
    });

    res.json({ message: "Servicio desactivado" });
  } catch (error) {
    console.error("Error DELETE /services/:id:", error);
    res.status(500).json({ message: "Error al eliminar servicio" });
  }
});

module.exports = router;
