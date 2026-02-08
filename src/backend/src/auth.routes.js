const express = require("express");
const bcrypt = require("bcryptjs");
const { db } = require("./firebase");

const router = express.Router();

// dominio institucional
const INSTITUTION_DOMAIN = "@uide.edu.ec";

// roles permitidos
const VALID_ROLES = ["vendedor", "comprador", "ambos"];

function isInstitutionalEmail(email) {
  return email.toLowerCase().endsWith(INSTITUTION_DOMAIN);
}

// ===============================
// REGISTRO
// POST /auth/register
// ===============================
router.post("/register", async (req, res) => {
  try {
    const { nombre, email, password, rol } = req.body;

    if (!nombre || !email || !password || !rol) {
      return res
        .status(400)
        .json({ message: "Faltan datos (nombre, email, password o rol)" });
    }

    if (!isInstitutionalEmail(email)) {
      return res.status(400).json({
        message: `El correo debe ser institucional (terminar en ${INSTITUTION_DOMAIN})`,
      });
    }

    if (!VALID_ROLES.includes(rol)) {
      return res.status(400).json({
        message: `Rol inválido. Debe ser: ${VALID_ROLES.join(", ")}`,
      });
    }

    const usersRef = db.collection("users");

    const snapshot = await usersRef.where("email", "==", email).get();

    if (!snapshot.empty) {
      return res.status(400).json({ message: "El correo ya está registrado" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = {
      nombre,
      email,
      password: hashedPassword,
      rol,
      telefono: "",
      direccion: "",
      fotoPerfil: "",
      createdAt: new Date(),
    };

    const docRef = await usersRef.add(newUser);

    return res.status(201).json({
      message: "Registro exitoso",
      userId: docRef.id,
    });
  } catch (error) {
    console.error("Error en /auth/register:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ===============================
// LOGIN
// POST /auth/login
// ===============================
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Faltan datos (email o password)" });
    }

    if (!isInstitutionalEmail(email)) {
      return res.status(400).json({
        message: `El correo debe ser institucional (terminar en ${INSTITUTION_DOMAIN})`,
      });
    }

    const usersRef = db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (snapshot.empty) {
      return res.status(401).json({ message: "Credenciales inválidas" });
    }

    let userDoc;

    snapshot.forEach((doc) => {
      userDoc = { id: doc.id, ...doc.data() };
    });

    const isValidPassword = await bcrypt.compare(
      password,
      userDoc.password
    );

    if (!isValidPassword) {
      return res.status(401).json({ message: "Credenciales inválidas" });
    }

    return res.json({
      message: "Login exitoso",
      user: {
        id: userDoc.id,
        nombre: userDoc.nombre,
        email: userDoc.email,
        rol: userDoc.rol,
      },
    });
  } catch (error) {
    console.error("Error en /auth/login:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ===============================
// OBTENER PERFIL
// GET /auth/user/:uid
// ===============================
router.get("/user/:uid", async (req, res) => {
  try {
    const { uid } = req.params;

    if (!uid) {
      return res.status(400).json({ message: "Falta el uid" });
    }

    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    const data = userDoc.data();

    return res.json({
      id: userDoc.id,
      nombre: data.nombre,
      email: data.email,
      rol: data.rol,
      telefono: data.telefono || "",
      direccion: data.direccion || "",
      fotoPerfil: data.fotoPerfil || "",
      creadoEn: data.createdAt || null,
    });
  } catch (error) {
    console.error("Error GET /auth/user/:uid:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

// ===============================
// ACTUALIZAR PERFIL
// PUT /auth/user/:uid
// ===============================
router.put("/user/:uid", async (req, res) => {
  try {
    const { uid } = req.params;
    const { nombre, telefono, direccion, fotoPerfil, rol } = req.body;

    if (!uid) {
      return res.status(400).json({ message: "Falta el uid" });
    }

    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    const dataToUpdate = {};

    if (nombre !== undefined) dataToUpdate.nombre = nombre;
    if (telefono !== undefined) dataToUpdate.telefono = telefono;
    if (direccion !== undefined) dataToUpdate.direccion = direccion;
    if (fotoPerfil !== undefined) dataToUpdate.fotoPerfil = fotoPerfil;

    if (rol !== undefined) {
      if (!VALID_ROLES.includes(rol)) {
        return res.status(400).json({
          message: `Rol inválido. Debe ser: ${VALID_ROLES.join(", ")}`,
        });
      }
      dataToUpdate.rol = rol;
    }

    await userRef.update(dataToUpdate);

    return res.json({
      message: "Perfil actualizado correctamente",
    });
  } catch (error) {
    console.error("Error PUT /auth/user/:uid:", error);
    return res.status(500).json({ message: "Error en el servidor" });
  }
});

module.exports = router;
