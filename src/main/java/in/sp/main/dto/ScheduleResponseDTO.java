package in.sp.main.dto;

import java.util.List;
import java.util.Map;

public class ScheduleResponseDTO {
    private List<Map<String, Object>> data;
    private long total;
    private int attended;
    private int missed;
    private int upcoming;
    private double totalHours;
    private double attendanceRate;

    public ScheduleResponseDTO() {}

    public ScheduleResponseDTO(List<Map<String, Object>> data, long total, int attended, int missed, int upcoming, double totalHours, double attendanceRate) {
        this.data = data;
        this.total = total;
        this.attended = attended;
        this.missed = missed;
        this.upcoming = upcoming;
        this.totalHours = totalHours;
        this.attendanceRate = attendanceRate;
    }

    public List<Map<String, Object>> getData() { return data; }
    public void setData(List<Map<String, Object>> data) { this.data = data; }

    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }

    public int getAttended() { return attended; }
    public void setAttended(int attended) { this.attended = attended; }

    public int getMissed() { return missed; }
    public void setMissed(int missed) { this.missed = missed; }

    public int getUpcoming() { return upcoming; }
    public void setUpcoming(int upcoming) { this.upcoming = upcoming; }

    public double getTotalHours() { return totalHours; }
    public void setTotalHours(double totalHours) { this.totalHours = totalHours; }

    public double getAttendanceRate() { return attendanceRate; }
    public void setAttendanceRate(double attendanceRate) { this.attendanceRate = attendanceRate; }
}
