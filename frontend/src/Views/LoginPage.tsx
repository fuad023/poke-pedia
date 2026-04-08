import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import "../style/LoginPage.css";

type IconType = "email" | "lock" | "eye" | "eyeOff";

const Icon: React.FC<{ type: IconType }> = ({ type }) => {
  switch (type) {
    case "email":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="login-input-icon-svg">
          <path
            d="M4 6h16v12H4V6Zm0 1 8 6 8-6"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    case "lock":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="login-input-icon-svg">
          <path
            d="M7 10V8a5 5 0 1 1 10 0v2M6 10h12v10H6V10Z"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    case "eye":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="login-input-icon-svg">
          <path
            d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6-10-6-10-6Z"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2" />
        </svg>
      );

    case "eyeOff":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="login-input-icon-svg">
          <path
            d="M3 3l18 18M10.58 10.58A2 2 0 0 0 12 15a2 2 0 0 0 1.42-.58"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <path
            d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a17.59 17.59 0 0 1-3.06 3.8M6.61 6.61C4.46 8.07 3 10 2 12c0 0 3.5 7 10 7 1.94 0 3.63-.48 5.08-1.2"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    default:
      return null;
  }
};

type LoginDataType = {
  email: string;
  password: string;
  remember: boolean;
};

type LoginErrorsType = {
  email?: string;
  password?: string;
};

const LoginPage: React.FC = () => {
  const [showPassword, setShowPassword] = useState(false);

  const [loginData, setLoginData] = useState<LoginDataType>({
    email: "",
    password: "",
    remember: false,
  });

  const [errors, setErrors] = useState<LoginErrorsType>({});
  const navigate = useNavigate();

  useEffect(() => {
    const savedEmail = localStorage.getItem("rememberedEmail");
    const savedRemember = localStorage.getItem("rememberMe");

    if (savedEmail && savedRemember === "true") {
      setLoginData((prev) => ({
        ...prev,
        email: savedEmail,
        remember: true,
      }));
    }
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type, checked } = e.target;

    setLoginData((prev) => ({
      ...prev,
      [name]: type === "checkbox" ? checked : value,
    }));

    setErrors((prev) => ({
      ...prev,
      [name]: "",
    }));
  };

  const validateLoginForm = () => {
    const newErrors: LoginErrorsType = {};

    if (!loginData.email.trim()) {
      newErrors.email = "Email is required";
    } else if (!/^\S+@\S+\.\S+$/.test(loginData.email)) {
      newErrors.email = "Enter a valid email address";
    }

    if (!loginData.password.trim()) {
      newErrors.password = "Password is required";
    }

    return newErrors;
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const validationErrors = validateLoginForm();
    setErrors(validationErrors);

    if (Object.keys(validationErrors).length !== 0) {
      return;
    }

    if (loginData.remember) {
      localStorage.setItem("rememberedEmail", loginData.email);
      localStorage.setItem("rememberMe", "true");
    } else {
      localStorage.removeItem("rememberedEmail");
      localStorage.removeItem("rememberMe");
    }

    navigate("/pokemon-table");
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-left">
          <div className="login-left-inner">
            <h1 className="login-title">Hello!</h1>
            <p className="login-subtitle">Sign in to your account</p>

            <form className="login-form" onSubmit={handleSubmit}>
              <div className="login-field-block">
                <div
                  className={`login-input-group ${
                    errors.email ? "login-input-error" : ""
                  }`}
                >
                  <span className="login-input-icon">
                    <Icon type="email" />
                  </span>
                  <input
                    type="email"
                    name="email"
                    placeholder="E-mail"
                    value={loginData.email}
                    onChange={handleChange}
                  />
                </div>
                {errors.email && (
                  <p className="login-error-text">{errors.email}</p>
                )}
              </div>

              <div className="login-field-block">
                <div
                  className={`login-input-group ${
                    errors.password ? "login-input-error" : ""
                  }`}
                >
                  <span className="login-input-icon">
                    <Icon type="lock" />
                  </span>
                  <input
                    type={showPassword ? "text" : "password"}
                    name="password"
                    placeholder="Password"
                    value={loginData.password}
                    onChange={handleChange}
                  />
                  <button
                    type="button"
                    className="login-toggle-password"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    <Icon type={showPassword ? "eyeOff" : "eye"} />
                  </button>
                </div>
                {errors.password && (
                  <p className="login-error-text">{errors.password}</p>
                )}
              </div>

              <div className="login-options">
                <label className="remember-row">
                  <input
                    type="checkbox"
                    name="remember"
                    checked={loginData.remember}
                    onChange={handleChange}
                  />
                  <span>Remember me</span>
                </label>

                <a
                  href="/"
                  onClick={(e) => e.preventDefault()}
                  className="forgot-link"
                >
                  Forgot password?
                </a>
              </div>

              <button type="submit" className="login-btn">
                SIGN IN
              </button>

              <p className="create-account-text">
                Don't have an account? <Link to="/signup">Create</Link>
              </p>
            </form>
          </div>
        </div>

        <div className="login-right">
          <div className="login-right-content">
            <h2>Welcome Back!</h2>
            <p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce
              vitae mauris volutpat
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;