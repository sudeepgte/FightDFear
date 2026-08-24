package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Mobile JSON APIs for pitch deck, meetings, chat, notifications, subscribe, and released funds.
 */
@RestController
public class MobileFundingCollaborationController {

    @Autowired private EntrepreneurRepository entrepreneurRepository;
    @Autowired private InvestorRepository investorRepository;
    @Autowired private BusinessProposalRepository businessProposalRepository;
    @Autowired private InvestmentRepository investmentRepository;
    @Autowired private InvestmentMeetingRepository meetingRepository;
    @Autowired private ProposalChatMessageRepository chatRepository;
    @Autowired private FileUploadService fileUploadService;
    @Autowired private in.sp.main.Service.FundingCareService fundingCareService;

    // ── Pitch deck ──────────────────────────────────────────────────────────

    @PostMapping(value = "/api/entrepreneur/proposals/{id}/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPitch(
            @PathVariable Long id,
            @RequestParam(value = "document", required = false) MultipartFile document,
            @RequestParam(value = "videoPitch", required = false) MultipartFile videoPitch,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        BusinessProposal p = businessProposalRepository.findById(id).orElse(null);
        if (p == null || p.getEntrepreneur() == null || !p.getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Proposal not found");
        }
        if ((document == null || document.isEmpty()) && (videoPitch == null || videoPitch.isEmpty())) {
            return badRequest("Upload a pitch deck document and/or video");
        }
        try {
            if (document != null && !document.isEmpty()) {
                String path = fileUploadService.saveFile(document);
                p.setDocuments(path);
                e.setDocumentsPath(path);
            }
            if (videoPitch != null && !videoPitch.isEmpty()) {
                String path = fileUploadService.saveFile(videoPitch);
                p.setVideoPitch(path);
                e.setVideoPitchPath(path);
            }
            if (p.getStatus() == VerificationStatus.VERIFIED) {
                p.setStatus(VerificationStatus.PENDING);
            }
            businessProposalRepository.save(p);
            entrepreneurRepository.save(e);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Pitch materials uploaded"
                    + (p.getStatus() == VerificationStatus.PENDING ? " — proposal sent for re-approval" : ""));
            data.put("proposal", proposalBrief(p));
            data.put("documentsPath", e.getDocumentsPath());
            data.put("videoPitchPath", e.getVideoPitchPath());
            return ResponseEntity.ok(ok(data));
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    @PostMapping(value = "/api/entrepreneur/pitch/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadEntrepreneurPitch(
            @RequestParam(value = "document", required = false) MultipartFile document,
            @RequestParam(value = "videoPitch", required = false) MultipartFile videoPitch,
            @RequestParam(value = "proposalId", required = false) Long proposalId,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        if ((document == null || document.isEmpty()) && (videoPitch == null || videoPitch.isEmpty())) {
            return badRequest("Upload a pitch deck document and/or video");
        }
        try {
            if (document != null && !document.isEmpty()) {
                e.setDocumentsPath(fileUploadService.saveFile(document));
            }
            if (videoPitch != null && !videoPitch.isEmpty()) {
                e.setVideoPitchPath(fileUploadService.saveFile(videoPitch));
            }
            entrepreneurRepository.save(e);
            if (proposalId != null) {
                BusinessProposal p = businessProposalRepository.findById(proposalId).orElse(null);
                if (p != null && p.getEntrepreneur() != null && p.getEntrepreneur().getId().equals(e.getId())) {
                    if (e.getDocumentsPath() != null) p.setDocuments(e.getDocumentsPath());
                    if (e.getVideoPitchPath() != null) p.setVideoPitch(e.getVideoPitchPath());
                    if (p.getStatus() == VerificationStatus.VERIFIED) {
                        p.setStatus(VerificationStatus.PENDING);
                    }
                    businessProposalRepository.save(p);
                }
            }
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Pitch materials saved");
            data.put("documentsPath", e.getDocumentsPath());
            data.put("videoPitchPath", e.getVideoPitchPath());
            return ResponseEntity.ok(ok(data));
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    // ── Meetings ────────────────────────────────────────────────────────────

    @GetMapping("/api/entrepreneur/meetings")
    public ResponseEntity<Map<String, Object>> entrepreneurMeetings(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        List<Map<String, Object>> items = meetingRepository.findByProposal_Entrepreneur_Id(e.getId())
                .stream().map(this::meetingDto).toList();
        return ResponseEntity.ok(ok(Map.of("meetings", items, "count", items.size())));
    }

    @PostMapping("/api/entrepreneur/meetings/{id}/accept")
    @Transactional
    public ResponseEntity<Map<String, Object>> acceptMeeting(@PathVariable Long id, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        InvestmentMeeting m = meetingRepository.findById(id).orElse(null);
        if (m == null || m.getProposal() == null || m.getProposal().getEntrepreneur() == null
                || !m.getProposal().getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Meeting not found");
        }
        m.setStatus("ACCEPTED");
        meetingRepository.save(m);
        return ResponseEntity.ok(ok(Map.of("message", "Meeting accepted", "meeting", meetingDto(m))));
    }

    @PostMapping("/api/entrepreneur/meetings/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectMeeting(@PathVariable Long id, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        InvestmentMeeting m = meetingRepository.findById(id).orElse(null);
        if (m == null || m.getProposal() == null || m.getProposal().getEntrepreneur() == null
                || !m.getProposal().getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Meeting not found");
        }
        m.setStatus("REJECTED");
        meetingRepository.save(m);
        return ResponseEntity.ok(ok(Map.of("message", "Meeting rejected", "meeting", meetingDto(m))));
    }

    @PostMapping("/api/entrepreneur/meetings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> entrepreneurCancelMeeting(@PathVariable Long id, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        InvestmentMeeting m = meetingRepository.findById(id).orElse(null);
        if (m == null || m.getProposal() == null || m.getProposal().getEntrepreneur() == null
                || !m.getProposal().getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Meeting not found");
        }
        try {
            fundingCareService.cancelMeeting(m);
            return ResponseEntity.ok(ok(Map.of("message", "Meeting cancelled", "meeting", meetingDto(m))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/api/investor/meetings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> investorCancelMeeting(@PathVariable Long id, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        InvestmentMeeting m = meetingRepository.findById(id).orElse(null);
        if (m == null || m.getInvestor() == null || !m.getInvestor().getId().equals(inv.getId())) {
            return badRequest("Meeting not found");
        }
        try {
            fundingCareService.cancelMeeting(m);
            return ResponseEntity.ok(ok(Map.of("message", "Meeting cancelled", "meeting", meetingDto(m))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/api/investor/meetings")
    public ResponseEntity<Map<String, Object>> investorMeetings(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        List<Map<String, Object>> items = meetingRepository.findByInvestor(inv)
                .stream().map(this::meetingDto).toList();
        return ResponseEntity.ok(ok(Map.of("meetings", items, "count", items.size())));
    }

    @PostMapping("/api/investor/proposals/{id}/meetings")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestMeeting(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        if (inv.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Investor must be verified"));
        }
        if (!inv.isSubscribed()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Premium subscription required to request meetings"));
        }
        BusinessProposal proposal = businessProposalRepository.findById(id).orElse(null);
        if (proposal == null || proposal.getStatus() != VerificationStatus.VERIFIED) {
            return badRequest("Proposal not available");
        }
        String meetingTimeRaw = trim(Objects.toString(body == null ? null : body.get("meetingTime"), ""));
        if (meetingTimeRaw.isBlank()) return badRequest("meetingTime is required (ISO-8601)");
        LocalDateTime meetingTime;
        try {
            meetingTime = LocalDateTime.parse(meetingTimeRaw.replace(" ", "T"));
        } catch (Exception ex) {
            return badRequest("Invalid meetingTime (use yyyy-MM-ddTHH:mm)");
        }
        InvestmentMeeting m = new InvestmentMeeting();
        m.setProposal(proposal);
        m.setInvestor(inv);
        m.setMeetingTime(meetingTime);
        m.setLocation(trim(Objects.toString(body.get("location"), "")));
        m.setNotes(trim(Objects.toString(body.get("notes"), "")));
        m.setStatus("PENDING");
        meetingRepository.save(m);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ok(Map.of("message", "Meeting requested", "meeting", meetingDto(m))));
    }

    // ── Chat ────────────────────────────────────────────────────────────────

    @GetMapping("/api/entrepreneur/chat/threads")
    public ResponseEntity<Map<String, Object>> entrepreneurChatThreads(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        List<Map<String, Object>> threads = buildEntrepreneurThreads(e.getId());
        return ResponseEntity.ok(ok(Map.of("threads", threads, "count", threads.size())));
    }

    @GetMapping("/api/investor/chat/threads")
    public ResponseEntity<Map<String, Object>> investorChatThreads(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        List<Map<String, Object>> threads = buildInvestorThreads(inv);
        return ResponseEntity.ok(ok(Map.of("threads", threads, "count", threads.size())));
    }

    @GetMapping("/api/entrepreneur/chat")
    public ResponseEntity<Map<String, Object>> entrepreneurChat(
            @RequestParam Long proposalId,
            @RequestParam Long investorId,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        BusinessProposal p = businessProposalRepository.findById(proposalId).orElse(null);
        Investor inv = investorRepository.findById(investorId).orElse(null);
        if (p == null || inv == null || p.getEntrepreneur() == null
                || !p.getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Chat not found");
        }
        List<Map<String, Object>> messages = chatRepository
                .findByProposalAndInvestorOrderByTimestampAsc(p, inv)
                .stream().map(this::chatDto).toList();
        return ResponseEntity.ok(ok(Map.of(
                "messages", messages,
                "proposalId", proposalId,
                "investorId", investorId,
                "investorName", inv.getFullName(),
                "proposalTitle", p.getTitle()
        )));
    }

    @PostMapping("/api/entrepreneur/chat")
    @Transactional
    public ResponseEntity<Map<String, Object>> entrepreneurSendChat(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        Long proposalId = parseLong(body.get("proposalId"));
        Long investorId = parseLong(body.get("investorId"));
        String message = trim(Objects.toString(body.get("message"), ""));
        if (proposalId == null || investorId == null || message.isBlank()) {
            return badRequest("proposalId, investorId and message are required");
        }
        BusinessProposal p = businessProposalRepository.findById(proposalId).orElse(null);
        Investor inv = investorRepository.findById(investorId).orElse(null);
        if (p == null || inv == null || p.getEntrepreneur() == null
                || !p.getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Chat not found");
        }
        ProposalChatMessage msg = new ProposalChatMessage();
        msg.setProposal(p);
        msg.setInvestor(inv);
        msg.setSenderRole("ENTREPRENEUR");
        msg.setMessage(message);
        chatRepository.save(msg);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ok(Map.of("message", "Sent", "chat", chatDto(msg))));
    }

    @GetMapping("/api/investor/chat")
    public ResponseEntity<Map<String, Object>> investorChat(
            @RequestParam Long proposalId,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        BusinessProposal p = businessProposalRepository.findById(proposalId).orElse(null);
        if (p == null) return badRequest("Proposal not found");
        List<Map<String, Object>> messages = chatRepository
                .findByProposalAndInvestorOrderByTimestampAsc(p, inv)
                .stream().map(this::chatDto).toList();
        return ResponseEntity.ok(ok(Map.of(
                "messages", messages,
                "proposalId", proposalId,
                "entrepreneurId", p.getEntrepreneur() == null ? null : p.getEntrepreneur().getId(),
                "entrepreneurName", p.getEntrepreneur() == null ? null : p.getEntrepreneur().getFullName(),
                "proposalTitle", p.getTitle()
        )));
    }

    @PostMapping("/api/investor/chat")
    @Transactional
    public ResponseEntity<Map<String, Object>> investorSendChat(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        Long proposalId = parseLong(body.get("proposalId"));
        String message = trim(Objects.toString(body.get("message"), ""));
        if (proposalId == null || message.isBlank()) {
            return badRequest("proposalId and message are required");
        }
        BusinessProposal p = businessProposalRepository.findById(proposalId).orElse(null);
        if (p == null) return badRequest("Proposal not found");
        ProposalChatMessage msg = new ProposalChatMessage();
        msg.setProposal(p);
        msg.setInvestor(inv);
        msg.setSenderRole("INVESTOR");
        msg.setMessage(message);
        chatRepository.save(msg);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ok(Map.of("message", "Sent", "chat", chatDto(msg))));
    }

    // ── Funding / commission (entrepreneur withdraw screen) ─────────────────

    @GetMapping("/api/entrepreneur/funding-detail")
    public ResponseEntity<Map<String, Object>> fundingDetail(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        List<Investment> interests = investmentRepository.findByProposal_Entrepreneur_Id(e.getId());
        double released = interests.stream()
                .filter(i -> "COMPLETED".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getReleasedAmount() != null ? i.getReleasedAmount()
                        : (i.getAmount() == null ? 0.0 : i.getAmount()))
                .sum();
        double pending = interests.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        double commissionDue = interests.stream()
                .filter(i -> "COMPLETED".equalsIgnoreCase(i.getStatus()) && !i.isCommissionPaid())
                .mapToDouble(i -> {
                    double base = i.getReleasedAmount() != null ? i.getReleasedAmount()
                            : (i.getAmount() == null ? 0.0 : i.getAmount());
                    return base * 0.02;
                })
                .sum();

        Map<String, Object> bank = new LinkedHashMap<>();
        bank.put("bankName", e.getBankName());
        bank.put("accountNumber", e.getAccountNumber());
        bank.put("ifscCode", e.getIfscCode());
        bank.put("upiId", e.getUpiId());

        List<Map<String, Object>> items = interests.stream().map(i -> {
            Map<String, Object> m = interestFundingDto(i);
            return m;
        }).toList();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("releasedTotal", released);
        data.put("pendingInterestTotal", pending);
        data.put("commissionDue", commissionDue);
        data.put("bank", bank);
        data.put("investments", items);
        data.put("guidance", "Admin releases completed investments to your bank details. "
                + "Pay the 2% platform commission on released funds when due.");
        data.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        data.put("payoutBalance", e.getPayoutBalance());
        data.put("upiId", e.getUpiId() == null ? "" : e.getUpiId());
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/api/entrepreneur/investments/{id}/commission/pay")
    @Transactional
    public ResponseEntity<Map<String, Object>> payCommission(@PathVariable Long id, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        Investment inv = investmentRepository.findById(id).orElse(null);
        if (inv == null || inv.getProposal() == null || inv.getProposal().getEntrepreneur() == null
                || !inv.getProposal().getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Investment not found");
        }
        try {
            fundingCareService.markCommissionPaid(inv);
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Commission of 2% marked paid",
                    "type", "FUNDING_COMMISSION",
                    "investment", interestFundingDto(inv)
            )));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PutMapping("/api/entrepreneur/bank")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBank(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        if (body.containsKey("bankName")) e.setBankName(trim(Objects.toString(body.get("bankName"), "")));
        if (body.containsKey("accountNumber")) e.setAccountNumber(trim(Objects.toString(body.get("accountNumber"), "")));
        if (body.containsKey("ifscCode")) e.setIfscCode(trim(Objects.toString(body.get("ifscCode"), "")));
        if (body.containsKey("upiId")) e.setUpiId(trim(Objects.toString(body.get("upiId"), "")));
        entrepreneurRepository.save(e);
        Map<String, Object> bank = new LinkedHashMap<>();
        bank.put("bankName", e.getBankName());
        bank.put("accountNumber", e.getAccountNumber());
        bank.put("ifscCode", e.getIfscCode());
        bank.put("upiId", e.getUpiId());
        return ResponseEntity.ok(ok(Map.of("message", "Bank details saved", "bank", bank)));
    }

    // ── Notifications (derived) ─────────────────────────────────────────────

    @GetMapping("/api/entrepreneur/notifications")
    public ResponseEntity<Map<String, Object>> entrepreneurNotifications(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized("Entrepreneur login required");
        List<Map<String, Object>> items = new ArrayList<>();

        meetingRepository.findByProposal_Entrepreneur_Id(e.getId()).stream()
                .filter(m -> "PENDING".equalsIgnoreCase(m.getStatus()))
                .forEach(m -> items.add(notif(
                        "meeting",
                        "Meeting request pending",
                        (m.getInvestor() == null ? "An investor" : m.getInvestor().getFullName())
                                + " requested a meeting"
                                + (m.getProposal() == null ? "" : " for " + m.getProposal().getTitle()),
                        m.getCreatedAt() == null ? null : m.getCreatedAt().toString(),
                        Map.of("meetingId", m.getId(), "type", "meeting")
                )));

        investmentRepository.findByProposal_Entrepreneur_Id(e.getId()).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .forEach(i -> items.add(notif(
                        "interest",
                        "New investment interest",
                        (i.getInvestor() == null ? "An investor" : i.getInvestor().getFullName())
                                + " expressed interest of Rs "
                                + (i.getAmount() == null ? 0 : i.getAmount().intValue()),
                        i.getCreatedAt() == null ? null : i.getCreatedAt().toString(),
                        Map.of("investmentId", i.getId(), "type", "interest")
                )));

        chatRepository.findByProposal_Entrepreneur_Id(e.getId()).stream()
                .filter(c -> "INVESTOR".equalsIgnoreCase(c.getSenderRole()))
                .sorted(Comparator.comparing(ProposalChatMessage::getTimestamp,
                        Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(20)
                .forEach(c -> items.add(notif(
                        "chat",
                        "New chat message",
                        (c.getInvestor() == null ? "Investor" : c.getInvestor().getFullName())
                                + ": " + abbreviate(c.getMessage(), 80),
                        c.getTimestamp() == null ? null : c.getTimestamp().toString(),
                        Map.of(
                                "proposalId", c.getProposal() == null ? null : c.getProposal().getId(),
                                "investorId", c.getInvestor() == null ? null : c.getInvestor().getId(),
                                "type", "chat"
                        )
                )));

        items.sort((a, b) -> String.valueOf(b.get("at")).compareTo(String.valueOf(a.get("at"))));
        return ResponseEntity.ok(ok(Map.of("notifications", items, "count", items.size())));
    }

    @GetMapping("/api/investor/notifications")
    public ResponseEntity<Map<String, Object>> investorNotifications(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        List<Map<String, Object>> items = new ArrayList<>();

        meetingRepository.findByInvestor(inv).forEach(m -> {
            if ("ACCEPTED".equalsIgnoreCase(m.getStatus()) || "REJECTED".equalsIgnoreCase(m.getStatus())) {
                items.add(notif(
                        "meeting",
                        "Meeting " + m.getStatus().toLowerCase(Locale.ROOT),
                        (m.getProposal() == null ? "A proposal" : m.getProposal().getTitle())
                                + " meeting was " + m.getStatus().toLowerCase(Locale.ROOT),
                        m.getCreatedAt() == null ? null : m.getCreatedAt().toString(),
                        Map.of("meetingId", m.getId(), "type", "meeting")
                ));
            }
        });

        chatRepository.findByInvestor(inv).stream()
                .filter(c -> "ENTREPRENEUR".equalsIgnoreCase(c.getSenderRole()))
                .sorted(Comparator.comparing(ProposalChatMessage::getTimestamp,
                        Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(20)
                .forEach(c -> items.add(notif(
                        "chat",
                        "New chat message",
                        abbreviate(c.getMessage(), 80),
                        c.getTimestamp() == null ? null : c.getTimestamp().toString(),
                        Map.of(
                                "proposalId", c.getProposal() == null ? null : c.getProposal().getId(),
                                "type", "chat"
                        )
                )));

        investmentRepository.findByInvestor(inv).stream()
                .filter(i -> "COMPLETED".equalsIgnoreCase(i.getStatus()))
                .forEach(i -> items.add(notif(
                        "investment",
                        "Investment released",
                        "Your interest in "
                                + (i.getProposal() == null ? "a proposal" : i.getProposal().getTitle())
                                + " was released by admin",
                        i.getCreatedAt() == null ? null : i.getCreatedAt().toString(),
                        Map.of("investmentId", i.getId(), "type", "investment")
                )));

        items.sort((a, b) -> String.valueOf(b.get("at")).compareTo(String.valueOf(a.get("at"))));
        return ResponseEntity.ok(ok(Map.of("notifications", items, "count", items.size())));
    }

    // ── Subscribe ───────────────────────────────────────────────────────────

    @PostMapping("/api/investor/subscribe")
    @Transactional
    public ResponseEntity<Map<String, Object>> subscribe(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized("Investor login required");
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        inv.setSubscribed(true);
        investorRepository.save(inv);
        session.setAttribute("loggedInvestor", inv);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Premium Investor Subscription activated",
                "subscribed", true
        )));
    }

    // ── Helpers ─────────────────────────────────────────────────────────────

    private List<Map<String, Object>> buildEntrepreneurThreads(Long entrepreneurId) {
        Map<String, Map<String, Object>> keyed = new LinkedHashMap<>();
        for (Investment i : investmentRepository.findByProposal_Entrepreneur_Id(entrepreneurId)) {
            if (i.getInvestor() == null || i.getProposal() == null) continue;
            String key = i.getProposal().getId() + ":" + i.getInvestor().getId();
            keyed.putIfAbsent(key, threadDto(i.getProposal(), i.getInvestor(), null));
        }
        for (InvestmentMeeting m : meetingRepository.findByProposal_Entrepreneur_Id(entrepreneurId)) {
            if (m.getInvestor() == null || m.getProposal() == null) continue;
            String key = m.getProposal().getId() + ":" + m.getInvestor().getId();
            keyed.putIfAbsent(key, threadDto(m.getProposal(), m.getInvestor(), null));
        }
        for (ProposalChatMessage c : chatRepository.findByProposal_Entrepreneur_Id(entrepreneurId)) {
            if (c.getInvestor() == null || c.getProposal() == null) continue;
            String key = c.getProposal().getId() + ":" + c.getInvestor().getId();
            Map<String, Object> t = keyed.computeIfAbsent(key,
                    k -> threadDto(c.getProposal(), c.getInvestor(), null));
            t.put("lastMessage", abbreviate(c.getMessage(), 100));
            t.put("lastAt", c.getTimestamp() == null ? null : c.getTimestamp().toString());
        }
        return new ArrayList<>(keyed.values());
    }

    private List<Map<String, Object>> buildInvestorThreads(Investor inv) {
        Map<Long, Map<String, Object>> keyed = new LinkedHashMap<>();
        for (Investment i : investmentRepository.findByInvestor(inv)) {
            if (i.getProposal() == null) continue;
            keyed.putIfAbsent(i.getProposal().getId(),
                    threadDto(i.getProposal(), inv, i.getProposal().getEntrepreneur()));
        }
        for (InvestmentMeeting m : meetingRepository.findByInvestor(inv)) {
            if (m.getProposal() == null) continue;
            keyed.putIfAbsent(m.getProposal().getId(),
                    threadDto(m.getProposal(), inv, m.getProposal().getEntrepreneur()));
        }
        for (ProposalChatMessage c : chatRepository.findByInvestor(inv)) {
            if (c.getProposal() == null) continue;
            Map<String, Object> t = keyed.computeIfAbsent(c.getProposal().getId(),
                    k -> threadDto(c.getProposal(), inv, c.getProposal().getEntrepreneur()));
            t.put("lastMessage", abbreviate(c.getMessage(), 100));
            t.put("lastAt", c.getTimestamp() == null ? null : c.getTimestamp().toString());
        }
        return new ArrayList<>(keyed.values());
    }

    private Map<String, Object> threadDto(BusinessProposal p, Investor inv, Entrepreneur ent) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("proposalId", p.getId());
        m.put("proposalTitle", p.getTitle());
        m.put("investorId", inv.getId());
        m.put("investorName", inv.getFullName());
        if (ent != null) {
            m.put("entrepreneurId", ent.getId());
            m.put("entrepreneurName", ent.getFullName());
            m.put("businessName", ent.getBusinessName());
        } else if (p.getEntrepreneur() != null) {
            m.put("entrepreneurId", p.getEntrepreneur().getId());
            m.put("entrepreneurName", p.getEntrepreneur().getFullName());
            m.put("businessName", p.getEntrepreneur().getBusinessName());
        }
        return m;
    }

    private Map<String, Object> meetingDto(InvestmentMeeting m) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("id", m.getId());
        out.put("status", m.getStatus());
        out.put("meetingTime", m.getMeetingTime() == null ? null : m.getMeetingTime().toString());
        out.put("location", m.getLocation());
        out.put("notes", m.getNotes());
        out.put("createdAt", m.getCreatedAt() == null ? null : m.getCreatedAt().toString());
        if (m.getProposal() != null) {
            out.put("proposalId", m.getProposal().getId());
            out.put("proposalTitle", m.getProposal().getTitle());
        }
        if (m.getInvestor() != null) {
            out.put("investorId", m.getInvestor().getId());
            out.put("investorName", m.getInvestor().getFullName());
            out.put("investorCompany", m.getInvestor().getCompanyName());
        }
        if (m.getProposal() != null && m.getProposal().getEntrepreneur() != null) {
            out.put("entrepreneurId", m.getProposal().getEntrepreneur().getId());
            out.put("entrepreneurName", m.getProposal().getEntrepreneur().getFullName());
        }
        out.put("canAccept", "PENDING".equalsIgnoreCase(m.getStatus()));
        out.put("canReject", "PENDING".equalsIgnoreCase(m.getStatus()));
        out.put("canCancel", fundingCareService.canCancelMeeting(m));
        out.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        return out;
    }

    private Map<String, Object> chatDto(ProposalChatMessage c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("senderRole", c.getSenderRole());
        m.put("message", c.getMessage());
        m.put("timestamp", c.getTimestamp() == null ? null : c.getTimestamp().toString());
        if (c.getProposal() != null) m.put("proposalId", c.getProposal().getId());
        if (c.getInvestor() != null) {
            m.put("investorId", c.getInvestor().getId());
            m.put("investorName", c.getInvestor().getFullName());
        }
        return m;
    }

    private Map<String, Object> interestFundingDto(Investment i) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", i.getId());
        m.put("amount", i.getAmount());
        m.put("releasedAmount", i.getReleasedAmount());
        m.put("adminAmount", i.getAdminAmount());
        m.put("status", i.getStatus());
        m.put("commissionPaid", i.isCommissionPaid());
        double base = i.getReleasedAmount() != null ? i.getReleasedAmount()
                : (i.getAmount() == null ? 0.0 : i.getAmount());
        m.put("commissionDue", ("COMPLETED".equalsIgnoreCase(i.getStatus()) && !i.isCommissionPaid())
                ? base * 0.02 : 0.0);
        m.put("createdAt", i.getCreatedAt() == null ? null : i.getCreatedAt().toString());
        if (i.getInvestor() != null) {
            m.put("investorName", i.getInvestor().getFullName());
            m.put("investorId", i.getInvestor().getId());
        }
        if (i.getProposal() != null) {
            m.put("proposalId", i.getProposal().getId());
            m.put("proposalTitle", i.getProposal().getTitle());
        }
        return m;
    }

    private Map<String, Object> proposalBrief(BusinessProposal p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("title", p.getTitle());
        m.put("documents", p.getDocuments());
        m.put("videoPitch", p.getVideoPitch());
        m.put("status", p.getStatus() == null ? null : p.getStatus().name());
        return m;
    }

    private Map<String, Object> notif(String kind, String title, String body, String at, Map<String, Object> meta) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("kind", kind);
        m.put("title", title);
        m.put("body", body);
        m.put("at", at == null ? "" : at);
        m.putAll(meta);
        return m;
    }

    private static String abbreviate(String s, int max) {
        if (s == null) return "";
        String t = s.trim();
        return t.length() <= max ? t : t.substring(0, max - 1) + "…";
    }

    private Entrepreneur requireEntrepreneur(HttpSession session) {
        Object e = session == null ? null : session.getAttribute("loggedEntrepreneur");
        return e instanceof Entrepreneur ? (Entrepreneur) e : null;
    }

    private Investor requireInvestor(HttpSession session) {
        Object i = session == null ? null : session.getAttribute("loggedInvestor");
        return i instanceof Investor ? (Investor) i : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized(String msg) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error(msg));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private static Long parseLong(Object value) {
        if (value == null || value.toString().isBlank()) return null;
        try {
            return Long.parseLong(value.toString());
        } catch (Exception e) {
            return null;
        }
    }
}
