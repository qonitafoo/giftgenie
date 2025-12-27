package model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private Product product;
    private int qty;

    public CartItem(Product product, int qty) {
        this.product = product;
        this.qty = qty;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public void inc() { this.qty++; }
    public void dec() { if (this.qty > 1) this.qty--; }
    
    public void addQty(int n) { this.qty += n; }

    public double getTotal() {
        if (product == null) return 0.0;
        return product.getPrice() * qty;
    }
}