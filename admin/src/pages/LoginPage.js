import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';
import Input from '../components/Input';
import Button from '../components/Button';
import Card from '../components/Card';

const LoginPage = () => {
  const [step, setStep] = useState(1); // 1 for phone, 2 for otp/pin
  const [phoneNumber, setPhoneNumber] = useState('');
  const [otp, setOtp] = useState('');
  const [pin, setPin] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const { requestOtp, verifyLogin } = useAuth();
  const navigate = useNavigate();

  const handleRequestOtp = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    try {
      await requestOtp(phoneNumber);
      setStep(2);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    try {
      await verifyLogin(phoneNumber, otp, pin);
      navigate('/'); // Navigate to dashboard on successful login
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
      <Card style={{ width: '100%', maxWidth: '400px' }}>
        <h2>Admin Login</h2>
        {error && <p style={{ color: 'red' }}>{error}</p>}
        {step === 1 ? (
          <form onSubmit={handleRequestOtp}>
            <Input
              label="Phone Number"
              id="phone"
              type="tel"
              value={phoneNumber}
              onChange={(e) => setPhoneNumber(e.target.value)}
              placeholder="+1234567890"
              required
            />
            <div style={{ marginTop: '16px' }}>
              <Button type="submit" disabled={isLoading}>
                {isLoading ? 'Sending OTP...' : 'Request OTP'}
              </Button>
            </div>
          </form>
        ) : (
          <form onSubmit={handleLogin}>
            <Input
              label="OTP"
              id="otp"
              type="text"
              value={otp}
              onChange={(e) => setOtp(e.target.value)}
              placeholder="123456"
              required
            />
            <Input
              label="PIN"
              id="pin"
              type="password"
              value={pin}
              onChange={(e) => setPin(e.target.value)}
              placeholder="******"
              required
            />
            <div style={{ marginTop: '16px' }}>
              <Button type="submit" disabled={isLoading}>
                {isLoading ? 'Logging in...' : 'Login'}
              </Button>
            </div>
          </form>
        )}
      </Card>
    </div>
  );
};

export default LoginPage;
