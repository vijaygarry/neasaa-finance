import axios, { AxiosError } from 'axios';

const apiClient = axios.create({
  headers: { 'Content-Type': 'application/json' },
});

apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (!error.response) return Promise.reject(new Error('Unable to reach server. Check your connection.'));

    const operationMessage = (error.response.data as any)?.operationMessage;
    if (operationMessage) return Promise.reject(new Error(operationMessage));

    const genericMessage =
      error.response.status === 401 ? 'Unauthorised. Please log in.' :
      error.response.status === 403 ? 'You do not have permission to perform this action.' :
      error.response.status === 404 ? 'Requested resource not found.' :
      error.response.status === 500 ? 'Server error. Please try again later.' :
      `Request failed (${error.response.status})`;

    return Promise.reject(new Error(genericMessage));
  }
);

export default apiClient;
