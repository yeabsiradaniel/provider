// Basic phone validation (you might want a more robust library for production)
export const isValidPhone = (phone) => {
    // e.g., starts with +, followed by 1 to 3 digits for country code, then 7+ digits.
    const phoneRegex = /^\+?[1-9]\d{1,14}$/; 
    return phoneRegex.test(phone);
};

// Basic PIN validation
export const isValidPin = (pin) => {
    const pinRegex = /^\d{4,6}$/; // 4 to 6 digits
    return pinRegex.test(pin);
};
