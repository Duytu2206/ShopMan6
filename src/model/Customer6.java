package model;

import java.util.Date;

/**
 * Lop thuc the: khach hang (ke thua Member6).
 */
public class Customer6 extends Member6 {
    private static final long serialVersionUID = 1L;

    private String customerCode;
    private Date registrationDate;

    public Customer6() {
        super();
    }

    public String getCustomerCode() { return customerCode; }
    public void setCustomerCode(String customerCode) { this.customerCode = customerCode; }

    public Date getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Date registrationDate) { this.registrationDate = registrationDate; }
}
