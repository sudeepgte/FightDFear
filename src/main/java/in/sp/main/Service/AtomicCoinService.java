package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WalletTransaction;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WalletTransactionRepository;

@Service
public class AtomicCoinService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WalletTransactionRepository walletTransactionRepository;

    @Transactional
    public User debitCoins(Long userId, int amount, String description) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User ID is required.");
        }
        if (amount <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Debit amount must be positive.");
        }

        User user = userRepository.findByIdForUpdate(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found."));

        int current = user.getRewardPoints() == null ? 0 : user.getRewardPoints();
        if (current < amount) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Insufficient coins.");
        }

        int newBalance = current - amount;
        user.setRewardPoints(newBalance);
        User saved = userRepository.save(user);

        WalletTransaction tx = new WalletTransaction(
                saved, (double) amount, "DEBIT",
                description == null || description.isBlank() ? "Reward coins debit" : description.trim(),
                LocalDateTime.now()
        );
        walletTransactionRepository.save(tx);

        return saved;
    }

    @Transactional
    public User creditCoins(Long userId, int amount, String description) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User ID is required.");
        }
        if (amount <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Credit amount must be positive.");
        }

        User user = userRepository.findByIdForUpdate(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found."));


        int current = user.getRewardPoints() == null ? 0 : user.getRewardPoints();
        int newBalance = current + amount;
        user.setRewardPoints(newBalance);
        User saved = userRepository.save(user);

        WalletTransaction tx = new WalletTransaction(
                saved, (double) amount, "CREDIT",
                description == null || description.isBlank() ? "Reward coins credit" : description.trim(),
                LocalDateTime.now()
        );
        walletTransactionRepository.save(tx);

        return saved;
    }
}
