package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WalletTransaction;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WalletTransactionRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wallet")
public class MobileWalletController {

    @Autowired
    private UserRepository userRepo;
    @Autowired
    private WalletTransactionRepository walletTransactionRepo;

    @GetMapping
    public ResponseEntity<Map<String, Object>> wallet(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        User fresh = userRepo.findById(user.getId()).orElse(user);
        int points = fresh.getRewardPoints() == null ? 0 : fresh.getRewardPoints();
        List<Map<String, Object>> tx = walletTransactionRepo.findByUser_IdOrderByTransactionDateDesc(user.getId())
                .stream().map(this::txDto).toList();
        List<String> rewards = List.of(
                "10% Off Salon Service - 100 Coins",
                "Free Martial Arts Trial - 200 Coins",
                "Exclusive Badge - 50 Coins"
        );
        return ResponseEntity.ok(ok(Map.of(
                "rewardPoints", points,
                "transactions", tx,
                "rewards", rewards
        )));
    }

    @PostMapping("/redeem")
    public ResponseEntity<Map<String, Object>> redeem(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        int cost = body.get("cost") instanceof Number n ? n.intValue() : 0;
        String rewardName = body.get("rewardName") == null ? "Reward" : body.get("rewardName").toString();
        User fresh = userRepo.findById(user.getId()).orElse(null);
        if (fresh == null) return badRequest("User not found");
        int current = fresh.getRewardPoints() == null ? 0 : fresh.getRewardPoints();
        if (current < cost) return badRequest("Insufficient coins");
        fresh.setRewardPoints(current - cost);
        userRepo.save(fresh);
        session.setAttribute("user", fresh);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Successfully redeemed: " + rewardName,
                "rewardPoints", fresh.getRewardPoints()
        )));
    }

    private Map<String, Object> txDto(WalletTransaction t) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("amount", t.getAmount());
        m.put("type", t.getType());
        m.put("description", t.getDescription());
        m.put("transactionDate", t.getTransactionDate() == null ? null : t.getTransactionDate().toString());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }
}
