<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>

<%
  List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
  if (cart == null) cart = new ArrayList<>();

  Object totalObj = request.getAttribute("total");
  double total = (totalObj == null) ? 0.0 : (double) totalObj;

  String error = (String) request.getAttribute("error");

  // Prefill values
  String name = (String) request.getAttribute("name");
  String email = (String) request.getAttribute("email");
  String address = (String) request.getAttribute("address1");
  String cardNumber = (String) request.getAttribute("cardNumber");
  String expiry = (String) request.getAttribute("expiry");
  String cvv = (String) request.getAttribute("cvv");

  if (name == null) name = "";
  if (email == null) email = "";
  if (address == null) address = "";
  if (cardNumber == null) cardNumber = "";
  if (expiry == null) expiry = "";
  if (cvv == null) cvv = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gift Genie – Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    
    <style>
        .summary-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 10px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-soft mb-0">
  <div class="container">
    <a class="navbar-brand text-primary fw-bold" href="./">🎁 Gift Genie</a>
    <div class="navbar-nav ms-auto">
        <a class="nav-link" href="./">Home</a>
        <a class="nav-link" href="catalog">Catalog</a>
        <a class="nav-link" href="cart">Cart</a>
        <a class="nav-link active" href="checkout">Checkout</a>
    </div>
  </div>
</nav>

<div class="container-fluid p-0 mb-5">
    <img src="images/banner1.jpg" alt="Gift Genie Banner" class="w-100" style="height: 250px; object-fit: cover;">
</div>

<div class="container mb-5">
    
    <h2 class="fw-bold mb-4">Secure Checkout</h2>

    <% if (cart.isEmpty()) { %>
        <div class="text-center py-5 soft-card">
            <h3 class="text-muted mb-3">Your cart is empty. 🛒</h3>
            <p>You need to choose a gift before checking out!</p>
            <a href="catalog" class="btn btn-soft-primary mt-2">Back to Catalog</a>
        </div>
    <% } else { %>

    <div class="row">
        
        <div class="col-lg-8 mb-4">
            
            <% if (error != null) { %>
                <div class="alert alert-danger rounded-3 border-0 mb-4 shadow-sm">
                    ⚠️ <%= error %>
                </div>
            <% } %>

            <form action="checkout" method="post">
                
                <div class="soft-card mb-4">
                    <h4 class="fw-bold mb-3 text-primary">1. Shipping Details</h4>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">Full Name</label>
                            <input type="text" name="name" class="form-control" value="<%= name %>" placeholder="Eva Plucky" required />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" value="<%= email %>" placeholder="eva@example.com" required />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">Shipping Address</label>
                        <input type="text" name="address1" class="form-control" value="<%= address %>" placeholder="123 Sesame Street, Malaysia" required />
                    </div>
                </div>

                <div class="soft-card">
                    <h4 class="fw-bold mb-3 text-primary">2. Payment Method</h4>
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">Card Number</label>
                        <input type="text" name="cardNumber" class="form-control" value="<%= cardNumber %>" placeholder="0000 0000 0000 0000" required />
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">Expiry (MM/YY)</label>
                            <input type="text" name="expiry" class="form-control" value="<%= expiry %>" placeholder="12/25" maxlength="5" required />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">CVV</label>
                            <input type="text" name="cvv" class="form-control" value="<%= cvv %>" placeholder="123" maxlength="4" required />
                        </div>
                    </div>

                    <hr class="my-4 opacity-25">

                    <button type="submit" class="btn btn-soft-primary btn-lg w-100 py-3 shadow-sm">
                        Confirm Order ($<%= String.format("%.2f", total) %>)
                    </button>
                    
                    <div class="text-center mt-3">
                        <a href="cart" class="text-muted small text-decoration-none">Return to Cart</a>
                    </div>
                </div>

            </form>
        </div>

        <div class="col-lg-4">
            <div class="soft-card">
                <h4 class="fw-bold mb-4">Order Summary</h4>
                
                <div style="max-height: 400px; overflow-y: auto; padding-right: 5px;">
                    <%
                        for (CartItem it : cart) {
                        Product p = it.getProduct();
                        String pname = p.getName();
                        double price = p.getPrice();
                        int qty = it.getQty();
                        String img = p.getImage();
                    %>
                    <div class="d-flex align-items-center mb-3">
                        <img src="images/<%= img %>" alt="<%= pname %>" class="summary-img border">
                        <div class="ms-3 flex-grow-1 line-height-sm">
                            <div class="fw-bold text-dark" style="font-size: 0.95rem;"><%= pname %></div>
                            <div class="text-muted small">Qty: <%= qty %></div>
                        </div>
                        <div class="fw-bold text-end">
                            $<%= String.format("%.2f", price * qty) %>
                        </div>
                    </div>
                    <% } %>
                </div>

                <hr class="text-muted opacity-25 my-3">

                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Subtotal</span>
                    <span class="fw-bold">$<%= String.format("%.2f", total) %></span>
                </div>
                <div class="d-flex justify-content-between mb-4">
                    <span class="text-muted">Shipping</span>
                    <span class="text-success fw-bold">Free</span>
                </div>

                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                    <span class="h5 fw-bold mb-0">Total</span>
                    <span class="h4 fw-bold text-primary mb-0">$<%= String.format("%.2f", total) %></span>
                </div>
            </div>
        </div>

    </div> <% } %>

</div>

</body>
</html>