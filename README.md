# Personal Automation Engine

## Overview

The Personal Automation Engine is a Flutter-based mobile application that allows users to create and manage automation rules. Each rule consists of a trigger, optional conditions, and one or more actions that are executed when the trigger event occurs.

The application demonstrates a modular architecture separating the user interface, rule engine logic, and data storage to ensure scalability and maintainability.

---

# Architecture

The system is designed using a layered architecture:

User Interface Layer
↓
Automation Engine Layer
↓
Action & Trigger Layer
↓
Data Storage Layer

This separation allows each component to operate independently and simplifies future extensions.

---

# Core Components

## 1. Rule Model

The Rule model represents an automation rule created by the user.

Each rule contains:

* Rule ID
* Rule name
* Enabled/Disabled state
* Trigger type
* Trigger parameters
* Optional conditions
* List of actions

Rules are serialized to JSON and stored locally using Hive.

---

## 2. Trigger System

Triggers represent events that start rule evaluation.

Currently supported triggers:

* Time Trigger
* Battery Trigger
* WiFi Trigger

TriggerManager detects trigger events and sends them to the Automation Engine.

Example:

Battery Level Change
↓
TriggerManager
↓
AutomationEngine.evaluateTrigger()

---

## 3. Condition Evaluation

Conditions allow rules to execute only when specific criteria are met.

Example condition:
Battery level < 20%

The Automation Engine evaluates all conditions before executing actions.

---

## 4. Automation Engine

The Automation Engine is the core processing component of the system.

Responsibilities:

* Receive trigger events
* Identify matching rules
* Evaluate rule conditions
* Execute rule actions

Workflow:

Trigger Event
↓
Find Matching Rules
↓
Evaluate Conditions
↓
Execute Actions

This design ensures rules are processed dynamically at runtime.

---

## 5. Action System

Actions define what happens when a rule is triggered.

Implemented actions include:

* Notification Action
  Displays a system notification on the device.

* Log Action
  Records rule execution in the activity log.

* Open App (prototype)
  Placeholder for launching external applications.

Actions are executed through the ActionExecutor module.

---

## 6. Logging System

Every rule execution can generate a log entry.

Log entries include:

* Rule name
* Execution timestamp

Logs are displayed in the dashboard activity section to help users track automation events.

---

## 7. Data Storage

The application uses Hive, a lightweight NoSQL database for Flutter.

Benefits:

* Fast local storage
* No internet required
* Easy serialization using JSON

Rules are persisted so they remain available even after restarting the application.

---

# User Interface

The UI is built using Flutter and follows a dashboard-based design.

Screens included:

Dashboard
Displays rule statistics, quick triggers, and recent activity.

Rules Screen
Allows users to view, edit, enable/disable, and delete automation rules.

Create Rule Screen
Allows users to create new automation rules.

Log Screen
Displays rule execution history.

The application uses a dark theme to improve readability and provide a modern interface.

---

# Design Decisions

### Flutter Framework

Flutter was chosen because it allows rapid cross-platform development and provides a rich UI toolkit.

### Modular Architecture

Separating the rule engine, triggers, actions, and UI allows the system to be extended easily with new automation features.

### Local Data Storage

Hive was selected due to its performance and simplicity compared to traditional SQL databases.

### Event-Based Automation

The rule engine uses an event-driven approach where triggers generate events that are processed by the automation engine.

This approach allows dynamic rule evaluation without constant polling.

---

# Features Implemented

* Rule creation, editing, enabling/disabling, and deletion
* Multiple trigger types
* Runtime condition evaluation
* Modular action system
* Real-time notifications
* Execution logging
* JSON rule export
* Dark theme UI
* Persistent local storage

---

# Future Enhancements

Possible improvements include:

* Real-time battery and WiFi monitoring
* Scheduled time-based automation
* Cloud rule synchronization
* Advanced condition builder
* Rule conflict detection
* Performance monitoring

---

# Conclusion

The Personal Automation Engine demonstrates how a modular rule-based automation system can be implemented in Flutter. The architecture ensures extensibility and maintainability while providing a clean user interface for managing automation workflows.
