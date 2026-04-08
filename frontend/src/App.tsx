import React from "react";
import { BrowserRouter } from "react-router-dom";
import LoginPage from "./Views/LoginPage";
import SignUpPage from "./Views/SignUpPage";
import PokemonDetailsPage from "./Views/PokemonDetailsPage";
import PokemonModernTable from "./Views/PokemonModernTable";

function App() {
  return (
    <BrowserRouter>
      <PokemonModernTable/>
    </BrowserRouter>
  );
}

export default App;