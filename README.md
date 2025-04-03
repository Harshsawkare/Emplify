# Emplify - Employee Manager App

📌 Overview

The Employee Manager App is a Flutter-based application that allows users to manage employee records efficiently. It supports adding, editing, deleting, and categorizing employees based on their joining and leaving dates. The app is designed with a focus on state management, local database handling, and responsive UI to ensure smooth performance across different platforms.

✨ Features

✅ UI & UX Enhancements

- Custom App Icon & Name for a polished user experience.

- Empty Listing Screen Illustration to handle cases where no employees are available.

- Circular Progress Indicator while loading data from the local database.

- Web-Responsive Design to ensure usability across mobile and web platforms.

📦 State & Data Management

- State Management: Implemented using Bloc for efficient UI updates.

- Local Database: Uses Hive for offline data storage.

- Repository Pattern: Ensures proper dependency injection for all database-related operations.

🗂️ Employee Listing

Employees are categorized into:

- Previous Employees: If the leaving date is before the current date.

- Current Employees: If the leaving date is after the current date or is null.

🛠️ Functionalities

- Swipe Left to Delete employee with a user prompt.

- Undo Delete Action via Snackbar notification.

- Edit Employee Details Screen allows modification of employee information.

📅 Custom Calendar & Date Selection

- If a date is pre-filled, it appears selected.

- Default date selection is set to Today.

- Joining Date: Any date can be selected.

- Leaving Date: Only future dates relative to the joining date are selectable.

- Previous Month Navigation Disabled if leaving date selection violates rules.

- Smart Date Labels: Display "Today" instead of an actual date if applicable.

- Quick Date Selection via Chips:

  - Today

  - Next Monday (calculated dynamically)

  - Next Tuesday

  - After 1 Week

🔍 Form Validations & UX Improvements

- Employee Name & Role Fields: Mandatory validation.

- Keyboard Call-To-Action Buttons: Visible when typing in the Employee Name field.

- Auto Refresh: List updates dynamically on adding, deleting, or modifying an employee.

🌍 Web Hosting

Hosted on Firebase, making it accessible as a web application.
