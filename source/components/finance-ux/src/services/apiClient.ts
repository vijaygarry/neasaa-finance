import axios, { AxiosError } from 'axios';

const apiClient = axios.create({
  headers: { 'Content-Type': 'application/json' },
});

apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    const serverMessage = (error.response?.data as any)?.operationMessage
      ?? (error.response?.data as any)?.message;
    if (!error.response)         return Promise.reject(new Error('Unable to reach server. Check your connection.'));
    if (error.response.status === 401) return Promise.reject(new Error('Unauthorised. Please log in.'));
    if (error.response.status === 403) return Promise.reject(new Error('You do not have permission to perform this action.'));
    if (error.response.status === 404) return Promise.reject(new Error('Requested resource not found.'));
    if (error.response.status === 500) return Promise.reject(new Error('Server error. Please try again later.'));
    if (serverMessage)           return Promise.reject(new Error(serverMessage));
    return Promise.reject(new Error(`Request failed (${error.response.status})`));
  }
);

export default apiClient;
