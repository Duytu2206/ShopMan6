package model;

/**
 * Lop thuc the truu tuong: nhan vien (ke thua Member6).
 */
public abstract class Staff6 extends Member6 {
    private static final long serialVersionUID = 1L;

    private String position;
    private boolean active;

    public Staff6() {
        super();
    }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
