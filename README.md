# task_manager_app

A Flutter-based task management app with Back4App integration, designed as part of MTech assignment in Cross Platform Application Development.

## Getting Started

To get this project up and running on your local machine for development and testing purposes, follow these simple example steps.

### Prerequisites

  - Flutter installed on your machine
  - Android SDK or Android Studio installed on your machine
  - An IDE (e.g., Android Studio, VS Code, etc.)
  - An account on Back4App and your unique Application ID and Client Key

### Installation
  1. Create a Back4App account via [https://www.back4app.com/]
  2. In Back4App create a class named "tasks" with coloums:
      - title (string)
      - description (string)
      - status (string)
      - userId (pointer) (target: _User)
  3. Edit the class's "Class Level Permission" to allow Read, Write permission for Authenticated user only.
  4. Clone the repository:
     
          git clone https://github.com/mondaImo/task_manager_app
     
  5. Replace the "SET_ME" vlues wtih your backend service's actual API Address, Application ID and REST API key  in lib/application.dart from Back4App.
  6. Navigate to the project directory

         cd task_manager_app
  7. Install dependencies:

          flutter pub get
  8. Run the app:

         flutter run

## Usage

Once the app is running on an emulator or device, you can:

- Login or Signup
- View all tasks on dashboard
- Add new tasks using the '+' button.
- Tap on a task card to update/edit its details.
- Use the three dot icon to open menu and tap on delete to remove it.

## License
Free to use
