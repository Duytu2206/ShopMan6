package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lop thuc the truu tuong: thanh vien he thong.
 * Cac lop Staff6, Customer6 ke thua tu lop nay.
 */
public abstract class Member6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String password;
    private String fullName;
    private Date birthDate;
    private String address;
    private String email;
    private String phoneNumber;
    private String role;
    private String notes;

    public Member6() {
        super();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
