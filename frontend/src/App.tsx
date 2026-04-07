import React from "react";
import { BrowserRouter } from "react-router-dom";
import LoginPage from "./Views/LoginPage";
import SignUpPage from "./Views/SignUpPage";
import PokemonDetailsPage from "./Views/PokemonDetailsPage";

function App() {
  return (
    <BrowserRouter>
      <PokemonDetailsPage />
    </BrowserRouter>
  );
}

export default App;