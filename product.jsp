<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Product" %>

<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        response.sendRedirect("catalog");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= p.getName() %> – Gift Genie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    
    <style>
        /* 1. SOFT UI BUTTONS */
        .btn-soft-primary {
            background-color: #f3f0ff;
            color: #7950f2;
            border: 1px solid #d0bfff;
            font-weight: 600;
        }
        .btn-soft-primary:hover {
            background-color: #e5dbff;
            color: #5f3dc4;
            border-color: #b197fc;
        }

        .btn-outline-soft {
            border: 1px solid #dee2e6;
            color: #6c757d;
            background: white;
            font-weight: 600;
        }
        .btn-outline-soft:hover {
            background-color: #f8f9fa;
            color: #495057;
        }

        /* 2. BADGE STYLES */
        .badge-soft-purple {
            background-color: #f3f0ff;
            color: #7950f2;
            border: 1px solid #d0bfff;
            font-weight: 600;
            padding: 5px 10px;
        }

        .badge-soft-yellow {
            background-color: #fff9db;
            color: #e6b800;
            border: 1px solid #ffe066;
            font-weight: 600;
            padding: 5px 10px;
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-soft mb-0 bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand text-primary fw-bold" href="./">🎁 Gift Genie</a>
    <div class="navbar-nav ms-auto">
        <a class="nav-link" href="./">Home</a>
        <a class="nav-link" href="catalog">Catalog</a>
        <a class="nav-link" href="cart">Cart</a>
        <a class="nav-link" href="checkout">Checkout</a>
    </div>
  </div>
</nav>

<div class="container py-5">
    
    <nav aria-label="breadcrumb" class="mb-4">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="catalog" class="text-decoration-none text-muted">Catalog</a></li>
        <li class="breadcrumb-item active text-primary fw-bold" aria-current="page"><%= p.getName() %></li>
      </ol>
    </nav>

    <div class="row g-5 align-items-center">
        <div class="col-md-6">
            <div class="soft-card p-1 border-0 shadow-sm rounded-4 overflow-hidden">
                <img src="images/<%= p.getImage() %>" alt="<%= p.getName() %>" class="w-100 rounded-4">
            </div>
        </div>

        <div class="col-md-6">
            <div class="h-100 ps-md-4">
                
                <div class="mb-3">
                    <span class="badge badge-soft-purple rounded-pill me-1"><%= p.getOccasion() %></span>
                    
                    <% 
                    if (p.getMoments() != null) {
                        for (String m : p.getMoments()) {
                    %>
                        <span class="badge badge-soft-yellow rounded-pill me-1"><%= m %></span>
                    <% 
                        }
                    } 
                    %>
                </div>

                <h1 class="display-5 fw-bold mb-3 text-dark"><%= p.getName() %></h1>
                <h2 class="text-primary fw-bold mb-4">$<%= String.format("%.2f", p.getPrice()) %></h2>
                
                <p class="lead text-muted mb-5" style="font-size: 1.1rem; line-height: 1.6;">
                    <%= p.getDescription() %>
                </p>

                <form method="post" action="cart">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="id" value="<%= p.getId() %>" />
                    <input type="hidden" name="redirect" value="product?id=<%= p.getId() %>" />

                    <div class="d-grid gap-3">
                        <button type="submit" class="btn btn-soft-primary btn-lg rounded-pill py-3">
                            Add to Cart
                        </button>
                        
                        <a href="catalog" class="btn btn-outline-soft btn-lg rounded-pill py-3">
                            Continue Shopping
                        </a>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

</body>
</html>