package in.sp.main.Service;

import org.springframework.stereotype.Service;

import java.util.*;

/**
 * High-quality maintained dataset of Indian States, Union Territories, Districts/Cities, and Localities.
 * Provides cascading lookups for marketplace providers, martial arts centres, and other directory modules.
 */
@Service
public class LocationDirectoryService {

    private static final List<String> ALL_STATES = List.of(
            "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
            "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
            "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
            "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab",
            "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
            "Uttar Pradesh", "Uttarakhand", "West Bengal",
            "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu",
            "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
    );

    private static final Map<String, List<String>> STATE_CITIES = new LinkedHashMap<>();
    private static final Map<String, List<String>> CITY_AREAS = new LinkedHashMap<>();

    static {
        // --- 1. Andhra Pradesh ---
        STATE_CITIES.put("Andhra Pradesh", List.of(
                "Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool", "Rajahmundry",
                "Tirupati", "Kakinada", "Kadapa", "Anantapur", "Eluru", "Vizianagaram", "Ongole", "Srikakulam", "Machilipatnam"
        ));

        // --- 2. Arunachal Pradesh ---
        STATE_CITIES.put("Arunachal Pradesh", List.of(
                "Itanagar", "Naharlagun", "Pasighat", "Tawang", "Ziro", "Bomdila", "Tezu", "Roing", "Along"
        ));

        // --- 3. Assam ---
        STATE_CITIES.put("Assam", List.of(
                "Guwahati", "Silchar", "Dibrugarh", "Jorhat", "Nagaon", "Tinsukia", "Tezpur", "Bongaigaon", "Karimganj", "Sivasagar"
        ));

        // --- 4. Bihar ---
        STATE_CITIES.put("Bihar", List.of(
                "Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif",
                "Arrah", "Begusarai", "Katihar", "Munger", "Chhapra", "Danapur", "Saharsa", "Sasaram", "Hajipur", "Dehri", "Siwan", "Motihari"
        ));

        // --- 5. Chhattisgarh ---
        STATE_CITIES.put("Chhattisgarh", List.of(
                "Raipur", "Bhilai", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur", "Raigarh", "Ambikapur", "Durg", "Dhamtari"
        ));

        // --- 6. Goa ---
        STATE_CITIES.put("Goa", List.of(
                "North Goa", "South Goa", "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Calangute", "Candolim", "Bicholim"
        ));

        // --- 7. Gujarat ---
        STATE_CITIES.put("Gujarat", List.of(
                "Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar",
                "Junagadh", "Gandhidham", "Anand", "Navsari", "Morbi", "Nadiad", "Surendranagar", "Bharuch", "Mehsana", "Porbandar", "Vapi"
        ));

        // --- 8. Haryana ---
        STATE_CITIES.put("Haryana", List.of(
                "Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar",
                "Karnal", "Sonipat", "Panchkula", "Bhiwani", "Sirsa", "Bahadurgarh", "Jind", "Thanesar", "Kaithal", "Rewari", "Palwal"
        ));

        // --- 9. Himachal Pradesh ---
        STATE_CITIES.put("Himachal Pradesh", List.of(
                "Shimla", "Dharamshala", "Solan", "Mandi", "Kullu", "Manali", "Baddi", "Bilaspur", "Hamirpur", "Una", "Chamba", "Nahan"
        ));

        // --- 10. Jharkhand ---
        STATE_CITIES.put("Jharkhand", List.of(
                "Ranchi", "Jamshedpur", "Dhanbad", "Bokaro Steel City", "Deoghar", "Phusro", "Hazaribagh", "Giridih", "Ramgarh", "Medininagar"
        ));

        // --- 11. Karnataka ---
        STATE_CITIES.put("Karnataka", List.of(
                "Bengaluru Urban", "Bengaluru Rural", "Mysuru", "Hubballi-Dharwad", "Mangaluru", "Belagavi",
                "Davanagere", "Ballari", "Vijayapura", "Shivamogga", "Tumakuru", "Raichur", "Bidar", "Hosapete", "Gadag-Betageri", "Udupi", "Hassan"
        ));

        // --- 12. Kerala ---
        STATE_CITIES.put("Kerala", List.of(
                "Thiruvananthapuram", "Kochi / Ernakulam", "Kozhikode", "Kollam", "Thrissur", "Alappuzha",
                "Palakkad", "Malappuram", "Kannur", "Kottayam", "Kasaragod", "Pathanamthitta", "Idukki", "Wayanad"
        ));

        // --- 13. Madhya Pradesh ---
        STATE_CITIES.put("Madhya Pradesh", List.of(
                "Indore", "Bhopal", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna",
                "Ratlam", "Rewa", "Katni", "Singrauli", "Burhanpur", "Khandwa", "Bhind", "Chhindwara", "Guna", "Shivpuri", "Vidisha"
        ));

        // --- 14. Maharashtra ---
        STATE_CITIES.put("Maharashtra", List.of(
                "Mumbai", "Mumbai Suburban", "Pune", "Nagpur", "Thane", "Nashik", "Kalyan-Dombivli", "Vasai-Virar",
                "Aurangabad / Chhatrapati Sambhajinagar", "Navi Mumbai", "Solapur", "Mira-Bhayandar", "Bhiwandi-Nizampur",
                "Amravati", "Nanded", "Kolhapur", "Akola", "Ulhasnagar", "Sangli-Miraj", "Jalgaon", "Latur", "Dhule", "Ahmednagar", "Satara"
        ));

        // --- 15. Manipur ---
        STATE_CITIES.put("Manipur", List.of(
                "Imphal", "Thoubal", "Bishnupur", "Churachandpur", "Ukhrul", "Senapati", "Kakching"
        ));

        // --- 16. Meghalaya ---
        STATE_CITIES.put("Meghalaya", List.of(
                "Shillong", "Tura", "Jowai", "Nongpoh", "Cherrapunji", "Williamnagar", "Baghmara"
        ));

        // --- 17. Mizoram ---
        STATE_CITIES.put("Mizoram", List.of(
                "Aizawl", "Lunglei", "Champhai", "Serchhip", "Kolasib", "Lawngtlai", "Saitual"
        ));

        // --- 18. Nagaland ---
        STATE_CITIES.put("Nagaland", List.of(
                "Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Zunheboto", "Mon", "Phek"
        ));

        // --- 19. Odisha ---
        STATE_CITIES.put("Odisha", List.of(
                "Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur", "Puri", "Balasore", "Bhadrak", "Baripada", "Jharsuguda", "Jeypore"
        ));

        // --- 20. Punjab ---
        STATE_CITIES.put("Punjab", List.of(
                "Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "SAS Nagar (Mohali)", "Hoshiarpur", "Batala", "Pathankot", "Moga", "Abohar", "Malerkotla", "Khanna"
        ));

        // --- 21. Rajasthan ---
        STATE_CITIES.put("Rajasthan", List.of(
                "Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Bharatpur", "Sikar", "Sri Ganganagar", "Pali", "Chittorgarh"
        ));

        // --- 22. Sikkim ---
        STATE_CITIES.put("Sikkim", List.of(
                "Gangtok", "Namchi", "Geyzing", "Mangan", "Ravangla", "Jorethang", "Singtam"
        ));

        // --- 23. Tamil Nadu ---
        STATE_CITIES.put("Tamil Nadu", List.of(
                "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tiruppur", "Erode", "Tirunelveli", "Vellore", "Thoothukudi", "Dindigul", "Thanjavur", "Ranipet", "Kanchipuram"
        ));

        // --- 24. Telangana ---
        STATE_CITIES.put("Telangana", List.of(
                "Hyderabad", "Secunderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam", "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet"
        ));

        // --- 25. Tripura ---
        STATE_CITIES.put("Tripura", List.of(
                "Agartala", "Dharmanagar", "Udaipur", "Kailashahar", "Belonia", "Khowai", "Teliamura"
        ));

        // --- 26. Uttar Pradesh ---
        STATE_CITIES.put("Uttar Pradesh", List.of(
                "Lucknow", "Kanpur", "Ghaziabad", "Agra", "Meerut", "Varanasi", "Prayagraj (Allahabad)", "Bareilly",
                "Aligarh", "Moradabad", "Saharanpur", "Gorakhpur", "Noida", "Greater Noida", "Firozabad", "Jhansi", "Muzaffarnagar", "Mathura", "Ayodhya"
        ));

        // --- 27. Uttarakhand ---
        STATE_CITIES.put("Uttarakhand", List.of(
                "Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rudrapur", "Kashipur", "Rishikesh", "Nainital", "Pithoragarh", "Mussoorie", "Almora"
        ));

        // --- 28. West Bengal ---
        STATE_CITIES.put("West Bengal", List.of(
                "Kolkata", "Howrah", "Durgapur", "Asansol", "Siliguri", "Bardhaman", "Malda", "Baharampur", "Habra", "Kharagpur", "Shantipur", "Dankuni", "Darjeeling"
        ));

        // --- Union Territories ---
        STATE_CITIES.put("Andaman and Nicobar Islands", List.of("Port Blair", "Havelock Island", "Neil Island", "Diglipur", "Mayabunder", "Car Nicobar"));
        STATE_CITIES.put("Chandigarh", List.of("Chandigarh City", "Manimajra", "Industrial Area", "Sector 1-20", "Sector 21-40", "Sector 41-60"));
        STATE_CITIES.put("Dadra and Nagar Haveli and Daman and Diu", List.of("Daman", "Diu", "Silvassa", "Amli", "Bhimpore"));
        STATE_CITIES.put("Delhi", List.of(
                "Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North East Delhi",
                "North West Delhi", "Shahdara", "South Delhi", "South East Delhi", "South West Delhi", "West Delhi"
        ));
        STATE_CITIES.put("Jammu and Kashmir", List.of("Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua", "Udhampur", "Sopore", "Poonch", "Rajouri"));
        STATE_CITIES.put("Ladakh", List.of("Leh", "Kargil", "Diskit", "Nubra", "Zanskar"));
        STATE_CITIES.put("Lakshadweep", List.of("Kavaratti", "Agatti", "Amini", "Andrott", "Minicoy", "Kalpeni"));
        STATE_CITIES.put("Puducherry", List.of("Puducherry", "Karaikal", "Mahe", "Yanam", "Oulgaret"));

        // ==========================================
        // Popular Localities for Key Metropolitan Areas
        // ==========================================
        CITY_AREAS.put("Mumbai", List.of(
                "Bandra West", "Bandra East", "Andheri West", "Andheri East", "Juhu", "Dadar", "Colaba", "Marine Lines", "Worli", "Lower Parel", "Prabhadevi", "Kurla", "Ghatkopar", "Powai", "Chembur", "Borivali West", "Kandivali West", "Malad West", "Goregaon West", "Santacruz West", "Vile Parle"
        ));
        CITY_AREAS.put("Mumbai Suburban", List.of(
                "Andheri", "Bandra", "Borivali", "Goregaon", "Juhu", "Kandivali", "Kurla", "Malad", "Mulund", "Powai", "Santacruz", "Vikhroli", "Vile Parle"
        ));
        CITY_AREAS.put("Navi Mumbai", List.of(
                "Vashi", "Nerul", "Belapur", "Kharghar", "Seawoods", "Kopar Khairane", "Ghansoli", "Airoli", "Panvel", "Ulwe"
        ));
        CITY_AREAS.put("Thane", List.of(
                "Thane West", "Thane East", "Naupada", "Ghodbunder Road", "Majiwada", "Vartak Nagar", "Panchpakhadi", "Kasarvadavali", "Kolshet Road"
        ));
        CITY_AREAS.put("Pune", List.of(
                "Kothrud", "Koregaon Park", "Viman Nagar", "Baner", "Aundh", "Wakad", "Hinjawadi", "Hadapsar", "Kalyani Nagar", "Shivajinagar", "Camp", "Magarpatta", "Pimple Saudagar", "Bavdhan", "Sinhagad Road"
        ));
        CITY_AREAS.put("Bengaluru Urban", List.of(
                "Koramangala", "Indiranagar", "HSR Layout", "Whitefield", "Jayanagar", "JP Nagar", "Electronic City", "Marathahalli", "BTM Layout", "Hebbal", "Malleshwaram", "Rajajinagar", "Bellandur", "Sarjapur Road", "Banashankari", "Yelahanka", "MG Road"
        ));
        CITY_AREAS.put("Delhi", List.of(
                "Connaught Place", "Saket", "Hauz Khas", "Greater Kailash", "Vasant Kunj", "Dwarka", "Rohini", "Karol Bagh", "Lajpat Nagar", "Janakpuri", "Pitampura", "Laxmi Nagar", "Mayur Vihar", "South Extension", "Green Park", "Chanakyapuri", "Nehru Place"
        ));
        CITY_AREAS.put("New Delhi", List.of(
                "Connaught Place", "Barakhamba", "Chanakyapuri", "Khan Market", "Jor Bagh", "Lodhi Colony", "Gole Market", "Bengali Market"
        ));
        CITY_AREAS.put("South Delhi", List.of(
                "Saket", "Hauz Khas", "Greater Kailash 1", "Greater Kailash 2", "Vasant Vihar", "Vasant Kunj", "Green Park", "Malviya Nagar", "Defence Colony", "South Extension"
        ));
        CITY_AREAS.put("Noida", List.of(
                "Sector 15", "Sector 18 (Atta)", "Sector 50", "Sector 62", "Sector 76", "Sector 137", "Sector 128", "Sector 144", "Noida Expressway"
        ));
        CITY_AREAS.put("Greater Noida", List.of(
                "Pari Chowk", "Alpha 1", "Beta 1", "Gamma 2", "Omega", "Knowledge Park", "Gaur City", "Noida Extension"
        ));
        CITY_AREAS.put("Gurugram", List.of(
                "DLF Phase 1", "DLF Phase 2", "DLF Phase 3", "Cyber City", "Golf Course Road", "Sohna Road", "Sector 14", "Sector 29", "Sector 56", "Sector 57", "MG Road", "Palam Vihar"
        ));
        CITY_AREAS.put("Hyderabad", List.of(
                "Banjara Hills", "Jubilee Hills", "Gachibowli", "Hitec City", "Madhapur", "Kondapur", "Kukatpally", "Begumpet", "Ameerpet", "Manikonda", "Secunderabad", "Dilsukhnagar", "SR Nagar"
        ));
        CITY_AREAS.put("Chennai", List.of(
                "T. Nagar", "Adyar", "Besant Nagar", "Anna Nagar", "Mylapore", "Velachery", "Nungambakkam", "Alwarpet", "OMR (Old Mahabalipuram Rd)", "ECR", "Thiruvanmiyur", "Guindy", "Kilpauk"
        ));
        CITY_AREAS.put("Kolkata", List.of(
                "Salt Lake (Bidhannagar)", "New Town", "Park Street", "Ballygunge", "Alipore", "Gariahat", "Bhowanipore", "Dum Dum", "Behala", "Jadavpur", "Howrah", "Kankurgachi", "Tollygunge"
        ));
        CITY_AREAS.put("Ahmedabad", List.of(
                "Navrangpura", "Satellite", "Bodakdev", "Vastrapur", "Prahlad Nagar", "SG Highway", "Maninagar", "Paldi", "Thaltej", "Bopal", "Chandkheda"
        ));
        CITY_AREAS.put("Jaipur", List.of(
                "Malviya Nagar", "Vaishali Nagar", "C-Scheme", "Mansarovar", "Raja Park", "Tonk Road", "Jagatpura", "Bani Park", "Civil Lines", "Ajmer Road"
        ));
        CITY_AREAS.put("Lucknow", List.of(
                "Gomti Nagar", "Hazratganj", "Aliganj", "Indira Nagar", "Mahanagar", "Jankipuram", "Ashiyana", "Vikas Nagar", "Alambagh", "Vibhuti Khand"
        ));
        CITY_AREAS.put("Chandigarh City", List.of(
                "Sector 8", "Sector 9", "Sector 10", "Sector 17 (Plaza)", "Sector 22", "Sector 35", "Sector 43", "Sector 70", "Manimajra"
        ));
        CITY_AREAS.put("Kochi / Ernakulam", List.of(
                "Marine Drive", "Panampilly Nagar", "Kakkanad (Infopark)", "Edappally", "Fort Kochi", "Kaloor", "Palarivattom", "Vyttila", "MG Road"
        ));
    }

    public List<String> getStates() {
        return ALL_STATES;
    }

    public List<String> getCities(String state) {
        if (state == null || state.isBlank()) return Collections.emptyList();
        // Exact match or case-insensitive search
        for (Map.Entry<String, List<String>> entry : STATE_CITIES.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(state.trim())) {
                return entry.getValue();
            }
        }
        return Collections.emptyList();
    }

    public List<String> getAreas(String state, String city) {
        if (city == null || city.isBlank()) return Collections.emptyList();
        for (Map.Entry<String, List<String>> entry : CITY_AREAS.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(city.trim()) || city.toLowerCase().contains(entry.getKey().toLowerCase())) {
                return entry.getValue();
            }
        }
        return Collections.emptyList();
    }

    public boolean isValidState(String state) {
        if (state == null) return false;
        return ALL_STATES.stream().anyMatch(s -> s.equalsIgnoreCase(state.trim()));
    }

    public boolean isValidCity(String state, String city) {
        if (city == null || city.isBlank()) return false;
        List<String> cities = getCities(state);
        if (cities.isEmpty()) return true; // If state has no strict whitelist, permit non-empty string
        return cities.stream().anyMatch(c -> c.equalsIgnoreCase(city.trim()));
    }
}
