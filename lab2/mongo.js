const express = require("express");
const mongoose = require("mongoose");

const app = express();
const PORT = 8080;
const MONGO_URL = "mongodb://mongo:27017/testdb"; 

mongoose
  .connect(MONGO_URL, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("Połączono z MongoDB"))
  .catch((err) => console.error("Błąd połączenia z MongoDB:", err));

const Schema = mongoose.Schema;
const TestSchema = new Schema({ name: String });
const TestModel = mongoose.model("Test", TestSchema);

app.get("/", async (req, res) => {
  const data = await TestModel.find();
  res.json(data);
});

app.get("/add/:name", async (req, res) => {
  const newItem = new TestModel({ name: req.params.name });
  await newItem.save();
  res.json({ message: "Dodano do bazy", item: newItem });
});

app.listen(PORT, () => console.log(`Serwer działa na http://localhost:${PORT}`));
