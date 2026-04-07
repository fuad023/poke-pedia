import React from "react";
import { BrowserRouter } from "react-router-dom";
import LoginPage from "./Views/LoginPage";
import SignUpPage from "./Views/SignUpPage";

function App() {
  return (
    <BrowserRouter>
      <LoginPage />
    </BrowserRouter>
  );
}

export default App;