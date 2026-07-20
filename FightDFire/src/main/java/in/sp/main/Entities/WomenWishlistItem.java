package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "women_wishlist_items")
public class WomenWishlistItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private WomenProduct product;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public WomenProduct getProduct() { return product; }
    public void setProduct(WomenProduct product) { this.product = product; }
}
