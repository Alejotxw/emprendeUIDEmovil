const express = require("express");
const { db } = require("./firebase");

const router = express.Router();

/*
Estructura Firestore
collection: reviews

{
  serviceId,
  userId,
  userName,
  rating,
  comment,
  createdAt
}
*/

// ===============================
// CREAR RESEÑA
// POST /reviews
// ===============================
router.post("/", async (req, res) => {
  try {
const {
  serviceId,
  ownerId,
  userId,
  userName,
  rating,
  comment,
} = req.body;

if (!serviceId || !ownerId || !userId || !rating) {
      return res.status(400).json({
        message: "Faltan datos obligatorios",
      });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({
        message: "El rating debe estar entre 1 y 5",
      });
    }

const newReview = {
  serviceId,
  ownerId,       // 👈 IMPORTANTE
  userId,
  userName: userName || "",
  rating: Number(rating),
  comment: comment || "",
  createdAt: new Date(),
};

    const ref = await db.collection("reviews").add(newReview);
    // ===============================
// actualizar promedio del servicio
// ===============================
const serviceRef = db.collection("services").doc(serviceId);

const reviewsSnap = await db
  .collection("reviews")
  .where("serviceId", "==", serviceId)
  .get();

let totalReviews = 0;
let sumRatings = 0;

reviewsSnap.forEach(doc => {
  sumRatings += Number(doc.data().rating || 0);
  totalReviews++;
});

const averageRating =
  totalReviews === 0 ? 0 : sumRatings / totalReviews;

await serviceRef.update({
  rating: averageRating,
  reviewCount: totalReviews,
  updatedAt: new Date(),
});

    res.status(201).json({
      message: "Reseña guardada correctamente",
      reviewId: ref.id,
    });

  } catch (error) {
    console.error("Error POST /reviews:", error);
    res.status(500).json({ message: "Error al guardar reseña" });
  }
});


// ===============================
// OBTENER RESEÑAS DE UN SERVICIO
// GET /reviews/service/:serviceId
// ===============================
router.get("/service/:serviceId", async (req, res) => {
  try {
    const { serviceId } = req.params;

    const snapshot = await db
      .collection("reviews")
      .where("serviceId", "==", serviceId)
      .orderBy("createdAt", "desc")
      .get();

    const reviews = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(reviews);

  } catch (error) {
    console.error("Error GET /reviews/service/:serviceId:", error);
    res.status(500).json({ message: "Error al obtener reseñas" });
  }
});


// ===============================
// OBTENER RESEÑAS DE UN USUARIO
// GET /reviews/user/:userId
// ===============================
router.get("/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const snapshot = await db
      .collection("reviews")
      .where("userId", "==", userId)
      .orderBy("createdAt", "desc")
      .get();

    const reviews = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(reviews);

  } catch (error) {
    console.error("Error GET /reviews/user/:userId:", error);
    res.status(500).json({ message: "Error al obtener reseñas" });
  }
});

// ===============================
// OBTENER RESEÑAS DE UN EMPRENDEDOR
// GET /reviews/owner/:ownerId
// ===============================
router.get("/owner/:ownerId", async (req, res) => {
  try {
    const { ownerId } = req.params;

    const snapshot = await db
      .collection("reviews")
      .where("ownerId", "==", ownerId)
      .orderBy("createdAt", "desc")
      .get();

    const reviews = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(reviews);

  } catch (error) {
    console.error("Error GET /reviews/owner/:ownerId:", error);
    res.status(500).json({ message: "Error al obtener reseñas del emprendedor" });
  }
});

// ===============================
// OBTENER PROMEDIO DE RATING
// GET /reviews/average/:serviceId
// ===============================
router.get("/average/:serviceId", async (req, res) => {
  try {
    const { serviceId } = req.params;

    const snapshot = await db
      .collection("reviews")
      .where("serviceId", "==", serviceId)
      .get();

    if (snapshot.empty) {
      return res.json({
        average: 0,
        total: 0,
      });
    }

    let total = 0;
    let sum = 0;

    snapshot.forEach((doc) => {
      const data = doc.data();
      sum += Number(data.rating || 0);
      total++;
    });

    const average = sum / total;

    res.json({
      average,
      total,
    });

  } catch (error) {
    console.error("Error GET /reviews/average/:serviceId:", error);
    res.status(500).json({ message: "Error al calcular promedio" });
  }
});

module.exports = router;
