# Personal Automation Engine

## Overview
A mobile application that allows users to create automation rules. 
Rules consist of triggers, optional conditions, and actions that execute automatically when triggered.

## Features
- Create automation rules
- Enable / Disable rules
- Edit and delete rules
- Trigger system (Time, Battery, WiFi)
- Condition evaluation
- Modular action system
- Execution logs
- JSON export of rules
- Persistent rule storage

## Architecture

UI Layer
screens/

Rule Engine
engine/

Storage
Hive Database

Triggers
TriggerManager

Actions
ActionExecutor

## Rule Execution Flow

Trigger Event  
↓  
AutomationEngine evaluates rules  
↓  
Conditions validated  
↓  
Actions executed  

## Technologies Used
- Flutter
- Dart
- Hive Local Database
