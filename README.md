# Task Management System

A Salesforce-based task management system that provides REST API endpoints for task operations and includes Lightning Web Components for task visualization.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Limitations](#limitations)

## Overview

This project implements a custom task management solution in Salesforce, featuring:

- Custom Task object
- REST API endpoints for task operations
- Lightning Web Components for task visualization
- Batch/Queueable jobs for task processing

## Features

- List tasks via REST API
- Visual task management interface using LWC
- Automated task processing using batch jobs
- Secure API endpoints with Salesforce authentication

## Installation

### Prerequisites

- Salesforce CLI installed
- Dev Hub org enabled
- Visual Studio Code with Salesforce extensions

### Deployment Steps

1. Clone this repository:

   ```bash
   git clone https://github.com/ndutta-cynthia/task-manager-bidhaa-sasa-interview.git
   cd task-management-system
   ```

2. Authorize your org:

   ```bash
   sfdx auth:web:login -d -a YourOrgAlias
   ```

3. Deploy the source:

   ```bash
   sfdx force:source:deploy -p force-app/main/default
   ```

## Configuration

### Setting Up the Lightning Web Component

1. Open Setup in Salesforce.
2. Navigate to Lightning App Builder.
3. Create a new Lightning Page.
4. Drag the `taskManager` component onto the page.
5. Activate and assign to your desired profiles.

### Configuring API Access

1. Create a Connected App in Setup.
2. Note down the Consumer Key and Secret.
3. Configure OAuth scopes for API access.

## Usage

### REST API Endpoints

Base URL: 

#### Available Endpoints:

```http
GET    https://momentum-customization-7615-dev-ed.scratch.my.salesforce-sites.com/services/apexrest/Tasks
         # Retrieve all tasks
```

### Sample API Calls

#### Fetch Tasks (using cURL):

```bash
curl -X GET \  
  'https://momentum-customization-7615-dev-ed.scratch.my.salesforce-sites.com/services/apexrest/Tasks'
```

### Running Batch Jobs

1. Open Developer Console.
2. Execute Anonymous Window:

   ```apex
   TaskProcessingBatch batch = new TaskProcessingBatch();
   Database.executeBatch(batch);
   ```

## Testing

### Apex Tests

Run all tests using:

```bash
sfdx force:apex:test:run -l RunLocalTests -r human
```

### LWC Testing

1. Run Jest tests:

   ```bash
   npm run test:unit
   ```

2. Manual Testing:

    - Access the Lightning page containing the component.
    - Verify CRUD operations.
    - Test error scenarios.

## Limitations

- Maximum of 50,000 records per batch job.
- API calls limited by Salesforce governor limits.
- Bulk operations limited to 10,000 records.
- Session timeout after 2 hours of inactivity.

## Security Considerations

- Field-level security enforced.
- CRUD/FLS checks implemented.
- Rate limiting applied to API endpoints.
