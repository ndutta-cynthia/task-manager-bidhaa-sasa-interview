# Task Management System

A Salesforce Lightning Web Component-based task management system that allows users to create, update, delete, and track tasks with automatic completion of overdue tasks.

## Deployment Instructions

### 1. Deploy to a Scratch Org

## Features

### Task Management
- Create new tasks with required name and due date
- Edit existing tasks
- Delete tasks
- Mark tasks as completed
- Form validation prevents setting due dates in the past
- Success notifications for all operations

### Task List View
- Display all tasks in a datatable format
- Columns:
  - Task Name
  - Due Date
  - Completion Status
- Row actions:
  - Edit
  - Complete
  - Delete

### Automated Task Processing
- Batch job to automatically mark overdue tasks as completed
- Scheduled job capability for daily processing
- REST API endpoint for external system integration

## Technical Components

### Custom Object: Task__c
- Fields:
  - Name (Text, Required)
  - Due_Date__c (Date, Required)
  - Completed__c (Checkbox, Default: false)

### Lightning Web Components
1. taskList
   - Main component displaying the task datatable
   - Handles task operations (edit, complete, delete)
   - Integrates with taskForm component

2. taskForm
   - Form component for creating/editing tasks
   - Field validation
   - Error handling with field-level error messages

### Apex Classes
1. TaskController
   - @AuraEnabled methods for LWC interaction
   - REST endpoint for external access
   - Methods:
     - getTasks()
     - updateTaskStatus()
     - deleteTask()
     - getTasksREST()

2. TaskUpdateBatch
   - Batch processing for overdue tasks
   - Automatically marks overdue tasks as completed

3. TaskUpdateScheduler
   - Scheduler class for automated batch processing
   - Can be scheduled to run daily

## Installation

1. Deploy to your Salesforce org:

## REST API Documentation

The Task Management System provides a REST API for external integration. The base URL for all endpoints is:

## REST API Usage Guide

### Base URL
