const admin = require("firebase-admin");
const path = require("path");

// Carga el archivo de cuenta de servicio (clave privada)
const serviceAccount = require(path.join(__dirname, "..", "serviceAccountKey.json"));

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const db = admin.firestore();

module.exports = { db, admin };