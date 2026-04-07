import React, { useState } from "react";
import { Link } from "react-router-dom";
import "../style/SignUpPage.css";

type IconType = "user" | "email" | "phone" | "lock" | "eye" | "eyeOff";

const Icon: React.FC<{ type: IconType }> = ({ type }) => {
  switch (type) {
    case "user":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
          <path
            d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm-7 8a7 7 0 1 1 14 0"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    case "email":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
          <path
            d="M4 6h16v12H4V6Zm0 1 8 6 8-6"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    case "phone":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
          <path
            d="M8 3h8a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Zm3 15h2"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );

    case "lock":
      return (
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
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
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
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
        <svg viewBox="0 0 24 24" fill="none" className="input-icon-svg">
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

type FormDataType = {
  name: string;
  email: string;
  phone: string;
  password: string;
  confirmPassword: string;
  agree: boolean;
};

type FormErrorsType = {
  name?: string;
  email?: string;
  phone?: string;
  password?: string;
  confirmPassword?: string;
  agree?: string;
};

const SignUpPage: React.FC = () => {
  /* ─────────────────────────────────────────────────────────
     State
  ───────────────────────────────────────────────────────── */
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [formData, setFormData] = useState<FormDataType>({
    name: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
    agree: false,
  });

  const [errors, setErrors] = useState<FormErrorsType>({});

  /* ─────────────────────────────────────────────────────────
     Input change handler
  ───────────────────────────────────────────────────────── */
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type, checked } = e.target;

    setFormData((prev) => ({
      ...prev,
      [name]: type === "checkbox" ? checked : value,
    }));

    setErrors((prev) => ({
      ...prev,
      [name]: "",
    }));
  };

  /* ─────────────────────────────────────────────────────────
     Validation
  ───────────────────────────────────────────────────────── */
  const validateForm = () => {
    const newErrors: FormErrorsType = {};

    if (!formData.name.trim()) {
      newErrors.name = "Name is required";
    }

    if (!formData.email.trim()) {
      newErrors.email = "Email is required";
    } else if (!/^\S+@\S+\.\S+$/.test(formData.email)) {
      newErrors.email = "Enter a valid email address";
    }

    if (!formData.phone.trim()) {
      newErrors.phone = "Phone number is required";
    } else if (!/^[0-9]{11,15}$/.test(formData.phone)) {
      newErrors.phone = "Phone number must be 11 to 15 digits";
    }

    if (!formData.password) {
      newErrors.password = "Password is required";
    } else if (formData.password.length < 8) {
      newErrors.password = "Password should be at least 8 characters";
    }

    if (!formData.confirmPassword) {
      newErrors.confirmPassword = "Confirm password is required";
    } else if (formData.confirmPassword !== formData.password) {
      newErrors.confirmPassword = "Passwords do not match";
    }

    if (!formData.agree) {
      newErrors.agree = "You must agree to Terms & Conditions";
    }

    return newErrors;
  };

  /* ─────────────────────────────────────────────────────────
     Submit
  ───────────────────────────────────────────────────────── */
const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
  e.preventDefault();

  const validationErrors = validateForm();
  setErrors(validationErrors);

  if (Object.keys(validationErrors).length !== 0) {
    return;
  }

};

  return (
    <div className="signup-page">
      <div className="signup-card">
        <div className="signup-left">
          <h1 className="signup-title">Hello, friend!</h1>

          <form className="signup-form" onSubmit={handleSubmit}>
            {/* Name */}
            <div className="field-block">
              <div className={`input-group ${errors.name ? "input-error" : ""}`}>
                <span className="input-icon">
                  <Icon type="user" />
                </span>
                <input
                  type="text"
                  name="name"
                  placeholder="Name"
                  value={formData.name}
                  onChange={handleChange}
                />
              </div>
              {errors.name && <p className="error-text">{errors.name}</p>}
            </div>

            {/* Email */}
            <div className="field-block">
              <div className={`input-group ${errors.email ? "input-error" : ""}`}>
                <span className="input-icon">
                  <Icon type="email" />
                </span>
                <input
                  type="email"
                  name="email"
                  placeholder="E-mail"
                  value={formData.email}
                  onChange={handleChange}
                />
              </div>
              {errors.email && <p className="error-text">{errors.email}</p>}
            </div>

            {/* Phone */}
            <div className="field-block">
              <div className={`input-group ${errors.phone ? "input-error" : ""}`}>
                <span className="input-icon">
                  <Icon type="phone" />
                </span>
                <input
                  type="tel"
                  name="phone"
                  placeholder="Phone Number"
                  value={formData.phone}
                  onChange={handleChange}
                />
              </div>
              {errors.phone && <p className="error-text">{errors.phone}</p>}
            </div>

            {/* Password */}
            <div className="field-block">
              <div className={`input-group ${errors.password ? "input-error" : ""}`}>
                <span className="input-icon">
                  <Icon type="lock" />
                </span>
                <input
                  type={showPassword ? "text" : "password"}
                  name="password"
                  placeholder="Password"
                  value={formData.password}
                  onChange={handleChange}
                />
                <button
                  type="button"
                  className="toggle-password"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  <Icon type={showPassword ? "eyeOff" : "eye"} />
                </button>
              </div>
              {errors.password && <p className="error-text">{errors.password}</p>}
            </div>

            {/* Confirm Password */}
            <div className="field-block">
              <div
                className={`input-group ${errors.confirmPassword ? "input-error" : ""}`}
              >
                <span className="input-icon">
                  <Icon type="lock" />
                </span>
                <input
                  type={showConfirmPassword ? "text" : "password"}
                  name="confirmPassword"
                  placeholder="Confirm Password"
                  value={formData.confirmPassword}
                  onChange={handleChange}
                />
                <button
                  type="button"
                  className="toggle-password"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                >
                  <Icon type={showConfirmPassword ? "eyeOff" : "eye"} />
                </button>
              </div>
              {errors.confirmPassword && (
                <p className="error-text">{errors.confirmPassword}</p>
              )}
            </div>

            {/* Terms */}
            <label className="terms-row">
              <input
                type="checkbox"
                name="agree"
                checked={formData.agree}
                onChange={handleChange}
              />
              <span>
                I read and agree to <a href="/">Terms &amp; Conditions</a>
              </span>
            </label>
            {errors.agree && <p className="error-text terms-error">{errors.agree}</p>}

            <button type="submit" className="create-btn">
              CREATE ACCOUNT
            </button>

            <p className="signin-text">
           Already have an account? <Link to="/login">Sign in</Link>
            </p>

          </form>
        </div>

        <div className="signup-right">
          <div className="signup-right-content">
            <h2>Glad to see you!</h2>
            <p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam
              dignissim.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SignUpPage;