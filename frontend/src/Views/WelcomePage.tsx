import React from "react";
import { useNavigate } from "react-router-dom";
import "../style/WelcomePage.css";

const WelcomePage: React.FC = () => {
  const navigate = useNavigate();

  const authUserRaw = localStorage.getItem("authUser");
  const authUser = authUserRaw ? JSON.parse(authUserRaw) : null;

  const handleLogout = () => {
    localStorage.removeItem("authUser");
    localStorage.removeItem("rememberedEmail");
    localStorage.removeItem("rememberMe");
    navigate("/login");
  };

  return (
    <div className="welcome-page">
      <div className="welcome-card">
        <h1 className="welcome-title">Welcome!</h1>

        <p className="welcome-text">
          Login successful.
        </p>

        {authUser && (
          <p className="welcome-email">
            Logged in as: <span>{authUser.email}</span>
          </p>
        )}

        <button className="welcome-btn primary-btn" onClick={handleLogout}>
          Logout
        </button>
      </div>
    </div>
  );
};

export default WelcomePage;