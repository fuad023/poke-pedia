import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./Views/LoginPage";
import SignUpPage from "./Views/SignUpPage";
import PokemonDetailsPage from "./Views/PokemonDetailsPage";
import PokemonModernTable from "./Views/PokemonModernTable";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/login" replace />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/signup" element={<SignUpPage />} />
        <Route path="/pokemon-table" element={<PokemonModernTable />} />
        <Route path="/pokemon/:id" element={<PokemonDetailsPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;