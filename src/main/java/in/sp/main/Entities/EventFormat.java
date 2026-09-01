package in.sp.main.Entities;

public enum EventFormat {
    ONLINE,
    OFFLINE,
    HYBRID;

    public static EventFormat fromFlexible(String raw) {
        if (raw == null || raw.isBlank()) return OFFLINE;
        String key = raw.trim().toUpperCase();
        if ("VIRTUAL".equals(key) || "ONLINE".equals(key)) return ONLINE;
        if ("HYBRID".equals(key)) return HYBRID;
        return OFFLINE;
    }
}
