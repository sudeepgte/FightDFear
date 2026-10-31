-- Mobile Service Partner registration includes ₹ and other Unicode in description.
ALTER DATABASE womenbesafe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE service_providers CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
