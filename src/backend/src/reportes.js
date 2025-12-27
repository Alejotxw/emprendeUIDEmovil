const express = require("express");
const fs = require("fs");
const path = require("path");

const router = express.Router();

// Carpeta donde se guardarán los reportes
const reportFolder = path.join(__dirname, "reporte-sistemas");

// Crear carpeta si no existe
if (!fs.existsSync(reportFolder)) {
  fs.mkdirSync(reportFolder);
}

// POST /reportes
router.post("/", (req, res) => {
  try {
    const data = req.body;

    if (!data || Object.keys(data).length === 0) {
      return res.status(400).json({ error: "El body del reporte está vacío." });
    }

    // Nombre del archivo con fecha y hora
    const fileName = `reporte_${Date.now()}.json`;
    const filePath = path.join(reportFolder, fileName);

    // Guardar archivo JSON
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2));

    return res.json({
      message: "Reporte guardado correctamente",
      file: fileName,
    });
  } catch (error) {
    console.error("Error al guardar el reporte:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
});

module.exports = router;
