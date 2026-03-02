import { useState, useEffect, useCallback } from 'react';
import * as providerProfileService from '../api/providerProfileService';

export const useProviderProfiles = () => {
  const [profiles, setProfiles] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchProfiles = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await providerProfileService.getProviderProfiles();
      setProfiles(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchProfiles();
  }, [fetchProfiles]);

  const verifyProvider = async (userId) => {
    try {
        await providerProfileService.verifyProvider(userId);
        // We need to update the user's 'verified' status in the profile list
        setProfiles(prevProfiles =>
            prevProfiles.map(p =>
                p.userId._id === userId ? { ...p, userId: { ...p.userId, verified: true } } : p
            )
        );
    } catch (err) {
        console.error("Failed to verify provider:", err);
        throw err;
    }
  };

  const updateProviderProfile = async (profileId, profileData) => {
    try {
        const updatedProfile = await providerProfileService.updateProviderProfile(profileId, profileData);
        setProfiles(prevProfiles =>
            prevProfiles.map(p => (p._id === profileId ? updatedProfile : p))
        );
    } catch (err) {
        console.error("Failed to update provider profile:", err);
        throw err;
    }
  };

  const unverifyProvider = async (userId) => {
    try {
        await providerProfileService.unverifyProvider(userId);
        setProfiles(prevProfiles =>
            prevProfiles.map(p =>
                p.userId._id === userId ? { ...p, userId: { ...p.userId, verified: false } } : p
            )
        );
    } catch (err) {
        console.error("Failed to un-verify provider:", err);
        throw err;
    }
  };

  return { profiles, isLoading, error, fetchProfiles, verifyProvider, updateProviderProfile, unverifyProvider };
};
