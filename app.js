const express = require("express");
const bodyParser = require("body-parser");
const { exec } = require("child_process");

const app = express();
app.use(bodyParser.json());
app.use(express.static("public"));

// API nhận danh sách nguyên liệu, gọi Prolog để gợi ý món ăn
app.post("/suggest", (req, res) => {
  const ingredients = req.body.ingredients.map(i => `'${i}'`).join(",");
  
  const query = `swipl -s recipes.pl -g "findall([R, Reps], suggest_recipe([${ingredients}], R, Reps), L), forall(member(X, L), writeln(X))." -t halt`;

  exec(query, (error, stdout) => {
    if (error) {
      console.error("Lỗi Prolog:", error);
      return res.status(500).send("Lỗi Prolog: " + error.message);
    }

    // Xử lý đầu ra từ Prolog
    const lines = stdout
      .trim()
      .split('\n')
      .filter(line => line.trim().length > 0);

    const suggestions = lines.map(line => {
      const cleaned = line.replace(/\[|\]|'/g, "").trim();
      const [recipe, ...reps] = cleaned.split(",");

      // Lọc danh sách nguyên liệu đã thay
      const cleanedRepsList = reps
        .map(s => s.replace("-", " → ").trim())
        .filter(s => s.length > 0);

      const cleanedReps = cleanedRepsList.length
        ? " (đã thay: " + cleanedRepsList.join(", ") + ")"
        : "";

      return recipe.trim() + cleanedReps;
    });

    res.send({ suggestions });
  });
});

app.listen(3000, () => {
  console.log("Server đang chạy tại http://localhost:3000");
});
