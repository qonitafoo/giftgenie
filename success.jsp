<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.CartItem" %>

<%
    String name = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("lastEmail");
    Double total = (Double) session.getAttribute("lastTotal");
    if (total == null) total = 0.0;

    List<CartItem> items = (List<CartItem>) session.getAttribute("lastItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Successful – Gift Genie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-soft mb-0">
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

<div class="container-fluid p-0 mb-5">
    <img src="images/banner1.jpg" alt="Gift Genie Banner" class="w-100" style="height: 300px; object-fit: cover;">
</div>

<div class="container mb-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            
            <div class="soft-card text-center pb-5">
                
                <div class="mb-4 display-1">🎉</div>
                
                <h2 class="fw-bold mb-3 text-success">Order Confirmed!</h2>
                <p class="text-muted mb-4">
                    Thank you, <strong><%= name %></strong>! <br>
                    A confirmation has been sent to <span class="text-primary"><%= email %></span>.
                </p>

                <div class="bg-light rounded-4 p-4 text-start mx-auto" style="max-width: 90%;">
                    <h5 class="fw-bold mb-3 text-secondary text-uppercase small ls-1">Order Summary</h5>
                    
                    <% if (items != null) { %>
                        <div class="d-flex flex-column gap-2 mb-3">
                        <% for (CartItem it : items) { %>
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="fw-bold text-dark"><%= it.getProduct().getName() %></span>
                                    <span class="text-muted small"> (x<%= it.getQty() %>)</span>
                                </div>
                                <span class="fw-bold text-muted">
                                    $<%= String.format("%.2f", it.getProduct().getPrice() * it.getQty()) %>
                                </span>
                            </div>
                        <% } %>
                        </div>
                    <% } %>

                    <hr style="border-top: 2px dashed #ccc; opacity: 0.5;">

                    <div class="d-flex justify-content-between align-items-center pt-2">
                        <span class="h5 fw-bold mb-0">Total Paid</span>
                        <span class="h4 fw-bold text-primary mb-0">$<%= String.format("%.2f", total) %></span>
                    </div>
                </div>

                <div class="mt-5 d-flex justify-content-center gap-3">
                    <a href="./" class="btn btn-outline-soft">Return Home</a>
                    <a href="catalog" class="btn btn-soft-primary px-4">Shop Again</a>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>