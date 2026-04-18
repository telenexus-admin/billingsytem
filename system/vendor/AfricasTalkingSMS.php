<?php

/**
 * Simple Africa's Talking SMS Integration
 * Lightweight implementation without external dependencies
 */

class AfricasTalkingSMS
{
    private $username;
    private $apiKey;
    private $baseUrl;
    
    public function __construct($username, $apiKey)
    {
        $this->username = $username;
        $this->apiKey = $apiKey;
        
        // Use sandbox or live URL based on username
        if ($username === 'sandbox') {
            $this->baseUrl = 'https://api.sandbox.africastalking.com/version1/messaging';
        } else {
            $this->baseUrl = 'https://api.africastalking.com/version1/messaging';
        }
    }
    
    public function send($options)
    {
        $url = $this->baseUrl;
        
        // Prepare POST data
        $postData = [
            'username' => $this->username,
            'to' => $options['to'],
            'message' => $options['message']
        ];
        
        // Add sender ID if provided
        if (!empty($options['from'])) {
            $postData['from'] = $options['from'];
        }
        
        // Convert to URL encoded format
        $postFields = http_build_query($postData);
        
        // Set up cURL
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postFields);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Accept: application/json',
            'Content-Type: application/x-www-form-urlencoded',
            'ApiKey: ' . $this->apiKey
        ]);
        
        // Execute request
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);
        
        // Handle cURL errors
        if ($error) {
            throw new Exception('cURL Error: ' . $error);
        }
        
        // Handle HTTP errors
        if ($httpCode !== 200 && $httpCode !== 201) {
            throw new Exception('HTTP Error: ' . $httpCode . ' - ' . $response);
        }
        
        // Parse response
        $result = json_decode($response, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Invalid JSON response: ' . $response);
        }
        
        return $result;
    }
}