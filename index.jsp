<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String msg = request.getParameter("msg");
    String userName  = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    
    String mode = request.getParameter("mode");
    if (mode == null || mode.isEmpty()) mode = "login"; 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gift Genie – Home</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">

    <style>
        /* --- THEME STYLES --- */
        .text-primary { color: #7950f2 !important; }
        body { background-color: #f8f9fa; }
        
        .soft-card {
            border: none;
            border-radius: 20px;
            background: #ffffff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            padding: 2.5rem;
        }

        .btn-solid-primary {
            background-color: #7950f2;
            color: white;
            border: none;
            font-weight: 600;
        }
        .btn-solid-primary:hover {
            background-color: #5f3dc4;
            color: white;
            transform: translateY(-2px);
        }

        /* Input Fields */
        .form-control {
            background-color: #f3f0ff;
            border: 1px solid transparent;
            color: #495057;
            padding: 0.8rem 1rem;
            font-weight: 500;
        }
        .form-control:focus {
            background-color: #ffffff;
            border-color: #b197fc;
            box-shadow: 0 0 0 0.25rem rgba(121, 80, 242, 0.1);
        }

        /* Toggle Buttons */
        .toggle-container {
            background-color: #f8f9fa;
            border-radius: 50rem;
            padding: 0.3rem;
            border: 1px solid #eee;
        }
        .btn-toggle {
            border-radius: 50rem;
            border: none;
            font-weight: 600;
            color: #6c757d;
        }
        .btn-toggle.active {
            background-color: white;
            color: #7950f2;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        /* Soft Alert Colours */
        .alert-soft-success {
            background-color: #d3f9d8;
            color: #2b8a3e;
            border: 1px solid #b2f2bb;
        }
        .alert-soft-danger {
            background-color: #ffe3e3;
            color: #c92a2a;
            border: 1px solid #ffc9c9;
        }

        .navbar-soft {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-soft mb-5">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary" href="./">🎁 Gift Genie</a>
    <div class="navbar-nav ms-auto">
        <a class="nav-link active" href="./">Home</a>
        <a class="nav-link" href="catalog">Catalog</a>
        <a class="nav-link" href="cart">Cart</a>
        <% if (userName != null) { %>
            <a class="nav-link" href="checkout">Checkout</a>
            <a class="nav-link text-danger" href="logout">Logout</a>
        <% } %>
    </div>
  </div>
</nav>

<div class="container mb-5">
    <div class="mb-5 text-center">
        <img src="images/banner1.jpg" alt="Gift Genie Banner" class="img-fluid rounded-4 shadow-sm" style="max-height: 300px; width: 100%; object-fit: cover;">
    </div>

    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            
            <% 
            if (msg != null) { 
                boolean isSuccess = msg.toLowerCase().contains("created") || msg.toLowerCase().contains("success");
                String alertClass = isSuccess ? "alert-soft-success" : "alert-soft-danger";
            %>
                <div class="alert <%= alertClass %> rounded-pill border-0 text-center mb-4 shadow-sm" role="alert">
                    <%= msg %>
                </div>
            <% } %>

            <% if (userName == null) { %>
                <div class="soft-card">
                    <div class="text-center mb-4">
                        <h2 class="fw-bold text-dark"><%= "signup".equalsIgnoreCase(mode) ? "Join Us!" : "Welcome Back" %></h2>
                        <p class="text-muted">Find the perfect gift today.</p>
                    </div>

                    <div class="toggle-container d-flex mb-4">
                        <a href="./?mode=login" class="btn btn-toggle w-50 <%= "login".equals(mode) ? "active" : "" %>">Login</a>
                        <a href="./?mode=signup" class="btn btn-toggle w-50 <%= "signup".equals(mode) ? "active" : "" %>">Sign Up</a>
                    </div>

                    <form method="post" action="auth">
                        <input type="hidden" name="mode" value="<%= mode %>"/>

                        <% if ("signup".equalsIgnoreCase(mode)) { %>
                        <div class="mb-3">
                            <label class="form-label ms-2 small fw-bold text-muted text-uppercase">Name</label>
                            <input type="text" name="name" class="form-control rounded-pill" placeholder="Your Name" required/>
                        </div>
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label ms-2 small fw-bold text-muted text-uppercase">Email</label>
                            <input type="email" name="email" class="form-control rounded-pill" placeholder="name@email.com" required/>
                        </div>

                        <div class="mb-4">
                            <label class="form-label ms-2 small fw-bold text-muted text-uppercase">Password</label>
                            <input type="password" name="password" class="form-control rounded-pill" placeholder="••••••" required/>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-solid-primary btn-lg rounded-pill shadow-sm">
                                <%= "signup".equalsIgnoreCase(mode) ? "Create Account" : "Login" %>
                            </button>
                        </div>
                    </form>
                </div>

            <% } else { %>
            
                <div class="soft-card text-center py-5">
                    <div class="mb-3 display-1">🧞‍♂️</div>
                    <h2 class="fw-bold text-dark">Hi, <%= userName %>!</h2>
                    <p class="text-muted mb-4">You are logged in as <br><strong><%= userEmail %></strong></p>
                    
                    <div class="d-grid gap-2 col-8 mx-auto">
                        <a href="catalog" class="btn btn-solid-primary rounded-pill py-3">Browse Catalog</a>
                        <a href="logout" class="btn btn-link text-muted text-decoration-none mt-2">Logout</a>
                    </div>
                </div>
            <% } %>