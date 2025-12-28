const express = require("express");
const { db, admin } = require("./firebase");

const router = express.Router();

/**
 * POST /notifications/register-token
 * Body: { uid, token }
 * Guarda/actualiza el token FCM del usuario en Firestore
 */
router.post("/register-token", async (req, res) => {
  try {
    const { uid, token } = req.body;

    if (!uid || !token) {
      return res.status(400).json({ message: "uid y token son requeridos" });
    }

    const userRef = db.collection("users").doc(uid);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    await userRef.set(
      {
        fcmTokens: admin.firestore.FieldValue.arrayUnion(token),
        updatedAt: new Date(),
      },
      { merge: true }
    );

    return res.json({ message: "Token registrado correctamente" });
  } catch (error) {
    console.error("Error en POST /notifications/register-token:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

/**
 * POST /notifications
 * Body: { uid, title, body }
 * Crea una notificación y la envía por FCM
 */
router.post("/", async (req, res) => {
  try {
    const { uid, title, body } = req.body;

    if (!uid || !title || !body) {
      return res
        .status(400)
        .json({ message: "uid, title y body son requeridos" });
    }

    const userRef = db.collection("users").doc(uid);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    const userData = userSnap.data();
    const tokens = userData.fcmTokens || [];

    // 1) Guardar notificación en Firestore
    const notifRef = await userRef.collection("notifications").add({
      title,
      body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
    });

    // 2) Enviar push si hay tokens
    if (tokens.length > 0) {
      await admin.messaging().sendMulticast({
        tokens,
        notification: { title, body },
        data: { notificationId: notifRef.id },
      });
    }

    return res.json({
      message: "Notificación creada correctamente",
      id: notifRef.id,
    });
  } catch (error) {
    console.error("Error en POST /notifications:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

/**
 * GET /notifications/:uid
 * Devuelve las notificaciones ordenadas por fecha DESC
 */
router.get("/:uid", async (req, res) => {
  try {
    const { uid } = req.params;

    const notificationsRef = db
      .collection("users")
      .doc(uid)
      .collection("notifications")
      .orderBy("createdAt", "desc");

    const snap = await notificationsRef.get();

    const list = snap.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    return res.json(list);
  } catch (error) {
    console.error("Error en GET /notifications/:uid:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

module.exports = router;
