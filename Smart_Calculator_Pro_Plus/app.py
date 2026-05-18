from cs50 import SQL
from flask import Flask, render_template, request, redirect
import math

app = Flask(__name__)
db = SQL("sqlite:///calc.db")


@app.route("/", methods=["GET", "POST"])
def index():

    if request.method == "POST":
        expression = request.form.get("expression")

        try:
            # safe math functions
            result = str(eval(expression, {
                "__builtins__": None,
                "sqrt": math.sqrt,
                "sin": math.sin,
                "cos": math.cos,
                "tan": math.tan,
                "pi": math.pi,
                "e": math.e
            }))
        except:
            result = "Error"

        db.execute("INSERT INTO history (expression, result) VALUES (?, ?)", expression, result)

        return render_template("index.html", result=result, expression=expression)

    return render_template("index.html")


@app.route("/history")
def history():
    data = db.execute("SELECT * FROM history ORDER BY id DESC")
    return render_template("history.html", data=data)


@app.route("/clear")
def clear():
    db.execute("DELETE FROM history")
    return redirect("/history")
