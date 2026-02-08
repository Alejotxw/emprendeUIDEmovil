// src/products.routes.js
const express = require("express");
const { db } = require("./firebase");

const router = express.Router();

// roles válidos para publicar
const SELLER_ROLES = ["vendedor", "ambos"];

// ========== CREAR PRODUCTO (VENDEDOR / AMBOS) ==========
// POST /products
router.post("/", async (req, res) => {
  try {
    const {
      title,
      description,
      price,
      category,
      imageUrl,
      vendedorId,
      vendedorNombre,
      rol,
    } = req.body;

    // Validar datos obligatorios
    if (!title || !description || !price || !vendedorId || !vendedorNombre || !rol) {
      return res.status(400).json({
        message:
          "Faltan datos (title, description, price, vendedorId, vendedorNombre o rol)",
      });
    }

    // Validar rol
    if (!SELLER_ROLES.includes(rol)) {
      return res.status(403).json({
        message: "Solo usuarios con rol vendedor o ambos pueden crear productos",
      });
    }

    const productsRef = db.collection("products");

    const newProduct = {
      title,
      description,
      price: Number(price),
      category: category || null,
      imageUrl: imageUrl || null,
      vendedorId,
      vendedorNombre,
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const docRef = await productsRef.add(newProduct);

    return res.status(201).json({
      message: "Producto creado correctamente",
      productId: docRef.id,
    });
  } catch (error) {
    console.error("Error en POST /products:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ========== LISTAR TODOS LOS PRODUCTOS ACTIVOS (COMPRADOR / TODOS) ==========
// GET /products
router.get("/", async (_req, res) => {
  try {
    const productsRef = db.collection("products");
    const snapshot = await productsRef.where("isActive", "==", true).get();

    const products = [];
    snapshot.forEach((doc) => {
      products.push({ id: doc.id, ...doc.data() });
    });

    return res.json(products);
  } catch (error) {
    console.error("Error en GET /products:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ========== LISTAR PRODUCTOS DE UN VENDEDOR ==========
// GET /products/seller/:vendedorId
router.get("/seller/:vendedorId", async (req, res) => {
  try {
    const { vendedorId } = req.params;

    const productsRef = db.collection("products");
    const snapshot = await productsRef
      .where("vendedorId", "==", vendedorId)
      .get();

    const products = [];
    snapshot.forEach((doc) => {
      products.push({ id: doc.id, ...doc.data() });
    });

    return res.json(products);
  } catch (error) {
    console.error("Error en GET /products/seller/:vendedorId:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ========== OBTENER PRODUCTO POR ID ==========
// GET /products/:id
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const productRef = db.collection("products").doc(id);
    const productSnap = await productRef.get();

    if (!productSnap.exists) {
      return res.status(404).json({ message: "Producto no encontrado" });
    }

    return res.json({
      id: productSnap.id,
      ...productSnap.data(),
    });
  } catch (error) {
    console.error("Error en GET /products/:id:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ========== ACTUALIZAR PRODUCTO (VENDEDOR / AMBOS) ==========
// PUT /products/:id
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const {
      title,
      description,
      price,
      category,
      imageUrl,
      vendedorId,
      rol,
    } = req.body;

    if (!vendedorId || !rol) {
      return res.status(400).json({
        message: "Faltan datos (vendedorId o rol)",
      });
    }

    if (!SELLER_ROLES.includes(rol)) {
      return res.status(403).json({
        message: "Solo usuarios con rol vendedor o ambos pueden editar productos",
      });
    }

    const productRef = db.collection("products").doc(id);
    const productSnap = await productRef.get();

    if (!productSnap.exists) {
      return res.status(404).json({ message: "Producto no encontrado" });
    }

    const productData = productSnap.data();

    // Verificar que el producto pertenece al vendedor
    if (productData.vendedorId !== vendedorId) {
      return res.status(403).json({
        message: "No puedes editar un producto que no te pertenece",
      });
    }

    const updates = {
      updatedAt: new Date(),
    };

    if (title !== undefined) updates.title = title;
    if (description !== undefined) updates.description = description;
    if (price !== undefined) updates.price = Number(price);
    if (category !== undefined) updates.category = category;
    if (imageUrl !== undefined) updates.imageUrl = imageUrl;

    await productRef.update(updates);

    return res.json({ message: "Producto actualizado correctamente" });
  } catch (error) {
    console.error("Error en PUT /products/:id:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ========== ELIMINAR (DESACTIVAR) PRODUCTO (VENDEDOR / AMBOS) ==========
// DELETE /products/:id
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { vendedorId, rol } = req.body;

    if (!vendedorId || !rol) {
      return res.status(400).json({
        message: "Faltan datos (vendedorId o rol)",
      });
    }

    if (!SELLER_ROLES.includes(rol)) {
      return res.status(403).json({
        message: "Solo usuarios con rol vendedor o ambos pueden eliminar productos",
      });
    }

    const productRef = db.collection("products").doc(id);
    const productSnap = await productRef.get();

    if (!productSnap.exists) {
      return res.status(404).json({ message: "Producto no encontrado" });
    }

    const productData = productSnap.data();

    if (productData.vendedorId !== vendedorId) {
      return res.status(403).json({
        message: "No puedes eliminar un producto que no te pertenece",
      });
    }

    // En lugar de borrar, marcamos como inactivo (por si acaso)
    await productRef.update({
      isActive: false,
      updatedAt: new Date(),
    });

    return res.json({ message: "Producto eliminado (desactivado) correctamente" });
  } catch (error) {
    console.error("Error en DELETE /products/:id:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

module.exports = router;
