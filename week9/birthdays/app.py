from flask import Flask, render_template, request, redirect
from cs50 import SQL

app = Flask(__name__)

db = SQL("sqlite:///birthdays.db")


@app.route("/", methods=["GET", "POST"])
def index():

    if request.method == "POST":

        name = request.form.get("name")
        month = request.form.get("month")
        day = request.form.get("day")

        if not name or not month or not day:
            return redirect("/")

        db.execute(
            "INSERT INTO birthdays (name, month, day) VALUES (?, ?, ?)",
            name, month, day
        )

        return redirect("/")

    birthdays = db.execute("SELECT * FROM birthdays")
    return render_template("index.html", birthdays=birthdays)


# 🔴 DELETE
@app.route("/delete/<int:id>")
def delete(id):
    db.execute("DELETE FROM birthdays WHERE id = ?", id)
    return redirect("/")


# 🟡 EDIT PAGE
@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit(id):

    if request.method == "POST":

        name = request.form.get("name")
        month = request.form.get("month")
        day = request.form.get("day")

        db.execute(
            "UPDATE birthdays SET name = ?, month = ?, day = ? WHERE id = ?",
            name, month, day, id
        )

        return redirect("/")

    birthday = db.execute("SELECT * FROM birthdays WHERE id = ?", id)[0]
    return render_template("edit.html", birthday=birthday)
