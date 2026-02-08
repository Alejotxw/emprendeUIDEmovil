const express = require("express");
const { db } = require("./firebase");

const router = express.Router();

/*
 collection: orders
*/

// ===============================
// CREAR PEDIDO
// POST /orders
// ===============================
router.post("/", async (req, res) => {
  try {
    const {
      userId,
      items,
      total,
      paymentMethod,
      transferReceiptPath,
    } = req.body;

    if (!userId || !items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        message: "Datos incompletos del pedido",
      });
    }

    const newOrder = {
      userId,
      items,
      total: total || 0,
      paymentMethod: paymentMethod || "desconocido",
      transferReceiptPath: transferReceiptPath || null,

      // estado inicial
      status: "Pendiente",
      statusColor: "#FFA600",

      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const ref = await db.collection("orders").add(newOrder);

    res.status(201).json({
      message: "Pedido creado",
      orderId: ref.id,
    });
  } catch (error) {
    console.error("Error POST /orders:", error);
    res.status(500).json({ message: "Error al crear pedido" });
  }
});

// ===============================
// OBTENER PEDIDOS POR USUARIO
// GET /orders/user/:userId
// ===============================
router.get("/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const snapshot = await db
      .collection("orders")
      .where("userId", "==", userId)
      .orderBy("createdAt", "desc")
      .get();

    const orders = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(orders);
  } catch (error) {
    console.error("Error GET /orders/user/:userId:", error);
    res.status(500).json({ message: "Error al obtener pedidos" });
  }
});

// ===============================
// OBTENER TODOS LOS PEDIDOS
// (vista emprendedor / admin)
// GET /orders
// ===============================
router.get("/", async (req, res) => {
  try {
    const snapshot = await db
      .collection("orders")
      .orderBy("createdAt", "desc")
      .get();

    const orders = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(orders);
  } catch (error) {
    console.error("Error GET /orders:", error);
    res.status(500).json({ message: "Error al obtener pedidos" });
  }
});

// ===============================
// ACTUALIZAR ESTADO DEL PEDIDO
// PUT /orders/:orderId/status
// ===============================
router.put("/:orderId/status", async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status, statusColor } = req.body;

    if (!status) {
      return res.status(400).json({
        message: "Falta el status",
      });
    }

    const orderRef = db.collection("orders").doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      return res.status(404).json({
        message: "Pedido no encontrado",
      });
    }

    await orderRef.update({
      status,
      statusColor: statusColor || "#FFA600",
      updatedAt: new Date(),
    });

    res.json({
      message: "Estado actualizado",
    });
  } catch (error) {
    console.error("Error PUT /orders/:orderId/status:", error);
    res.status(500).json({ message: "Error al actualizar pedido" });
  }
});
// ===============================
// ACTUALIZAR COMPROBANTE
// PUT /orders/:orderId/receipt
// ===============================
router.put("/:orderId/receipt", async (req, res) => {
  try {
    const { orderId } = req.params;
    const { transferReceiptPath } = req.body;

    await db.collection("orders").doc(orderId).update({
      transferReceiptPath: transferReceiptPath || null,
    });

    res.json({ message: "Comprobante actualizado" });
  } catch (error) {
    console.error("Error PUT /orders/:id/receipt:", error);
    res.status(500).json({ message: "Error al guardar comprobante" });
  }
});

module.exports = router;
