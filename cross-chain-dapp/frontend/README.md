# Frontend Documentation for Cross-Chain dApp

## Overview

This document provides instructions for setting up and using the frontend of the Cross-Chain Decentralized Application (dApp) that integrates Movement Labs’ Move and EVM support with Polygon AggLayer for interoperability.

## Prerequisites

Before you begin, ensure you have the following installed:

- Node.js (version 14 or higher)
- npm (Node package manager)

## Installation

1. Clone the repository:

   ```
   git clone <repository-url>
   cd cross-chain-dapp/frontend
   ```

2. Install the dependencies:

   ```
   npm install
   ```

## Running the Application

To start the development server, run:

```
npm start
```

This will launch the application in your default web browser at `http://localhost:3000`.

## Building for Production

To create a production build of the application, run:

```
npm run build
```

The build artifacts will be stored in the `build` directory.

## Folder Structure

- `src/components`: Contains reusable React components.
- `src/pages`: Contains the main pages of the application.
- `src/styles`: Contains CSS styles for the application.
- `src/index.tsx`: The entry point for the React application.

## Contributing

If you would like to contribute to the project, please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.