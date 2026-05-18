#Smart Calculator PRO+
####Demo Video:  https://youtu.be/_8zn6qWkoGk?si=fY9uPMra8Al6MqdV
####Project Description

Smart Calculator PRO+ is a web-based calculator application developed using Flask and SQLite as part of my CS50 Final Project. The main objective of this project is to design and implement a modern, interactive, and user-friendly calculator that goes beyond basic arithmetic operations.

This calculator is capable of handling both standard and scientific calculations. Users can perform operations such as addition, subtraction, multiplication, and division, as well as advanced mathematical functions like square root, sine, cosine, and tangent. Additionally, it supports important mathematical constants such as pi and e, which makes it more powerful than a traditional calculator.

One of the most important features of this project is its ability to store calculation history. Every calculation performed by the user is saved into a SQLite database, allowing users to revisit their previous expressions and results. This makes the calculator more useful and practical for real-world usage.

The application also includes a dark mode user interface, which improves readability and provides a modern look and feel. The overall design is simple, clean, and intuitive, ensuring that users can easily interact with the calculator without confusion.

This project demonstrates the integration of backend and frontend technologies along with database management, making it a complete full-stack web application.

## Features

- Basic arithmetic operations (+, -, *, /)
- Scientific functions (sin, cos, tan, sqrt)
- Mathematical constants (pi, e)
- Dark mode user interface
- Calculation history stored in database
- History viewing page
- Clear history option
- Error handling for invalid inputs
- Simple and clean user interface

## Technologies Used

The following technologies were used in this project:

- Python for backend logic and calculations
- Flask as the web framework
- SQLite for storing calculation history
- HTML for structuring web pages
- CSS for styling and dark theme design
- JavaScript for handling button input and interaction

## Project Structure

project/
├── app.py
├── calc.db
├── templates/
│   ├── layout.html
│   ├── index.html
│   ├── history.html
└── static/
    └── style.css

## How to Run the Project

To run this project locally, follow these steps:

1. Open terminal
2. Navigate to the project directory:
   cd project
3. Run the Flask application:
   flask run
4. Open your browser and visit:
  http://127.0.0.1:5000/

## How It Works

The calculator takes user input as a mathematical expression. When the user presses the equals button, the expression is sent to the Flask backend using a POST request.

The backend processes the expression using Python’s eval() function. For security reasons, the evaluation environment is restricted so that only specific mathematical functions such as sqrt, sin, cos, tan and constants like pi and e can be used. This prevents execution of unsafe or malicious code.

After evaluation, the result is displayed to the user. At the same time, both the expression and its result are stored in the SQLite database.

The history page retrieves all saved calculations and displays them in reverse chronological order, showing the most recent calculations first. Users can also clear all stored history using the clear option.

## Design Decisions

Several important design decisions were made during development:

- Restricted eval() was used to ensure safe execution
- Dark theme was chosen to improve readability and modern design
- SQLite database was used to store calculation history
- Separation of backend, templates, and static files for clean architecture
- Simple layout was used to ensure usability for all users

## Limitations

- Does not support very complex mathematical expressions
- No authentication system is implemented
- Not fully optimized for mobile devices

## Future Improvements

In the future, the following features can be added:

- Graph plotting functionality
- Voice input calculator
- Mobile responsive design
- Advanced equation solving features
- User authentication system

## Conclusion

Smart Calculator PRO+ is a complete full-stack web application that demonstrates key concepts of web development including backend processing, database integration, and frontend design.

This project reflects my understanding of Flask, SQL, and modern web technologies learned throughout the CS50 course. It also shows my ability to design and implement a functional and user-friendly application.

## Author
MD Moynul Islam Tanvir
