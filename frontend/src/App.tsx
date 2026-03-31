import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./Views/LoginPage";
import SignUpPage from "./Views/SignUpPage";
import WelcomePage from "./Views/WelcomePage";
import ProtectedRoute from "./Views/ProtectedRoute";
function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/login" replace />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/signup" element={<SignUpPage />} />
        <Route
          path="/welcome"
          element={
            <ProtectedRoute>
              <WelcomePage />
            </ProtectedRoute>
          }
        />
      </Routes>
    </BrowserRouter>
  );
}

export default App;